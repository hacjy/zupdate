# zupdate

[![pub package](https://img.shields.io/pub/v/zupdate.svg)](https://pub.dartlang.org/packages/zupdate)

A simple plugin version update for flutter.\
On Android it downloads the file (with progress reporting) and triggers app installation intent.\
On iOS it opens safari with specified ipa url.

You can refer to the following project:

[https://github.com/hacjy/zupdate/tree/master/example](https://github.com/hacjy/zupdate/tree/master/example)

## Important changes
* A beautiful set of updated UI has been provided.
* A flutter plugin 【install_plugin】 for install apk for android; and using url to go to app store for iOS.
*  **Required settings：** \
    1、in the pubspec.yaml file, **add get: ^4.6.5 and flutter_screenutil: ^5.5.3+2 as a dependency.**\
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
    3、 in the pubspec.yaml file, use the following code
    ```
    assets:
    - assets/
    - assets/img/
    ```
    then **add update_bg_app_top.png and update_ic_close.png to assets/img.** These two images are copied from assets/img in example.
* Support custom header image, button theme color, progress bar color, title, height of title from header image, apk file name, whether to display Chinese text
    ```
    UpdateConfig(
         apkName: 'test.apk',
         title: 'test update version',
         themeColor: Colors.blueAccent,
         progressBackgroundColor: Colors.blue.withOpacity(0.3),
         extraHeight: 10,
         chLanguage: true)
    ```

## Usage

To use this plugin, add `zupdate` as a [dependency in your `pubspec.yaml` file](https://flutter.io/platform-plugins/).
```
//pub 集成
dependencies:
  zupdate: ^0.4.0

//github  集成
dependencies:
  zupdate:
    git:
      url: git://github.com/hacjy/zupdate.git
      ref: master
```

## Preview

<img src="https://github.com/hacjy/zupdate/blob/master/example/assets/screenshot/Screenshot_20230424_111039_1.jpg?raw=true" width="360" height="202"/> <img src="https://github.com/hacjy/zupdate/blob/master/example/assets/screenshot/Screenshot_20230424_111051_2.jpg?raw=true" width="360" height="202"/>
<img src="https://github.com/hacjy/zupdate/blob/master/example/assets/screenshot/Screenshot_20230424_111203_3.jpg?raw=true" width="360" height="202"/> <img src="https://github.com/hacjy/zupdate/blob/master/example/assets/screenshot/Screenshot_20230424_111236_retry.jpg?raw=true" width="360" height="202"/>

## Example

``` dart
// IMPORT PACKAGE
import 'package:zupdate/version_xupdate/update/entity/update_entity.dart';
import 'package:zupdate/version_xupdate/update/flutter_update.dart';

//版本更新
 static Future<void> update(
      BuildContext context, Map<String, dynamic> appInfo) async {
    try {
      final url = appInfo['update_url'];
      UpdateEntity entity = UpdateEntity(
          isForce: appInfo['update_type'] == 1,
          hasUpdate: true,
          isIgnorable: false,
          versionCode: appInfo['version_code'],
          versionName: appInfo['version_name'],
          updateContent: appInfo['update_content'],
          apkMd5: appInfo['app_md5'] ?? '',
          // apkSize: appInfo['package_size'],
          downloadUrl: appInfo['update_url']);
      UpdateManager.checkUpdate(context, entity,
          //支持自定义头部图片，按钮主题色，进度条颜色，标题,标题距离头部图片的高度,apk文件名,是否显示中文文本
          // config: UpdateConfig(
              // apkName: 'test.apk',
              // title: 'test update version',
              // themeColor: Colors.blueAccent,
              // progressBackgroundColor: Colors.blue.withOpacity(0.3),
              // extraHeight: 10,
              // chLanguage: true)
      );
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

