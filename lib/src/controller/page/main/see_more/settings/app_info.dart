import 'package:fitween/src/controller/controller.dart';
import 'package:get/get.dart';

class AppInfoPageCont extends PageCont {
  static AppInfoPageCont get to => Get.find<AppInfoPageCont>();

  String get appBarTitle => LangCont.tr('appbar.app-info');

  @override
  Future load() async {}

  @override
  String get loadKey => 'app-info';
}