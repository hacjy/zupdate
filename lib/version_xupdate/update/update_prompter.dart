import 'dart:async';

import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';

import '../../zupdate.dart';
import '../dialog/update_dialog.dart';
import '../utils/common.dart';
import '../utils/confirm_dialog.dart';
import '../utils/z_log.dart';
import 'entity/download_model.dart';
import 'entity/update_entity.dart';
import 'update.dart';

class UpdatePrompter {
  /// 版本更新信息
  UpdateEntity? updateEntity;
  final InstallCallback? onInstall;

  UpdateDialog? _dialog;

  double _progress = 0.0;
  //标志是否在下载中，避免失败重试和点击下载同时进行导致下载多次，有时会出现下载完成报解析包出错问题
  bool isDownloading = false;

  File? _apkFile;

  Timer? timer;
  DownloadModel model = DownloadModel();
  var downloadHandler;
  var retryDownloadCount = -1;
  final maxRetryCount = 4;

  void autoRetry(){
    if(retryDownloadCount>=maxRetryCount){//重试5次 0-4
      if (downloadHandler != null) {
        downloadHandler(model);
      }
      showDownloadFailDialog();
      retryDownloadCount = -1;
    }else{
      retryDownloadCount++;
      handleDownload();
    }
  }

  UpdatePrompter({required this.updateEntity, required this.onInstall});

  void setUpdateEntity(UpdateEntity entity) {
    updateEntity = entity;
  }

  bool isShow() {
    if (_dialog != null && _dialog!.isShowing()) {
      return true;
    }
    return false;
  }

  void dismissDialog() {
    if (_dialog != null && _dialog!.isShowing()) {
      _dialog!.dismiss();
    }
  }

  void show(BuildContext context) async {
    if (isShow()) {
      return;
    }
    String title =
        "Whether to upgrade to ${updateEntity!.versionName} version？";
    String updateContent = getUpdateContent();
    if (Platform.isAndroid) {
      _apkFile = await CommonUtils.getApkFile();
    }
    _dialog = UpdateDialog.showUpdate(
      context,
      title: title,
      updateContent: updateContent,
      extraHeight: 10,
      enableIgnore: updateEntity!.isIgnorable,
      isForce: updateEntity!.isForce,
      onUpdate: onUpdate,
      onInstall: doInstall,
    );
  }

  String getUpdateContent() {
    String targetSize =
    CommonUtils.getTargetSize(updateEntity!.apkSize.toDouble());
    String updateContent = "";
    if (targetSize.isNotEmpty) {
      updateContent += "New version size：$targetSize\n";
    }
    updateContent += updateEntity!.updateContent;
    return updateContent;
  }

  Future<void> onUpdate() async {
    EasyDebounce.debounce('onUpdate', const Duration(milliseconds: 1000), () {
    if (Platform.isIOS) {
      doInstall();
      return;
    }
    //重新下载 重置进度
    _progress = 0;
    // startTimer();
    handleDownload();});
  }

  void handleDownload(){
    downloadHandler ??= (DownloadModel downloadModel) {
      var status = downloadModel.downloadStatus;
      switch (status) {
        case DownloaderStatus.downloading:
          if (downloadModel.progress < _progress) {
            return;
          }
          _progress = downloadModel.progress;
          if (_progress <= 1.0001) {
            _dialog!.update(_progress);
          }
          break;
        case DownloaderStatus.paused:
          break;
        case DownloaderStatus.failed:
        // showToast("download failed！");
          showDownloadFailDialog();
          break;
        case DownloaderStatus.succeeded:
          doInstall();
          break;
        default:
      }
    };
    executeDownload(updateEntity!.downloadUrl,downloadHandler: downloadHandler);
  }

  showDownloadFailDialog() {
    var name = 'downloadFailDialog';
    if (name == CommonUtils.getDialogName()) {
      return;
    }
    isDownloading = false;
    _progress = 0.0;
    if (_dialog != null) {
      _dialog!.update(-0.01);
    }
    confirmDialog(
        name: name,
        shrink: true,
        // topIcon: Image.asset(
        //   BrandColorUtil.getLogo(),
        //   width: 40.w,
        //   height: 40.w,
        // ),
        // showClose: true,
        title: 'Updates',
        content: richLinkText(
            'Failed to download the installation package, please retry or click ',
            'the link',
            ' to download the file to install once it has been downloaded',
            updateEntity!.downloadUrl),
        // left: 'Download in browser',
        // leftColor: Colors.black,
        // onLeft: () {
        //   Get.back();
        //   launchUrl(Uri.parse(updateEntity!.downloadUrl),
        //       mode: LaunchMode.externalApplication);
        // },
        right: 'Retry',
        rightColor: Colors.red,
        onRight: () {
          Get.back();
          retryDownloadCount = -1;
          onUpdate();
        });
  }

  void executeDownload(String url, {downloadHandler}){
    try {
      zeroLog('executeDownload retryDownloadCount=$retryDownloadCount');
      String fileName = CommonUtils.apkName;
      // url = 'https://298383278759-fuji-prod-us-west-2.s3.us-west-2.amazonaws.com/kiosk/zero%26kiosk-latest.apk';

      model.url = url;
      model.status = DownloaderStatus.downloading;
      model.progress = 0;
      if (downloadHandler != null) {
        downloadHandler(model);
      }

      if(isDownloading){
        return;
      }
      isDownloading = true;
      Zupdate()
          .execute(
        url,
        destinationFilename: fileName,
      )
          .listen(
              (ZUpdateEvent event) {
            zeroLog('Zupdate status: ${event.status} : ${event.value} \n');
            ZUpdateStatus status = event.status;
            if (status == ZUpdateStatus.DOWNLOADING) {
              model.status = DownloaderStatus.downloading;
              double progress = 0;
              if ((event.value ?? '').isNotEmpty) {
                double progressD = double.parse(event.value ?? '0');
                progress = progressD / 100;
                model.progress = progress;
                if (downloadHandler != null) {
                  downloadHandler(model);
                }
              }
              if(progress>=1){
                isDownloading = false;
                model.progress = 1.0001;
                if (downloadHandler != null) {
                  downloadHandler(model);
                }
              }
            } else if (status == ZUpdateStatus.DOWNLOAD_ERROR ||
                status == ZUpdateStatus.INTERNAL_ERROR) {
              isDownloading = false;
              model.status = DownloaderStatus.failed;
              autoRetry();
            }

          },onError: (e){
        zeroLog('Zupdate error:$e');
      }
      );
    } catch (e) {
      zeroLog('Failed to make Zupdate. Details: $e');
    }
  }

  Widget richLinkText(
      String first, String linkText, String last, String url) {
    return Text.rich(TextSpan(style: TextStyle(fontSize: 28.sp), children: [
      TextSpan(text: first),
      TextSpan(
          text: linkText,
          style: TextStyle(
              fontSize: 28.sp,
              color: Colors.blueAccent,
              decoration: TextDecoration.underline),
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
            }),
      TextSpan(text: last),
    ]));
  }


  /// 安装
  void doInstall() {
    _dialog!.dismiss();
    onInstall!
        .call(_apkFile != null ? _apkFile!.path : updateEntity!.downloadUrl);
  }

}
