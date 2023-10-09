import 'package:fitween/src/controller/controller.dart';
import 'package:get/get.dart';

class WeightPageCont extends PageCont {
  static WeightPageCont get to => Get.find<WeightPageCont>();

  @override
  Future load() async {}

  @override
  String get loadKey => 'weight';

  String get appBarTitle => LangCont.tr('appbar.weight');

}