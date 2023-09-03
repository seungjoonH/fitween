import 'package:fitween/src/controller/controller.dart';
import 'package:get/get.dart';

class ContentsPageCont extends MainPageCont {
  static ContentsPageCont get to => Get.find<ContentsPageCont>();

  @override
  String get loadKey => 'contents';

  @override
  Future load() async {}
}