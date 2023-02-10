import 'package:get/get.dart';

/// class
class QuestMain extends GetxController {
  // 월간 도전과제 메인 페이지로 이동
  static void toQuestMain() {
    final questMain = Get.find<QuestMain>();
    Get.toNamed('/quest/main');
    questMain.init();
  }

  void init() => update();
}
