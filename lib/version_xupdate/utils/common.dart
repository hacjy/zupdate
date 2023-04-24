import 'dart:io';

import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:zupdate/install_plugin.dart';

import 'z_log.dart';

class CommonUtils {
  CommonUtils._internal();

  static const String apkName = 'update.apk';

  static String getTargetSize(double kbSize) {
    if (kbSize <= 0) {
      return "";
    } else if (kbSize < 1024) {
      return "${kbSize.toStringAsFixed(1)}KB";
    } else if (kbSize < 1048576) {
      return "${(kbSize / 1024).toStringAsFixed(1)}MB";
    } else {
      return "${(kbSize / 1048576).toStringAsFixed(1)}GB";
    }
  }

  static int currentTimeMillis() {
    return DateTime.now().millisecondsSinceEpoch;
  }

  ///获取应用包信息
  static Future<PackageInfo> getPackageInfo() {
    return PackageInfo.fromPlatform();
  }

  ///获取应用版本号
  static Future<String> getVersionCode() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.buildNumber;
  }

  ///获取应用包名
  static Future<String> getPackageName() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.packageName;
  }

  /// 安装apk
  static void installAPP(String uri) async {
    if (Platform.isAndroid) {
      String packageName = await CommonUtils.getPackageName();
      InstallPlugin.installApk(uri, packageName);
    } else {
      InstallPlugin.gotoAppStore(uri);
    }
  }

  /// /data/user/0/XXX.XXX.XXX/files/z_update/XXX.apk
  static Future<File?> getApkFile(
      {String fileName = apkName}) async {
    try {
      var path = await InstallPlugin.getApkDirectory();
      String dataDir = "$path";
      //File full path
      final String destination = "$dataDir/$fileName";
      zeroLog('apk file path = $destination');
      return File(destination);
    } catch (e) {
      zeroLog(e);
      return null;
    }
  }


  ///文件没有校验完整性 所以每次安装完或重启app需要手动删除下
  static Future<void> deleteApkFile(
      {String fileName = apkName}) async {
    try {
      File? file = await getApkFile(fileName: fileName);
      if (file == null) {
        return;
      }
      bool isExist = await file!.exists();
      if (isExist) {
        await file!.delete();
      }
    } catch (e) {
      zeroLog(e);
    }
  }

  static String getDialogName() {
    return Get.routing.route?.settings.name ?? '';
  }
}
