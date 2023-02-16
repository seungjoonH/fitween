import 'package:flutter/material.dart';
import 'package:fitween/view/page/quest/widget.dart';
import 'package:fitween/view/widget/widget/app_bar.dart';

class QuestPage extends StatelessWidget {
  const QuestPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: FAppBar(title: '월간 목표'),
      body: MonthlyQuestView(),
    );
  }
}
