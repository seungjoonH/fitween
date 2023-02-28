import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fitween/presenter/global.dart';
import 'package:fitween/view/page/challenge/party/widget.dart';
import 'package:fitween/view/widget/widget/app_bar.dart';
import '../../../../presenter/page/contents/challenge/party.dart';

class ChallengePartyMainPage extends StatelessWidget {
  const ChallengePartyMainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const FAppBar(title: '챌린지'),
      body: GetBuilder<PartyP>(builder: (controller) {
        return PartyMainView(party: controller.loadedParty);
      }),
    );
  }
}
