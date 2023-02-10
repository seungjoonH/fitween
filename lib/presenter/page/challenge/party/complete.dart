import 'package:get/get.dart';
import 'package:fitween/model/class/database/party.dart';

/// class
class ChallengePartyComplete {
  /// static methods
  // 챌린지 완료 페이지로 이동
  static void toChallengePartyComplete(Party party) {
    Get.toNamed('/challenge/party/complete', arguments: party);
  }
}