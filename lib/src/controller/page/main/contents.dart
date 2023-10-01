import 'package:fitween/src/controller/controller.dart';
import 'package:get/get.dart';

class ContentsPageCont extends MainPageCont {
  static ContentsPageCont get to => Get.find<ContentsPageCont>();

  String get appBarTitle => LangCont.tr('appbar.contents');

  @override
  String get loadKey => 'contents';

  @override
  Future load() async {}
}