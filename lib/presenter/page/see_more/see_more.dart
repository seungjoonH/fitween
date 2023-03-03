/* 마이 페이지 프리젠터 */
import 'package:get/get.dart';

/// class
class SeeMoreP extends GetxController {
  /// static methods
  // 마이 페이지로 이동
  static void toSeeMore() async {
    // await GlobalP.closeBottomBar();
    Get.toNamed('/see_more');
  }
  static Future init() async {}
}