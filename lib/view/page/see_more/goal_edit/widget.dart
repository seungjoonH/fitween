import 'dart:math';
import 'package:carousel_slider/carousel_slider.dart';
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
                color: record.amount > widget.minValue
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
                color: record.amount < widget.maxValue
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

        return Padding(
          padding: const EdgeInsets.only(left: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FTexts(
                ['$ageGroup', '대 ', goalEditP.userInfo.sex!.kr, ' 평균'],
                colors: const [
                  FTheme.colorA, FTheme.black,
                  FTheme.colorA, FTheme.black,
                ],
                alignment: MainAxisAlignment.start,
                space: false,
                style: textTheme(context).displaySmall,
              ),
              FTexts(
                ['매일', '${recommendTimes.length == 1
                    ? recommendTimes[0]
                    : recommendTimes.join('~')}', '분',
                ],
                colors: [FTheme.black, ActivityType.distance.color, FTheme.black],
                alignment: MainAxisAlignment.start,
                style: textTheme(context).displaySmall,
              ),
              FText(
                '유산소 운동이\n적당해요',
                style: textTheme(context).displaySmall,
                maxLines: 2,
              ),
            ],
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

        const Velocity velocity = Velocity(
          pixelsPerSecond: Offset(50, 0),
        );

        return Padding(
          padding: const EdgeInsets.only(right: 30.0),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      child: GoalNumberPicker(
                        type: ActivityType.distance,
                        itemWidth: 200.0,
                        color: ActivityType.distance.color,
                        style: FTheme.largeText,
                        maxValue: 200,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        FTexts(
                          ['하루 ', '$minute', '분이면'],
                          colors: const [FTheme.black, FTheme.colorA, FTheme.black],
                          style: textTheme(context).displaySmall,
                          alignment: MainAxisAlignment.end,
                          space: false,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              constraints: BoxConstraints(maxWidth: 230.0.w),
                              child: TextScroll(
                                distanceTitle,
                                style: textTheme(context).displaySmall?.merge(TextStyle(
                                  color: ActivityType.distance.color,
                                  fontWeight: FontWeight.normal,
                                )),
                                velocity: velocity,
                                intervalSpaces: 5,
                              ),
                            ),
                            const SizedBox(width: 10.0),
                            FText('(${unitDistance(distanceValue.step.round())}보)'),
                          ],
                        ),
                        FText('만큼 걸을 수 있어요', style: textTheme(context).displaySmall),
                        FTexts(['* 약 ', '${toLocalString(step)}보 (${kilometer}km)'],
                          colors: const [FTheme.darkGrey, FTheme.colorB],
                          space: false,
                          alignment: MainAxisAlignment.end,
                        ),
                      ],
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
    return Padding(
      padding: const EdgeInsets.only(left: 30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FText('한 층을', style: textTheme(context).displaySmall, color: FTheme.colorA),
          FText('오를 때마다', style: textTheme(context).displaySmall),
          FText('건강 수명이', style: textTheme(context).displaySmall),
          FTexts(
            const ['1분 40초', '연장돼요'],
            colors: [ActivityType.height.color, FTheme.black],
            style: textTheme(context).displaySmall,
            alignment: MainAxisAlignment.start,
          ),
        ],
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

        TextStyle? style(Color color) => textTheme(context).displaySmall?.merge(
          TextStyle(
            color: color,
            fontWeight: FontWeight.normal,
          ),
        );

        const velocity = Velocity(pixelsPerSecond: Offset(50, 0));

        return Padding(
          padding: const EdgeInsets.only(left: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FTexts(['하루', '${goal.amount.round()}', '층이면'],
                    colors: [FTheme.black, ActivityType.calorie.color, FTheme.black],
                    alignment: MainAxisAlignment.start,
                    style: style(FTheme.black),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        constraints: BoxConstraints(maxWidth: 210.0.w),
                        child: TextScroll(
                          heightTitle,
                          style: style(ActivityType.height.color),
                          velocity: velocity,
                          intervalSpaces: 5,
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      FText('(${heightValue.amount.round()}층)'),
                    ],
                  ),
                  FText('만큼 오를 수 있어요', style: textTheme(context).displaySmall),
                  const SizedBox(height: 10.0),
                  FTexts(
                    ['* 수명 약', timeToString((100 * goal.amount).round()), '연장'],
                    colors: [FTheme.darkGrey, ActivityType.height.color, FTheme.darkGrey],
                    alignment: MainAxisAlignment.start,
                  ),
                ],
              ),
              Container(
                alignment: Alignment.bottomRight,
                child: GoalNumberPicker(
                  type: ActivityType.height,
                  itemWidth: 200.0,
                  color: ActivityType.height.color,
                  style: FTheme.largeText,
                ),
              ),
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
    return Padding(
      padding: const EdgeInsets.only(left: 30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FTexts(
            const ['유산소 운동', '과'],
            colors: [ActivityType.calorie.color, FTheme.black],
            style: textTheme(context).displaySmall,
            alignment: MainAxisAlignment.start,
            space: false,
          ),
          FTexts(
            const ['근력 운동', '을'],
            colors: [ActivityType.weight.color, FTheme.black],
            style: textTheme(context).displaySmall,
            alignment: MainAxisAlignment.start,
            space: false,
          ),
          FText('병행 해야 운동 효과가', style: textTheme(context).displaySmall),
          FText('훨씬 좋아져요', style: textTheme(context).displaySmall),
        ],
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
        double weight = goal.weight;

        String weightTitle = tier['current'].title;
        WeightRecord weightValue = WeightRecord(
          amount: tier['current'].amount.toDouble(),
          state: ExerciseUnit.count,
        );

        const velocity = Velocity(pixelsPerSecond: Offset(50, 0));

        return Padding(
          padding: const EdgeInsets.only(right: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                child: GoalNumberPicker(
                  type: ActivityType.weight,
                  itemWidth: 200.0,
                  color: ActivityType.weight.color,
                  style: FTheme.largeText,
                  maxValue: 200,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  FTexts(
                    ['하루 ', toLocalString(count), '회면'],
                    colors: const [FTheme.black, FTheme.colorA, FTheme.black],
                    style: textTheme(context).displaySmall,
                    alignment: MainAxisAlignment.end,
                    space: false,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        constraints: BoxConstraints(maxWidth: 230.0.w),
                        child: TextScroll(
                          weightTitle,
                          style: textTheme(context).displaySmall?.merge(TextStyle(
                            color: ActivityType.weight.color,
                            fontWeight: FontWeight.normal,
                          )),
                          velocity: velocity,
                          intervalSpaces: 5,
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      FText('(${unitDistance(weightValue.count.round())}회)'),
                    ],
                  ),
                  FText(
                    '만큼 들 수 있어요',
                    style: textTheme(context).displaySmall,
                  ),
                  FTexts(['* 약 ', '${toLocalString(weight)} kg'],
                    colors: const [FTheme.darkGrey, FTheme.colorD],
                    space: false,
                    alignment: MainAxisAlignment.end,
                  ),
                ],
              ),
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
            text: '다음',
            stretch: true,
          ),
        );
      },
    );
  }
}
