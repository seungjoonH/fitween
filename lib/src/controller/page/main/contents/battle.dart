import 'package:fitween/src/controller/controller.dart';
import 'package:get/get.dart';

class BattlePageCont extends PageCont {
  static BattlePageCont get to => Get.find<BattlePageCont>();

  @override
  Future load() async {}

  @override
  String get loadKey => 'battle';

  String get appBarTitle => LangCont.tr('appbar.battle');

}