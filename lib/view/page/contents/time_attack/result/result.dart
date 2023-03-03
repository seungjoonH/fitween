import 'package:fitween/view/page/contents/time_attack/result/widget.dart';
import 'package:fitween/view/widget/widget/app_bar.dart';
import 'package:flutter/material.dart';

class TimeAttackResultPage extends StatelessWidget {
  const TimeAttackResultPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FAppBar(
        title: '타임어택 결과',
        leading: Container(),
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(Icons.clear))
        ],
      ),
      body: TimeAttackResultView(),
    );
  }
}
