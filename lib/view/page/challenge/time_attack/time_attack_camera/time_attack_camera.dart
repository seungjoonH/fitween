import 'package:fitween/view/page/challenge/time_attack/time_attack_camera/widget.dart';
import 'package:fitween/view/page/challenge/time_attack/time_attack_friend/widget.dart';
import 'package:fitween/view/widget/widget/app_bar.dart';
import 'package:flutter/material.dart';

class TimeAttackCameraPage extends StatelessWidget {
  const TimeAttackCameraPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: TimeAttackCameraPageView(),
    );
  }
}
