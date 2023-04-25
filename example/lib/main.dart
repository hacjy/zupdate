import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zupdate_example/update_version.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //根结点要要使用ScreenUtilInit和getx的GetMaterialApp
    return ScreenUtilInit(
        designSize: const Size(1920, 1080),
    minTextAdapt: true,
    splitScreenMode: true,
    builder: (context, Widget? widget) {

   return GetMaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Zupdate Plugin Example'),
          ),
          body:  Center(child: ElevatedButton(
              onPressed: () {  UpdateVersion.appUpdate(context);},
              child: Text('Check Update'),
            ),)
      ),
    );});
  }
}
