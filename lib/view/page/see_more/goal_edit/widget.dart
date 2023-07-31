import 'dart:math';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:fitween/presenter/lang/language.dart';
import 'package:fitween/presenter/page/see_more/goal_edit/goal_edit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:fitween/global/date.dart';
import 'package:fitween/global/number.dart';
import 'package:fitween/global/theme.dart';
import 'package:fitween/global/unit.dart';
import 'package:fitween/model/enum/activity_type.dart';
import 'package:fitween/model/enum/unit.dart';
import 'package:fitween/model/enum/sex.dart';
import 'package:fitween/presenter/model/json/level.dart';
import 'package:fitween/presenter/model/record.dart';
import 'package:fitween/view/widget/button/button.dart';
import 'package:fitween/view/widget/widget/text.dart';
import 'package:text_scroll/text_scroll.dart';

// Carousel 뷰 위젯
class CarouselView extends StatelessWidget {
  const CarouselView({Key? key}) : super(key: key);

  // 회원가입 페이지 carousel 리스트
  static List<Widget> carouselWidgets() => const [
    DistanceRecommendView(),
    DistanceGoalView(),
    HeightRecommendView(),
    HeightGoalView(),
    WeightRecommendView(),
    WeightGoalView(),
  ];

  static int widgetCount = carouselWidgets().length;

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    String asset = 'assets/image/page/see_more/goal_edit/';
    const List<int> widthFitIndex = [2, 3];

    return GetBuilder<GoalEditP>(
      builder: (goalEditP) {
        return Stack(
          children: [
            for (int i = 0; i < goalEditP.imageExistence.length; i++)
              AnimatedPositioned(
                left: screenSize.width * (i - goalEditP.pageIndex),
                bottom: 140.0.h,
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeInOut,
                width: screenSize.width,
                height: screenSize.height * .4,
                child: goalEditP.imageExistence[i]
                    ? SvgPicture.asset(
                  '${asset}carousel_${i.toString().padLeft(2, '0')}.svg',
                  alignment: Alignment.center,
                  fit: widthFitIndex.contains(i)
                      ? BoxFit.fitHeight : BoxFit.contain,
                  // fit: BoxFit.fitWidth,
                ) : Container(),
              ),
            Column(
              children: [
                Expanded(
                  child: Container(
                    alignment: Alignment.topCenter,
                    child: Container(
                      constraints: BoxConstraints(minWidth: screenSize.width),
                      child: CarouselSlider(
                        carouselController: GoalEditP.carouselCont,
                        items: carouselWidgets().map((widget) => widget).toList(),
                        options: CarouselOptions(
                          height: double.infinity,
                          initialPage: 0,
                          reverse: false,
                          enableInfiniteScroll: false,
                          scrollPhysics: const NeverScrollableScrollPhysics(),
                          viewportFraction: 1.0,
                          // onPageChanged: controller.pageChanged,
                        ),
                      ),
                    ),
                  ),
                ),
                const CarouselButton(),
                const SizedBox(height: 50.0),
              ],
            ),
          ],
        );
      },
    );
  }
}

class GoalNumberPicker extends StatefulWidget {
  const GoalNumberPicker({
    Key? key,
    required this.type,
    this.style,
    this.itemCount = 1,
    this.itemWidth = 100.0,
    this.itemHeight = 120.0,
    this.minValue = 0,
    this.maxValue = 100,
    this.color = FTheme.black,
  }) : super(key: key);

  final ActivityType type;
  final TextStyle? style;
  final int itemCount;
  final double itemWidth;
  final double itemHeight;
  final int minValue;
  final int maxValue;
  final Color color;

  @override
  State<GoalNumberPicker> createState() => _GoalNumberPickerState();
}

class _GoalNumberPickerState extends State<GoalNumberPicker> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<GoalEditP>(
      builder: (goalEditP) {
        Record record = goalEditP.amounts[widget.type]!;
        record.convert({
          ActivityType.distance: ExerciseUnit.minute,
          ActivityType.weight: ExerciseUnit.count,
        }[widget.type]);

        Record lessRecord = Record.init(
          widget.type,
          max(record.amount - 1, widget.minValue.toDouble()), {
          ActivityType.distance: ExerciseUnit.minute,
          ActivityType.weight: ExerciseUnit.count,
        }[widget.type],
        );
        Record greaterRecord = Record.init(
          widget.type,
          min(record.amount + 1, widget.maxValue.toDouble()),{
          ActivityType.distance: ExerciseUnit.minute,
          ActivityType.weight: ExerciseUnit.count,
        }[widget.type],
        );

        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(
              icon: Icon(
                Icons.arrow_drop_up,
                size: 30.0.r,
                color: record.amount < widget.maxValue
                    ? FTheme.black
                    : Colors.transparent,
              ),
              onPressed: () {
                goalEditP.setGoal(greaterRecord);
                Future.delayed(const Duration(milliseconds: 100), () {
                  if (mounted) setState(() {});
                });
              },
            ),
            NumberPicker(
              onChanged: (val) {
                goalEditP.setGoal(Record.init(
                  widget.type, val.toDouble(), {
                    ActivityType.distance: ExerciseUnit.minute,
                    ActivityType.weight: ExerciseUnit.count,
                  }[widget.type],
                ));
                goalEditP.update();
              },
              itemCount: widget.itemCount,
              itemWidth: widget.itemWidth,
              itemHeight: widget.itemHeight,
              value: record.amount.round(),
              minValue: widget.minValue,
              maxValue: widget.maxValue,
              textStyle: widget.style?.apply(color: FTheme.darkGrey),
              selectedTextStyle: widget.style?.apply(color: widget.color),
            ),
            IconButton(
              icon: Icon(
                Icons.arrow_drop_down,
                size: 30.0.r,
                color: record.amount > widget.minValue
                    ? FTheme.black
                    : Colors.transparent,
              ),
              onPressed: () {
                goalEditP.setGoal(lessRecord);
                Future.delayed(const Duration(milliseconds: 100), () {
                  if (mounted) setState(() {});
                });
              },
            ),
          ],
        );
      },
    );
  }
}

class SettingIntroView extends StatelessWidget {
  const SettingIntroView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 30.0),
      alignment: Alignment.centerLeft,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FText(
            '자,',
            style: textTheme(context).displaySmall,
            align: TextAlign.start,
          ),
          FTexts(
            const ['이제 ', '일일 목표', '를'],
            colors: const [FTheme.black, FTheme.colorB, FTheme.black],
            alignment: MainAxisAlignment.start,
            style: textTheme(context).displaySmall,
            space: false,
          ),
          FText(
            '설정하러 가볼까요?',
            style: textTheme(context).displaySmall,
            align: TextAlign.start,
          ),
        ],
      ),
    );
  }
}

class DistanceRecommendView extends StatelessWidget {
  const DistanceRecommendView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GoalEditP>(
      builder: (goalEditP) {
        int ageGroup = today.difference(
          goalEditP.userInfo.dateOfBirth!,
        ).inDays;
        List<int> recommendTimes = [];
        ageGroup = (ageGroup / 3650).floor() * 10;

        ageGroup < 60 && goalEditP.userInfo.sex == Sex.male;

        if (ageGroup < 20) {
          recommendTimes = [60];
        } else if (ageGroup < 60) {
          recommendTimes = [20, 40];
        } else {
          recommendTimes = [30, 50];
        }

        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: 28.0.w,
            vertical: 28.0.h,
          ),
          alignment: Alignment.topLeft,
          child: FTextsT(
            Lang.tr('goal-edit.distance.rcmd', namedArgs: {
              'generation': '@{$ageGroup}',
              'sex': '@{${Lang.tr('sex.${goalEditP.userInfo.sex!.name}')}}',
              'minute': '@{${recommendTimes.length == 1 ? recommendTimes[0] : recommendTimes.join('~')}}'
            }),
            style: textTheme(context).displaySmall,
            highlightColors: [FTheme.colorA, FTheme.colorA, ActivityType.distance.color],
          ),
        );
      },
    );
  }
}

class DistanceGoalView extends StatelessWidget {
  const DistanceGoalView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GoalEditP>(
      builder: (goalEditP) {
        DistanceRecord distance = goalEditP
            .amounts[ActivityType.distance] as DistanceRecord;

        int step = distance.step.round();
        int minute = distance.minute.round();
        int kilometer = distance.kilometer.round();

        Map<String, dynamic> tier = LevelJsonP.getTier(
          ActivityType.distance, distance,
        );

        String distanceTitle = tier['current'].title;
        DistanceRecord distanceValue = DistanceRecord(
          amount: tier['current'].amount.toDouble(),
          state: ExerciseUnit.kilometer,
        );

        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 28.0.w,
            vertical: 28.0.h,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Positioned(
                      left: .0, top: .0,
                      child: GoalNumberPicker(
                        type: ActivityType.distance,
                        itemWidth: 200.0,
                        color: ActivityType.distance.color,
                        style: FTheme.largeText,
                        maxValue: 200,
                      ),
                    ),
                    Positioned(
                      right: .0, bottom: .0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Builder(
                            builder: (context) {
                              TextStyle style = textTheme(context).displaySmall!.copyWith(
                                color: FTheme.darkGrey,
                              );
                              return FTextsT(
                                Lang.tr(
                                  'goal-edit.distance.calc',
                                  namedArgs: {
                                    'minute': Lang.plural('unit.w-num.time.minute', minute),
                                    'object': '@{$distanceTitle}',
                                    'obj-value': typeUnit(distanceValue.step, ActivityType.distance, short: false),
                                  },
                                ),
                                align: TextAlign.end,
                                mainAxisAlignment: MainAxisAlignment.end,
                                style: textTheme(context).displaySmall,
                                highlightStyles: [
                                  style.copyWith(color: FTheme.colorA),
                                  textTheme(context).displaySmall!.copyWith(
                                    color: ActivityType.distance.color,
                                  ),
                                  textTheme(context).titleSmall!.copyWith(
                                    color: style.color,
                                  ),
                                ],
                              );
                            },
                          ),
                          FTextsT(
                            Lang.tr(
                              'goal-edit.distance.about',
                              namedArgs: {
                                'step': typeUnit(step, ActivityType.distance, short: false),
                                'kilometer': '$kilometer',
                              },
                            ),
                            style: textTheme(context).bodyMedium,
                            textColor: FTheme.lightGrey,
                            highlightColor: ActivityType.distance.color,
                            mainAxisAlignment: MainAxisAlignment.end,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 60.0),
            ],
          ),
        );
      },
    );
  }
}

class HeightRecommendView extends StatelessWidget {
  const HeightRecommendView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 28.0.w,
        vertical: 28.0.h,
      ),
      alignment: Alignment.topLeft,
      child: FTextsT(
        Lang.tr('goal-edit.height.rcmd'),
        style: textTheme(context).displaySmall,
        highlightColors: const [FTheme.colorA, FTheme.colorC],
      ),
    );
  }
}

class HeightGoalView extends StatelessWidget {
  const HeightGoalView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GoalEditP>(
      builder: (goalEditP) {
        HeightRecord goal = goalEditP
            .amounts[ActivityType.height] as HeightRecord;

        Map<String, dynamic> tier = LevelJsonP.getTier(
          ActivityType.height, goal,
        );

        String heightTitle = tier['current'].title;
        HeightRecord heightValue = HeightRecord(
          amount: tier['current'].amount.toDouble(),
        );

        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 28.0.w,
            vertical: 28.0.h,
          ),
          child: Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Positioned(
                      left: .0, top: .0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FTextsT(
                            Lang.tr(
                              'goal-edit.height.calc',
                              namedArgs: {
                                'floor': Lang.plural('unit.w-num.floor', goal.amount.round()),
                                'object': heightTitle,
                                'obj-value': Lang.plural(
                                  'unit.w-num.floor',
                                  heightValue.amount.round(),
                                ),
                              },
                            ),
                            style: textTheme(context).displaySmall,
                            highlightStyles: [
                              textTheme(context).displaySmall!.copyWith(color: FTheme.colorA),
                              textTheme(context).displaySmall!.copyWith(color: ActivityType.height.color),
                              textTheme(context).titleMedium!,
                            ],
                          ),
                          SizedBox(height: 20.0.h),
                          FTextsT(
                            Lang.tr(
                                'goal-edit.height.about',
                                namedArgs: {'time': timeToString((100 * goal.amount).round())}
                            ),
                            style: textTheme(context).bodyMedium,
                            textColor: FTheme.lightGrey,
                            highlightColor: ActivityType.height.color,
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      right: .0, bottom: .0,
                      child: GoalNumberPicker(
                        type: ActivityType.height,
                        itemWidth: 200.0,
                        color: ActivityType.height.color,
                        style: FTheme.largeText,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30.0.h),
            ],
          ),
        );
      },
    );
  }
}


class WeightRecommendView extends StatelessWidget {
  const WeightRecommendView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 28.0.w,
        vertical: 28.0.h,
      ),
      alignment: Alignment.topLeft,
      child: FTextsT(
        Lang.tr('goal-edit.weight.rcmd'),
        style: textTheme(context).displaySmall,
        highlightColors: [FTheme.colorA, ActivityType.weight.color],
      ),
    );
  }
}


class WeightGoalView extends StatelessWidget {
  const WeightGoalView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GoalEditP>(
      builder: (goalEditP) {
        WeightRecord goal = goalEditP
            .amounts[ActivityType.weight] as WeightRecord;

        Map<String, dynamic> tier = LevelJsonP.getTier(
          ActivityType.weight, goal,
        );

        double count = goal.count;

        String weightTitle = tier['current'].title;
        WeightRecord weightValue = WeightRecord(
          amount: tier['current'].amount.toDouble(),
          state: ExerciseUnit.weight,
        );

        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 28.0.w, vertical: 28.0.h,
          ),
          child: Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Positioned(
                      left: .0, top: .0,
                      child: GoalNumberPicker(
                        type: ActivityType.weight,
                        itemWidth: 200.0,
                        color: ActivityType.weight.color,
                        style: FTheme.largeText,
                        maxValue: 200,
                      ),
                    ),
                    Positioned(
                      right: .0, bottom: .0,
                      child: FTextsT(
                        Lang.tr(
                          'goal-edit.weight.calc',
                          namedArgs: {
                            'count': Lang.plural('unit.w-num.count', count.round()).capitalize!,
                            'object': weightTitle,
                            'obj-value': Lang.plural('unit.w-num.count', weightValue.count.round()),
                          },
                        ),
                        align: TextAlign.right,
                        style: textTheme(context).displaySmall,
                        highlightStyles: [
                          textTheme(context).displaySmall!.copyWith(color: FTheme.colorA),
                          textTheme(context).displaySmall!.copyWith(color: ActivityType.weight.color),
                          textTheme(context).titleMedium!,
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30.0.h),
            ],
          ),
        );
      },
    );
  }
}

class CalorieCheckView extends StatelessWidget {
  const CalorieCheckView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GoalEditP>(
      builder: (goalEditP) {
        CalorieRecord goal = goalEditP
            .amounts[ActivityType.calorie] as CalorieRecord;

        String distanceTitle = LevelJsonP.getTier(
          ActivityType.distance,
          goalEditP.amounts[ActivityType.distance]!
        )['current'].title;

        String heightTitle = LevelJsonP.getTier(
          ActivityType.height,
            goalEditP.amounts[ActivityType.height]!
        )['current'].title;

        TextStyle? style(Color color) => textTheme(context).headlineMedium?.merge(TextStyle(
          color: color,
          fontWeight: FontWeight.normal,
        ));

        const velocity = Velocity(pixelsPerSecond: Offset(50, 0));

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 120.0.h),
                FText('하루에', style: textTheme(context).headlineMedium),
                Row(
                  children: [
                    Container(
                      constraints: const BoxConstraints(maxWidth: 200.0),
                      child: TextScroll(distanceTitle,
                        style: style(ActivityType.distance.color),
                        velocity: velocity,
                        intervalSpaces: 5,
                      ),
                    ),
                    const SizedBox(width: 7.0),
                    FText('만큼 걷고',
                      style: textTheme(context).headlineMedium,
                    ),
                  ],
                ),
                Row(
                  children: [
                    TextScroll(heightTitle,
                      style: style(ActivityType.height.color),
                      velocity: velocity,
                      intervalSpaces: 5,
                    ),
                    const SizedBox(width: 7.0),
                    FText('만큼 오르면...',
                      style: textTheme(context).headlineMedium,
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 180.0.h),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                FTexts(['총', '${goal.amount.round()} kcal', '를'],
                  colors: [
                    FTheme.black,
                    ActivityType.calorie.color,
                    FTheme.black
                  ],
                  style: textTheme(context).displaySmall,
                  alignment: MainAxisAlignment.end,
                ),
                FText('소모할 수 있어요',
                  color: FTheme.black,
                  style: textTheme(context).displaySmall,
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

// Carousel 버튼
class CarouselButton extends StatelessWidget {
  const CarouselButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GoalEditP>(
      builder: (controller) {
        // bool lastPage = controller.pageIndex == CarouselView.widgetCount - 1;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          height: 50.0,
          child: FButton(
            onPressed: () async {
              if (controller.keyboardVisible) {
                FocusScope.of(context).unfocus();
                await Future.delayed(const Duration(milliseconds: 100));
              }
              controller.nextPressed();
            },
            text: Lang.tr('btn.next').capitalize,
            stretch: true,
          ),
        );
      },
    );
  }
}
