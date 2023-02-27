import 'package:fitween/presenter/page/contents/challenge/party.dart';
import 'package:fitween/view/page/contents/party/widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fitween/view/widget/widget/app_bar.dart';

class PartyPage extends StatelessWidget {
  const PartyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        appBar: const FAppBar(title: '내 챌린지'),
        body: GetBuilder<PartyP>(
          builder: (partyP) {
            return PartyView(party: partyP.loadedParty);
          }
        ),
      ),
    );
  }
}
