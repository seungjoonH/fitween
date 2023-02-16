import 'package:fitween/view/page/challenge/time_attack/time_attack_main/widget.dart';
import 'package:fitween/view/widget/widget/app_bar.dart';
import 'package:flutter/material.dart';

class TimeAttackMainPage extends StatelessWidget {
  const TimeAttackMainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: FAppBar(),
      body: TimeAttackMainPageView(),
    );
  }
}
