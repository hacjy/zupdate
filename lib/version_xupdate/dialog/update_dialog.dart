import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/common.dart';
import 'number_progress.dart';

///版本更新加提示框
class UpdateDialog {
  late BuildContext _context;
  late UpdateWidget _widget;

  UpdateDialog(BuildContext context,
      {double width = 0.0,
      required String title,
      required String updateContent,
      required VoidCallback onUpdate,
      required VoidCallback onInstall,
      double titleTextSize = 16.0,
      double contentTextSize = 14.0,
      double buttonTextSize = 14.0,
      double progress = -1.0,
      Color progressBackgroundColor = const Color(0xFFFFCDD2),
      Image? topImage,
      double extraHeight = 5.0,
      double radius = 4.0,
      Color themeColor = Colors.red,
      bool enableIgnore = false,
      VoidCallback? onIgnore,
      bool isForce = false,
      String? updateButtonText,
      String? ignoreButtonText,
      VoidCallback? onClose}) {
    _context = context;
    _widget = UpdateWidget(
        width: width,
        title: title,
        updateContent: updateContent,
        onUpdate: onUpdate,
        onInstall: onInstall,
        titleTextSize: titleTextSize,
        contentTextSize: contentTextSize,
        buttonTextSize: buttonTextSize,
        progress: progress,
        topImage: topImage,
        extraHeight: extraHeight,
        radius: radius,
        themeColor: themeColor,
        progressBackgroundColor: progressBackgroundColor,
        enableIgnore: enableIgnore,
        onIgnore: onIgnore,
        isForce: isForce,
        updateButtonText: updateButtonText ?? 'Update',
        ignoreButtonText: ignoreButtonText ?? 'Ignore',
        onClose: onClose ?? () => dismiss());
  }

  /// 显示弹窗
  Future<bool> show() {
    try {
      if (isShowing()) {
        return Future<bool>.value(false);
      }
      Get.dialog(
        WillPopScope(
            onWillPop: () {
              return Future<bool>.value(false);
            },
            child: _widget),
        name: 'updateVersionDialog',
        barrierDismissible: false,
      );
      return Future<bool>.value(true);
    } catch (err) {
      return Future<bool>.value(false);
    }
  }

  /// 隐藏弹窗
  Future<bool> dismiss() {
    try {
      if (isShowing()) {
        Navigator.pop(_context);

        return Future<bool>.value(true);
      } else {
        return Future<bool>.value(false);
      }
    } catch (err) {
      return Future<bool>.value(false);
    }
  }

  /// 是否显示
  // bool isShowing() {
  //   return _isShowing;
  // }
  bool isShowing() {
    return CommonUtils.getDialogName() == 'updateVersionDialog';
  }

  /// 更新进度
  void update(double progress) {
    if (isShowing()) {
      _widget.update(progress);
    }
  }

  /// 显示版本更新提示框
  static UpdateDialog showUpdate(BuildContext context,
      {double width = 0.0,
      required String title,
      required String updateContent,
      required VoidCallback onUpdate,
      required VoidCallback onInstall,
      double titleTextSize = 16.0,
      double contentTextSize = 14.0,
      double buttonTextSize = 14.0,
      double progress = -1.0,
      Color progressBackgroundColor = const Color(0xFFFFCDD2),
      Image? topImage,
      double extraHeight = 5.0,
      double radius = 4.0,
      Color themeColor = Colors.red,
      bool enableIgnore = false,
      VoidCallback? onIgnore,
      String? updateButtonText,
      String? ignoreButtonText,
      bool isForce = false}) {
    final UpdateDialog dialog = UpdateDialog(context,
        width: width,
        title: title,
        updateContent: updateContent,
        onUpdate: onUpdate,
        onInstall: onInstall,
        titleTextSize: titleTextSize,
        contentTextSize: contentTextSize,
        buttonTextSize: buttonTextSize,
        progress: progress,
        topImage: topImage,
        extraHeight: extraHeight,
        radius: radius,
        themeColor: themeColor,
        progressBackgroundColor: progressBackgroundColor,
        enableIgnore: enableIgnore,
        isForce: isForce,
        updateButtonText: updateButtonText,
        ignoreButtonText: ignoreButtonText,
        onIgnore: onIgnore);
    dialog.show();
    return dialog;
  }
}

// ignore: must_be_immutable
class UpdateWidget extends StatelessWidget {
  /// 对话框的宽度
  final double width;

  /// 升级标题
  final String title;

  /// 更新内容
  final String updateContent;

  /// 标题文字的大小
  final double titleTextSize;

  /// 更新文字内容的大小
  final double contentTextSize;

  /// 按钮文字的大小
  final double buttonTextSize;

  /// 顶部图片
  final Widget? topImage;

  /// 拓展高度(适配顶部图片高度不一致的情况）
  final double extraHeight;

  /// 边框圆角大小
  final double radius;

  /// 主题颜色
  final Color themeColor;

  /// 更新事件
  final VoidCallback onUpdate;
  final VoidCallback onInstall;

  /// 可忽略更新
  final bool enableIgnore;

  /// 更新事件
  final VoidCallback? onIgnore;

  double progress;

  /// 进度条的背景颜色
  final Color progressBackgroundColor;

  /// 更新事件
  final VoidCallback? onClose;

  /// 是否是强制更新
  final bool isForce;

  /// 更新按钮内容
  final String updateButtonText;

  /// 忽略按钮内容
  final String ignoreButtonText;

  UpdateWidget({
    Key? key,
    this.width = 0.0,
    required this.title,
    required this.updateContent,
    required this.onUpdate,
    required this.onInstall,
    this.titleTextSize = 16.0,
    this.contentTextSize = 14.0,
    this.buttonTextSize = 14.0,
    this.progress = -1.0,
    this.progressBackgroundColor = const Color(0xFFFFCDD2),
    this.topImage,
    this.extraHeight = 5.0,
    this.radius = 4.0,
    this.themeColor = Colors.red,
    this.enableIgnore = false,
    this.onIgnore,
    this.isForce = false,
    this.updateButtonText = 'Update',
    this.ignoreButtonText = 'Ignore',
    this.onClose,
  }) : super(key: key);

  var progressObx = (-0.01).obs;

  void update(double progressValue) {
    progressObx.value = progressValue;
  }

  @override
  Widget build(BuildContext context) {
    final double dialogWidth = width <= 0 ? getFitWidth(context) * 0.5 : width;
    return Material(
        type: MaterialType.transparency,
        child: Container(
          child: SizedBox(
            width: dialogWidth,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: dialogWidth,
                  child: topImage ??
                      Image.asset('assets/img/update_bg_app_top.png',
                          fit: BoxFit.fill),
                ),
                Container(
                  width: dialogWidth,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, top: 8, bottom: 8),
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(radius),
                          bottomRight: Radius.circular(radius)),
                    ),
                  ),
                  child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(top: extraHeight),
                            child: Text(title,
                                style: TextStyle(
                                    fontSize: titleTextSize,
                                    color: Colors.black)),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Text(updateContent,
                                style: TextStyle(
                                    fontSize: contentTextSize,
                                    color: const Color(0xFF666666))),
                          ),
                          Obx(() =>
                          (progressObx.value < 0 || progressObx.value > 1)?
                          Column(children: <Widget>[
                            FractionallySizedBox(
                              widthFactor: 1,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  textStyle: MaterialStateProperty.all(
                                      TextStyle(fontSize: buttonTextSize)),
                                  foregroundColor:
                                  MaterialStateProperty.all(Colors.white),
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(5))),
                                  elevation: MaterialStateProperty.all(0),
                                  backgroundColor: MaterialStateProperty.all(
                                      themeColor),
                                ),
                                onPressed: progressObx.value > 1
                                    ? onInstall
                                    : onUpdate,
                                child: Text(progressObx.value > 1
                                    ? 'Install'
                                    : updateButtonText),
                              ),
                            ),
                            if (enableIgnore && onIgnore != null)
                              FractionallySizedBox(
                                  widthFactor: 1,
                                  child: TextButton(
                                    style: ButtonStyle(
                                      tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                      textStyle: MaterialStateProperty.all(
                                          TextStyle(
                                              fontSize: buttonTextSize)),
                                      foregroundColor: MaterialStateProperty.all(
                                          const Color(0xFF666666)),
                                      shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(5))),
                                    ),
                                    child: Text(ignoreButtonText),
                                    onPressed: onIgnore,
                                  ))
                            else
                              const SizedBox()
                          ])
                              :
                          NumberProgress(
                              value: progressObx.value,
                              backgroundColor: progressBackgroundColor,
                              valueColor: themeColor,
                              padding: const EdgeInsets.symmetric(vertical: 10))),
                        ],
                      )),
                ),
                if (!isForce)
                  Column(children: <Widget>[
                    const SizedBox(
                        width: 1.5,
                        height: 50,
                        child: DecoratedBox(
                            decoration: BoxDecoration(color: Colors.white))),
                    IconButton(
                      iconSize: 30,
                      constraints:
                      const BoxConstraints(maxHeight: 30, maxWidth: 30),
                      padding: EdgeInsets.zero,
                      icon: Image.asset('assets/img/update_ic_close.png'),
                      onPressed: onClose,
                    )
                  ])
                else
                  const SizedBox()
              ],
            ),
          ),
        ));
  }

  double getFitWidth(BuildContext context) {
    return min(getScreenHeight(context), getScreenWidth(context));
  }

  double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }
}
