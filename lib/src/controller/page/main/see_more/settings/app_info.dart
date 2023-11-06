import 'package:basic_utils/basic_utils.dart';
import 'package:fitween/global/global.dart';
import 'package:fitween/route.dart';
import 'package:fitween/src/controller/controller.dart';
import 'package:get/get.dart';

enum AppInfoMenu {
  fitween, ossLicense, termsOfUse, privacyPolicy, report, version, support;

  String get _tr => 'settings.app-info-menu';
  String get locale => LangCont.tr('$_tr.${name.toSkewerCase}');
}

class AppInfoPageCont extends PageCont {
  static AppInfoPageCont get to => Get.find<AppInfoPageCont>();

  String get appBarTitle => LangCont.tr('appbar.app-info');

  void menuPressed(AppInfoMenu menu) {
    switch (menu) {
      case AppInfoMenu.fitween: FRoute.toFitween(); break;
      case AppInfoMenu.ossLicense: FRoute.toOSSLicenses(); break;
      case AppInfoMenu.termsOfUse: FRoute.toTermsInUse(); break;
      case AppInfoMenu.privacyPolicy: FRoute.toPrivacyPolicy(); break;
      case AppInfoMenu.report: FRoute.toReport(); break;
      case AppInfoMenu.version: FRoute.toVersion(); break;
      case AppInfoMenu.support: FRoute.toSupport(); break;
    }
  }

  @override
  Future load() async {}

  @override
  String get loadKey => 'app-info';
}