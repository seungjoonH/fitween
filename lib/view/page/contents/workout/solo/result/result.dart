import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:fitween/global/theme.dart';
import 'package:fitween/model/enum/activity_type.dart';
import 'package:fitween/presenter/page/contents/workout/solo/result.dart';
import 'package:fitween/view/widget/button/button.dart';
import 'package:fitween/view/widget/widget/app_bar.dart';
import 'package:fitween/view/widget/widget/card.dart';
import 'package:fitween/view/widget/widget/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class WorkoutSoloResultPage extends StatelessWidget {
  const WorkoutSoloResultPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const FAppBar(title: '운동 결과'),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 28.0.w, vertical: 28.0.h,
        ),
        child: GetBuilder<WorkoutSoloResultP>(
          builder: (workoutSoloResultP) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FCard(
                  title: FText('나의 기록',
                    style: textTheme(context).titleLarge,
                    color: FTheme.darkGrey,
                    bold: true,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FText(
                        '무게 기록 상승!',
                        style: textTheme(context).bodyLarge,
                        color: FTheme.grey,
                      ),
                      const SizedBox(height: 20.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          AnimatedFlipCounter(
                            value: workoutSoloResultP.amount,
                            suffix: '회',
                            thousandSeparator: ',',
                            textStyle: textTheme(context).displayLarge?.copyWith(
                              color: ActivityType.weight.color,
                            ),
                          ),
                          FText(
                            '/ ${workoutSoloResultP.goal.round()}회',
                            color: FTheme.lightGrey,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20.0),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          LinearPercentIndicator(
                            percent: workoutSoloResultP.percent,
                            lineHeight: 50.0,
                            animateFromLastPercent: true,
                            backgroundColor: FTheme.background,
                            barRadius: const Radius.circular(12.0),
                            progressColor: Colors.amberAccent,
                            animation: true,
                            curve: Curves.easeInOut,
                            animationDuration: 1000,
                          ),
                          LinearPercentIndicator(
                            percent: workoutSoloResultP.initPercent,
                            lineHeight: 50.0,
                            animateFromLastPercent: true,
                            backgroundColor: Colors.transparent,
                            barRadius: const Radius.circular(12.0),
                            progressColor: ActivityType.weight.color,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: Builder(
                              builder: (context) {
                                double a = workoutSoloResultP.initPercent;
                                double b = workoutSoloResultP.percent;
                                int leftFlex = ((a + b - .3) * 5000).round();
                                int rightFlex = ((1.85 - a - b) * 5000).round();
                                return Row(
                                  children: [
                                    Expanded(flex: leftFlex, child: const SizedBox()),
                                    Container(
                                      width: 80.0,
                                      alignment: Alignment.center,
                                      child: FText(
                                        '+${workoutSoloResultP.addedWeight.amount.round()}회',
                                        color: FTheme.darkGrey,
                                        style: textTheme(context).bodyLarge,
                                      ),
                                    ),
                                    Expanded(flex: rightFlex, child: const SizedBox()),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20.0),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 60.0),
                  child: FButton(
                    text: '완료하기',
                    stretch: true,
                    onPressed: workoutSoloResultP.submitButtonPressed,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
