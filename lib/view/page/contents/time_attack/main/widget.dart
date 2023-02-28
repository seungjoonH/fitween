import 'package:fitween/global/theme.dart';
import 'package:fitween/presenter/page/contents/time_attack/camera.dart';
import 'package:fitween/view/widget/button/button.dart';
import 'package:fitween/view/widget/widget/text.dart';
import 'package:flutter/material.dart';

class TimeAttackReadyView extends StatelessWidget {
  const TimeAttackReadyView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Image.asset(
                'assets/image/page/contents/time_attack/focus.png',
                width: 250.0,
                fit: BoxFit.fitWidth,
              ),
              const SizedBox(height: 50.0),
              FText(
                '자세 인식',
                style: FTheme.textTheme.titleLarge,
                color: FTheme.darkGrey,
              ),
              const SizedBox(height: 10.0),
              FText(
                '스쿼트 휫수 계산을 위해 자세를 인식합니다',
                style: FTheme.textTheme.bodySmall,
                color: FTheme.lightGrey,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 60.0),
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
