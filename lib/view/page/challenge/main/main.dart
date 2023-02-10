/* 챌린지 메인 페이지 */

import 'package:fitween/presenter/global.dart';
import 'package:fitween/view/page/challenge/main/widget.dart';
import 'package:flutter/material.dart';
import 'package:fitween/view/widget/widget/app_bar.dart';
import 'package:fitween/view/widget/widget/bottom_bar.dart';

/// class
class ChallengeMainPage extends StatelessWidget {
  const ChallengeMainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: GlobalPresenter.closeBottomBar,
      child: const Scaffold(
        appBar: PAppBar(title: '챌린지'),
        bottomSheet: PBottomSheetBar(body: ChallengeMainView()),
      ),
    );
  }
}
