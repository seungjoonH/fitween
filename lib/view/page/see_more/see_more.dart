import 'package:fitween/view/page/see_more/widget.dart';
import 'package:fitween/view/widget/widget/app_bar.dart';
import 'package:flutter/material.dart';

class SeeMorePage extends StatelessWidget {
  const SeeMorePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FAppBar(title: '더보기'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(28.0),
          child: Column(
            children: [
              BadgeManagementCard(),
              // GoalEditCard(),
              // InfoEditCard(),
            ],
          ),
        ),
      ),
    );
  }
}
