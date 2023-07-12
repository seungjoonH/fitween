import 'package:fitween/view/page/contents/workout/ready/widget.dart';
import 'package:fitween/view/widget/widget/app_bar.dart';
import 'package:flutter/material.dart';

class WorkoutReadyPage extends StatelessWidget {
  const WorkoutReadyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: FAppBar(),
      body: BattleReadyView(),
    );
  }
}
