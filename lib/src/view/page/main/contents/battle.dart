import 'package:fitween/src/controller/page.dart';
import 'package:fitween/src/view/page/page.dart';
import 'package:fitween/src/view/widget/widget.dart';
import 'package:flutter/material.dart';

class BattlePage extends FPage {
  const BattlePage({super.key});

  @override
  FPageState<BattlePage> createState() => _BattlePageState();
}

class _BattlePageState extends FPageState<BattlePage> {
  @override
  PageCont get cont => ChallengePageCont.to;

  @override
  Widget buildPage(BuildContext context) {
    return const FScaffold();
  }
}
