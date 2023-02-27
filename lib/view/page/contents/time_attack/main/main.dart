import 'package:fitween/view/page/contents/time_attack/main/widget.dart';
import 'package:fitween/view/widget/widget/app_bar.dart';
import 'package:flutter/material.dart';

class TimeAttackReadyPage extends StatelessWidget {
  const TimeAttackReadyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: FAppBar(),
      body: TimeAttackReadyView(),
    );
  }
}
