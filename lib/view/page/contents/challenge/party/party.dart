import 'package:fitween/view/page/contents/challenge/party/widget.dart';
import 'package:flutter/material.dart';
import 'package:fitween/view/widget/widget/app_bar.dart';

class PartyPage extends StatelessWidget {
  const PartyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: const Scaffold(
        appBar: FAppBar(title: '내 챌린지'),
        body: PartyView(),
      ),
    );
  }
}
