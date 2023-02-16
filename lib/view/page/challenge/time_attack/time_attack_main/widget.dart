import 'package:fitween/presenter/page/challenge/time_attack/time_attack_camera.dart';
import 'package:flutter/material.dart';

import '../../../../../global/theme.dart';
import '../../../../widget/button/button.dart';
import '../../../../widget/widget/text.dart';

class TimeAttackMainPageView extends StatelessWidget {
  const TimeAttackMainPageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SizedBox(
            height: 100,
          ),
          Image.asset('assets/image/challenge/timeAttack/timeAttackMain.png'),
          SizedBox(
            height: 50,
          ),
          FText(
            '자세 인식',
            style: FTheme.textTheme.titleLarge,
            color: FTheme.grey,
          ),
          SizedBox(
            height: 13,
          ),
          FText(
            '스쿼트 휫수 계산을 위해 자세를 인식합니다',
            style: FTheme.textTheme.bodySmall,
            color: FTheme.lightGrey,
          ),
          SizedBox(
            height: 128,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 28.0, right: 28.0),
            child: FButton(
              text: '시작하기',
              stretch: true,
              onPressed: TimeAttackCameraP.toTimeAttackCamera,
            ),
          )
        ],
      ),
    );
  }
}
