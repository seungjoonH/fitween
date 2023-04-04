import 'package:fitween/presenter/page/contents/contents.dart';
import 'package:fitween/view/page/contents/widget.dart';
import 'package:fitween/view/widget/widget/tab_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// class
class ContentsPage extends StatelessWidget {
  const ContentsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TabScaffold(
      tabs: ['월간', '업적', '타임어택'],
      bodies: [
        ChallengeCardView(),
        AchievementCardView(),
        BattleCardView(),
      ],
      presenter: Get.find<ContentsP>(),
    );
  }
}
