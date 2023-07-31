import 'package:fitween/presenter/lang/language.dart';
import 'package:fitween/presenter/page/contents/contents.dart';
import 'package:fitween/view/page/contents/widget.dart';
import 'package:fitween/view/widget/widget/tab_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContentsPage extends StatelessWidget {
  const ContentsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TabScaffold(
      tabs: [
        Lang.tr('party.'),
        Lang.tr('level.'),
        Lang.tr('battle'),
      ],
      bodies: const [
        ChallengeCardView(),
        AchievementCardView(),
        BattleCardView(),
      ],
      presenter: Get.find<ContentsP>(),
    );
  }
}
