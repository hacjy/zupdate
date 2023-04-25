import 'package:zupdate/version_xupdate/utils/common.dart';

String getDefaultTitle(String versionName){
  var text =  "Whether to upgrade to $versionName version？";
  if(!CommonUtils.defaultEnLanguage){
    text = "是否升级到$versionName版本？";
  }
return text;
}

String getTotalSizeTxt(targetSize){
  var text = "New version size：$targetSize\n";
  if(!CommonUtils.defaultEnLanguage){
    text = "新版本大小：$targetSize\n";
  }
  return text;
}
String getUpdateTitle(){
  var text = "Updates";
  if(!CommonUtils.defaultEnLanguage){
    text = "更新";
  }
  return text;
}
String getDownloadTip1(){
  var text = "Failed to download the installation package, please retry or click ";
  if(!CommonUtils.defaultEnLanguage){
    text = "下载安装包失败，请重试或单击 ";
  }
  return text;
}
String getDownloadTip2(){
  var text = "the link";
  if(!CommonUtils.defaultEnLanguage){
    text = "链接";
  }
  return text;
}
String getDownloadTip3(){
  var text = " to download the file to install once it has been downloaded";
  if(!CommonUtils.defaultEnLanguage){
    text = " 下载文件后再进行安装";
  }
  return text;
}
String getRetryTxt(){
  var text = "Retry";
  if(!CommonUtils.defaultEnLanguage){
    text = "重新下载";
  }
  return text;
}

String getBtnUpdateTxt(){
  var text = "Update";
  if(!CommonUtils.defaultEnLanguage){
    text = "更新";
  }
  return text;
}

String getBtnInstallTxt(){
  var text = "Install";
  if(!CommonUtils.defaultEnLanguage){
    text = "安装";
  }
  return text;
}

String getBtnIgnoreTxt() {
  var text = "Ignore";
  if (!CommonUtils.defaultEnLanguage) {
    text = "忽略";
  }
  return text;
}