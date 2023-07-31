import 'package:fitween/model/enum/activity_type.dart';
import 'package:fitween/presenter/lang/language.dart';
import 'package:fitween/view/page/home/ranking/widget.dart';
import 'package:fitween/view/widget/widget/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RankingPage extends StatelessWidget {
  const RankingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ActivityType type = Get.arguments;

    return Scaffold(
      appBar: FAppBar(title: Lang.tr('ranking').capitalize),
      body: RankingCardView(type: type),
    );
  }
}
