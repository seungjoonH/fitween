import 'package:fitween/view/page/contents/workout/friend/widget.dart';
import 'package:fitween/view/widget/widget/app_bar.dart';
import 'package:flutter/material.dart';

class WorkoutFriendPage extends StatelessWidget {
  const WorkoutFriendPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: FAppBar(),
      body: BattleFriendView(),
    );
  }
}
