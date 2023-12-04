import 'package:fitween/src/controller/controller.dart';
import 'package:get/get.dart';

class BadgePageCont extends PageCont {
  static BadgePageCont get to => Get.find<BadgePageCont>();

  String get appBarTitle => LangCont.tr('appbar.badge');

  @override
  Future load() async {

  }

  @override
  String get loadKey => 'badge';

}