/* 마이 페이지 프리젠터 */
import 'package:get/get.dart';
import 'package:fitween/presenter/global.dart';

/// class
class MyMain extends GetxController {
  /// static methods
  // 마이 페이지로 이동
  static void toMyMain() async {
    await GlobalPresenter.closeBottomBar();
    Get.toNamed('/my/main');
  }
}
