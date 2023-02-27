import 'package:get/get.dart';

/// class
class ChallengeLevelP extends GetxController {
  static void toChallengeLevel() async {
    Get.toNamed('/challengeLevel');
  }

  static void backPressed() {
    Get.back();
  }
}

