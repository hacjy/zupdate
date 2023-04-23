import 'dart:async';

import 'package:flutter/material.dart';
import 'package:zupdate/version_xupdate/update/entity/update_entity.dart';
import 'package:zupdate/version_xupdate/update/update.dart';

class UpdateVersion {

  static Future<void> appUpdate(BuildContext context) async {
    try {
      if(true){
      Map<String,dynamic> appInfo = {};
      appInfo['version_code'] = 1;
      appInfo['update_url'] = 'https://web.zeroand.com/assets/zero&kds_2.2.0.apk';
      appInfo['update_type'] = 1;
      appInfo['version_name'] = '1.0.0';
      appInfo['update_content'] ='update';
      update(context,appInfo);
      }
    }catch(e){
      print(e);
    }
  }


  static Future<void> update(BuildContext context, Map<String, dynamic> appInfo) async {
    try {
      final url = appInfo['update_url'];
        UpdateEntity entity = UpdateEntity(
            isForce: appInfo['update_type'] == 1,
            hasUpdate: true,
            isIgnorable: false,
            versionCode: appInfo['version_code'],
            versionName: appInfo['version_name'],
            updateContent: appInfo['update_content'],
            apkMd5: appInfo['app_md5']??'',
            // apkSize: appInfo['package_size'],
            downloadUrl: appInfo['update_url']
            );
        UpdateManager.checkUpdate(context,entity);
    } catch (e) {
      print(e);
    }
  }
}
