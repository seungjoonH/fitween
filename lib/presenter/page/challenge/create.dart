import 'package:fitween/model/class/database/user/info.dart';
import 'package:fitween/presenter/page/challenge/party/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../global/theme.dart';
import '../../../model/class/database/party.dart';
import '../../../model/class/database/user/party.dart';
import '../../../model/class/json/challenge.dart';
import '../../../model/enum/dialog.dart';
import '../../../model/enum/difficulty.dart';
import '../../../view/widget/function/dialog.dart';
import '../../../view/widget/widget/text.dart';
import '../../model/user/info.dart';
import '../../model/user/party.dart';
import 'main.dart';

/// class
class ChallengeCreateP extends GetxController {
  /// static methods
  // 챌린지 생성 페이지로 이동
  static void toChallengeCreate(Challenge challenge) {
    final challengeCreateP = Get.find<ChallengeCreateP>();
    challengeCreateP.init();
    // Get.toNamed('/challenge/create', arguments: challenge);
    challengeCreateP.challengeCreateButtonPressed(challenge);
  }

  /// attributes
  Difficulty difficulty = Difficulty.easy;

  /// methods
  // 초기화
  void init() {
    difficulty = Difficulty.easy;
    update();
  }

  // 난이도 변경
  void changeDifficulty(Difficulty diff) {
    difficulty = diff;
    update();
  }

  // 챌린지 생성 버튼 클릭 시
  void challengeCreateButtonPressed(Challenge challenge) async {
    final userPartyP = Get.find<UserPartyP>();
    String code = await userPartyP.createMyParty(challenge, difficulty);
    showChallengeCreatedDialog(code);
  }

  // 챌린지 생성 팝업
  void showChallengeCreatedDialog(String code) {
    showPDialog(
      title: '챌린지 생성',
      content: Column(
        children: [
          Center(
            child: FText(
              code,
              style: textTheme.titleLarge,
              color: FTheme.colorB,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: FText('챌린지가 생성되었습니다.'),
          ),
        ],
      ),
      type: DialogType.mono,
      onPressed: () {
        Get.back();
        final userPartyP = Get.find<UserPartyP>();
        ChallengeMainP.toChallengeMain();
        ChallengePartyMainP.toChallengePartyMain(
          userPartyP.loggedUser.parties[code]!,
        );
      },
    );
  }
}
