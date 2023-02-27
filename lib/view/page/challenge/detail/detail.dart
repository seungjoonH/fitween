/* 챌린지 디테일 페이지 */

import 'package:fitween/model/class/json/challenge.dart';
import 'package:fitween/view/page/challenge/detail/widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fitween/view/widget/widget/app_bar.dart';

import '../../../widget/widget/bottom_bar.dart';

/// class
class ChallengeDetailPage extends StatelessWidget {
  const ChallengeDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Challenge challenge = Get.arguments;

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: ChallengeDetailView(challenge: challenge),
    );
  }
}
