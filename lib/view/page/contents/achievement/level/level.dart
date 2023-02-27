import 'package:fitween/global/theme.dart';
import 'package:fitween/presenter/page/challenge/level.dart';
import 'package:fitween/view/page/contents/achievement/level/widget.dart';
import 'package:fitween/view/widget/widget/app_bar.dart';
import 'package:flutter/material.dart';

/// class
class ChallengeLevelPage extends StatelessWidget {
  const ChallengeLevelPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: FAppBar(title: '거리',
        color: FTheme.white,
        leading: IconButton(
          onPressed: ChallengeLevelP.backPressed,
          icon: Icon(Icons.arrow_back_ios_rounded),
        ),
      ),
      body: ChallengeLevelPageView(),
    );
  }
}