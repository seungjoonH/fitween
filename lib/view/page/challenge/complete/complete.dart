/* 챌린지 완료 페이지 */

import 'package:fitween/model/class/database/party.dart';
import 'package:fitween/view/page/challenge/complete/widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fitween/view/widget/widget/app_bar.dart';

/// class
class ChallengePartyCompletePage extends StatelessWidget {
  const ChallengePartyCompletePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Party party = Get.arguments;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const FAppBar(color: Colors.transparent),
      body: ChallengePartyCompleteView(party: party),
    );
  }
}
