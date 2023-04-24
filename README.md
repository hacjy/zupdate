# zupdate

Flutter plugin implementing version update.\
On Android it downloads the file (with progress reporting) and triggers app installation intent.\
On iOS it opens safari with specified ipa url.

You can refer to the following project:

[https://github.com/hacjy/zupdate/tree/master/example](https://github.com/hacjy/zupdate/tree/master/example)

** Important changes: **
* A beautiful set of updated UI has been provided.
* A flutter plugin 【install_plugin】 for install apk for android; and using url to go to app store for iOS.
* use get: ^4.6.5 and flutter_screenutil: ^5.5.3+2：\
1、in the pubspec.yaml file, add get: ^4.6.5 and flutter_screenutil: ^5.5.3+2 as a dependency.\
2、in the main.dart file, the root node needs to use the following code
``` dart
//根结点要要使用ScreenUtilInit和getx的GetMaterialApp
    return ScreenUtilInit(
        designSize: const Size(1920, 1080),
    minTextAdapt: true,
    splitScreenMode: true,
    builder: (context, Widget? widget) {

   return GetMaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('VersionUpdate Plugin App'),
          ),
          body: GestureDetector(
            onTap: (){
              UpdateVersion.appUpdate(context);
            },
            child: const Center(child: SizedBox(
              width: 100,
              height: 100,
              child: Text('Check Update'),
            ),)
          )
      ),
    );});
  }
```

## Usage

To use this plugin, add `zupdate` as a [dependency in your `pubspec.yaml` file](https://flutter.io/platform-plugins/).
```
// pub 集成
dependencies:
  zupdate: ^0.1.0

//github  集成
dependencies:
  zupdate:
    git:
      url: git://github.com/hacjy/zupdate.git
      ref: master
```

## Example

``` dart
// IMPORT PACKAGE
import 'package:zupdate/version_xupdate/update/entity/update_entity.dart';
import 'package:zupdate/version_xupdate/update/update.dart';
//版本更新
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
```


## install_plugin Example

``` dart
// IMPORT PACKAGE
import 'package:zupdate/install_plugin.dart';

 // 安装apk
static void installAPP(String uri) async {
    if (Platform.isAndroid) {
        String packageName = await CommonUtils.getPackageName();
        InstallPlugin.installApk(uri, packageName);
    } else {
        InstallPlugin.gotoAppStore(uri);
    }
}
```

## Getting Started

This project is a starting point for a Flutter
[plug-in package](https://flutter.dev/developing-packages/),
a specialized package that includes platform-specific implementation code for
Android and/or iOS.

For help getting started with Flutter development, view the
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

