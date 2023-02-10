import 'package:get/get.dart';
import 'package:fitween/model/class/json/challenge.dart';

/// class
class ChallengeDetail {
  /// static methods
  // 챌린지 상세 페이지로 이동
  static void toChallengeDetail(Challenge challenge) {
    Get.toNamed('/challenge/detail', arguments: challenge);
  }
}