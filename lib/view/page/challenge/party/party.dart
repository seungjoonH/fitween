import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fitween/presenter/global.dart';
import 'package:fitween/presenter/page/challenge/party/main.dart';
import 'package:fitween/view/page/challenge/party/widget.dart';
import 'package:fitween/view/widget/widget/app_bar.dart';

class ChallengePartyMainPage extends StatelessWidget {
  const ChallengePartyMainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onTap: GlobalP.closeBottomBar,
      child: Scaffold(
        appBar: const FAppBar(title: '내 챌린지'),
        body: GetBuilder<ChallengePartyMainP>(
          builder: (controller) {
            return PartyMainView(party: controller.loadedParty);
          }
        ),
      ),
    );

  }
}
