import 'package:fitween/view/page/contents/time_attack/friend/widget.dart';
import 'package:fitween/view/widget/widget/app_bar.dart';
import 'package:flutter/material.dart';

class TimeAttackFriendPage extends StatelessWidget {
  const TimeAttackFriendPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: FAppBar(),
      body: TimeAttackFriendView(),
    );
  }
}
