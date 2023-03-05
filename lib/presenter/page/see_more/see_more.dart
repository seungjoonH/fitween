import 'package:get/get.dart';

class SeeMoreP extends GetxController {
  static void toSeeMore([bool initialize = false]) async {
    Get.offAllNamed('/seeMore');
    if (initialize) await init();
  }
  static Future init() async {}
}