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
      appInfo['update_url'] = 'https://ip874153655.mobgslb.tbcache.com/fs08/2023/04/19/9/106_52914c9532e05a1cf526e4ebef3d5f60.apk?yingid=wdj_web&fname=壁纸多多&productid=2011&pos=wdj_web%2Fdetail_normal_dl%2F0&appid=5784049&packageid=201186966&apprd=5784049&iconUrl=http%3A%2F%2Fandroid-artworks.25pp.com%2Ffs08%2F2023%2F04%2F14%2F11%2F110_43f6034c7a07c3bf64dda66fe76ad79f_con.png&pkg=com.shoujiduoduo.wallpaper&did=d0574aba8aa68d9ac1b465fc1311bec4&vcode=6006030&md5=b6c5624388fb4099438e14e07a34fe4e&ali_redirect_domain=alissl.ucdl.pp.uc.cn&ali_redirect_ex_ftag=93856608cfb59b10c2c55901d52c4553073aa566262ee3d3&ali_redirect_ex_tmining_ts=1682305489&ali_redirect_ex_tmining_expire=3600&ali_redirect_ex_hot=100';
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
