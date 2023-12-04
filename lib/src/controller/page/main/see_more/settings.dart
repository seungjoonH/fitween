import 'package:fitween/global/global.dart';
import 'package:fitween/route.dart';
import 'package:fitween/src/controller/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum SettingsMenu {
  general, account, myInfo, appInfo;

  IconData get icon => [
    Icons.settings_rounded,
    Icons.account_circle_rounded,
    Icons.manage_accounts_rounded,
    Icons.info_rounded,
  ][index];
  String get _tr => 'settings';
  String get locale => LangCont
      .tr('$_tr.${name.toSkewerCase}');
}

class SettingsPageCont extends PageCont {
  static SettingsPageCont get to => Get.find<SettingsPageCont>();

  String get appBarTitle => LangCont.tr('appbar.settings');

  void menuPressed(SettingsMenu menu) {
    switch (menu) {
      case SettingsMenu.general: FRoute.toGeneralSetting(); return;
      case SettingsMenu.account: FRoute.toAccount(); break;
      case SettingsMenu.myInfo: FRoute.toMyInfo(); return;
      case SettingsMenu.appInfo: FRoute.toAppInfo(); return;
    }
  }

  @override
  Future load() async {}

  @override
  String get loadKey => 'settings';

}