import 'package:flutter/material.dart';

class UpdateConfig {
  String? title;
  Color? progressBackgroundColor;
  Color? themeColor;
  Image? topImage;
  //title距离topImage的高度
  double? extraHeight;
  String? apkName;
  //重试次数
  int? retryCount;
  //是否设置为中文语言，默认false
  bool chLanguage;

  UpdateConfig({
    this.title,
    this.progressBackgroundColor,
    this.themeColor,
    this.topImage,
    this.extraHeight,
    this.apkName,
    this.retryCount,
    this.chLanguage = false,
  });
}
