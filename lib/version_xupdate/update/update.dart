import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../utils/common.dart';
import 'update_prompter.dart';
import 'entity/update_entity.dart' as XupdateEntity;

/// 版本更新管理
class UpdateManager {
  static UpdatePrompter? prompter;

  static bool isUpdateDialogShow() {
    if (prompter == null) return false;
    return prompter!.isShow();
  }

  static void checkUpdate(BuildContext context,
      XupdateEntity.UpdateEntity params) {
    prompter ??= UpdatePrompter(
        updateEntity: params,
        onInstall: (String filePath) {
          CommonUtils.installAPP(filePath);
        });
    if (!prompter!.isShow()) {
      prompter!.setUpdateEntity(params);
      prompter!.show(context);
    }
  }

  static void closePrompter() {
    if (prompter != null && prompter!.isShow()) {
      prompter!.dismissDialog();
      prompter = null;
    }
  }
}

typedef InstallCallback = Function(String filePath);
