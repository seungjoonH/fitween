import 'package:fitween/global/string.dart';
import 'package:fitween/main.dart';
import 'package:fitween/route.dart';
import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/model/class/dao.dart';
import 'package:fitween/src/model/class/model.dart';
import 'package:fitween/src/view/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class DialogCont {
  static void showNetworkErrorDialog() {
    String title = LangCont.tr('error.no-network.title');
    String text = LangCont.tr('error.no-network.text');
    showFDialog(
      title: title,
      content: FText(
        text,
        style: ThemeCont.to.bodySmall,
        color: ThemeCont.error,
        maxLines: 0,
      ),
      type: DialogType.mono,
      onPressed: Get.back,
    );
  }

  static void showVersionInvalidDialog() {
    String title = LangCont.tr('error.version-invalid.title');
    String text = LangCont.tr('error.version-invalid.text', namedArgs: {'version': versionNumber});
    showFDialog(
      title: title,
      content: FText(
        text,
        style: ThemeCont.to.bodySmall,
        maxLines: 0,
      ),
      type: DialogType.mono,
      onPressed: Get.back,
    );
  }

  static Future showResponseTimeoutErrorDialog() async {
    String title = LangCont.tr('error.time-out.title');
    String text = LangCont.tr('error.time-out.text');
    await showFDialog(
      title: title,
      content: FText(
        text,
        style: ThemeCont.to.bodySmall,
        maxLines: 0,
      ),
      type: DialogType.mono,
    );
    AuthCont.fLogout();
    FRoute.toLogin();
  }
}