import 'package:basic_utils/basic_utils.dart';
import 'package:fitween/route.dart';
import 'package:fitween/src/controller/controller.dart';
import 'package:get/get.dart';

enum SettingsMenu {
  general, appInfo;

  String get _tr => 'settings';
  String get locale => LangCont
      .tr('$_tr.${StringUtils.camelCaseToLowerUnderscore(name).replaceAll('_', '-')}');
}

class SettingsPageCont extends PageCont {
  static SettingsPageCont get to => Get.find<SettingsPageCont>();

  String get appBarTitle => LangCont.tr('appbar.settings');

  void menuPressed(SettingsMenu menu) {
    switch (menu) {
      case SettingsMenu.general: FRoute.toGeneralSetting(); return;
      case SettingsMenu.appInfo: FRoute.toAppInfo(); return;
    }
  }

  @override
  Future load() async {}

  @override
  String get loadKey => 'settings';

}