import 'package:fitween/global/theme.dart';
import 'package:fitween/presenter/page/contents/workout/ready.dart';
import 'package:fitween/view/widget/button/button.dart';
import 'package:fitween/view/widget/widget/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class BattleReadyView extends StatelessWidget {
  const BattleReadyView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final workoutReadyP = Get.find<WorkoutReadyP>();

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Image.asset(
                'assets/images/page/contents/workout/focus.png',
                width: 250.0,
                fit: BoxFit.fitWidth,
              ),
              const SizedBox(height: 50.0),
              FText(
                '자세 인식',
                style: textTheme(context).titleLarge,
                color: FTheme.darkGrey,
              ),
              const SizedBox(height: 10.0),
              FText(
                '스쿼트 횟수 계산을 위해 자세를 인식합니다',
                style: textTheme(context).bodySmall,
                color: FTheme.lightGrey,
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 50.0.h),
            child: FButton(
              text: '시작하기',
              stretch: true,
              onPressed: workoutReadyP.startButtonPressed,
            ),
          )
        ],
      ),
    );
  }
}
