import 'package:fitween/global/theme.dart';
import 'package:fitween/model/enum/dialog.dart';
import 'package:fitween/model/enum/difficulty.dart';
import 'package:fitween/presenter/model/json/party.dart';
import 'package:fitween/presenter/page/contents/challenge/party.dart';
import 'package:fitween/view/widget/function/dialog.dart';
import 'package:fitween/view/widget/widget/text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fitween/model/class/json/challenge.dart';

/// class
class ChallengeDetailP {
  /// static methods
  // 챌린지 상세 페이지로 이동
  static Future toChallengeDetail(Challenge challenge) async {
    Get.toNamed('/contents/challengeDetail', arguments: challenge);
  }

  // 챌린지 생성 버튼 클릭 시
  void challengeCreateButtonPressed(Challenge challenge) async {
    final userPartyP = Get.find<UserPartyP>();
    String code = await userPartyP.createMyParty(challenge, Difficulty.easy);
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
        PartyP.toParty(userPartyP.loggedUser.parties[code]!);
      },
    );
  }
}
