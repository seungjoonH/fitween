import 'package:fitween/model/enum/activity_type.dart';
import 'package:fitween/view/page/ranking/widget.dart';
import 'package:fitween/view/widget/widget/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RankingPage extends StatelessWidget {
  const RankingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ActivityType type = Get.arguments;

    return Scaffold(
      appBar: const FAppBar(title: '랭킹'),
      body: RankingCardView(type: type),
    );
  }
}
