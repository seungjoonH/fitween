import 'dart:math';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:fitween/global/date.dart';
import 'package:fitween/global/number.dart';
import 'package:fitween/global/string.dart';
import 'package:fitween/global/theme.dart';
import 'package:fitween/global/unit.dart';
import 'package:fitween/model/enum/activity_type.dart';
import 'package:fitween/model/enum/unit.dart';
import 'package:fitween/model/enum/sex.dart';
import 'package:fitween/presenter/model/level.dart';
import 'package:fitween/presenter/model/record.dart';
import 'package:fitween/presenter/page/edit_goal.dart';
import 'package:fitween/view/widget/button/button.dart';
import 'package:fitween/view/widget/widget/text.dart';
import 'package:text_scroll/text_scroll.dart';

class CarouselView extends StatelessWidget {
  const CarouselView({Key? key}) : super(key: key);

  // 회원가입 페이지 carousel 리스트
  static List<Widget> carouselWidgets() => const [
        DistanceRecommendView(),
        DistanceGoalView(),
        HeightRecommendView(),
        HeightGoalView(),
        CalorieCheckView(),
      ];

  static int widgetCount = carouselWidgets().length;

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    String asset = 'assets/image/page/edit_goal/';

    return GetBuilder<EditGoalP>(
      builder: (controller) {
        return Stack(
          children: [
            for (int i = 0; i < controller.imageExistence.length; i++)
            AnimatedPositioned(
              left: screenSize.width * (i - controller.pageIndex),
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeInOut,
              width: screenSize.width,
              height: screenSize.height,
              child: controller.imageExistence[i] ? Image.asset(
                '${asset}carousel_${i.toString().padLeft(2, '0')}.png',
                alignment: Alignment.center,
                fit: BoxFit.fill,
              ) : Container(),
            ),
            Column(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(top: 60.0),
                    alignment: Alignment.topCenter,
                    child: Container(
                      constraints: BoxConstraints(minWidth: screenSize.width),
                      child: CarouselSlider(
                        carouselController: EditGoalP.carouselCont,
                        items: carouselWidgets().map((widget) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30.0,
                          ),
                          child: widget,
                        )).toList(),
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
    return GetBuilder<EditGoalP>(
      builder: (editGoalP) {
        Record record = editGoalP.userRecord.getGoal(widget.type)!;
        record.convert(ExerciseUnit.minute);

        Record lessRecord = Record.init(
          widget.type,
          max(record.amount - 1, widget.minValue.toDouble()),
          ExerciseUnit.minute,
        );
        Record greaterRecord = Record.init(
          widget.type,
          min(record.amount + 1, widget.maxValue.toDouble()),
          ExerciseUnit.minute,
        );

        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(
              icon: Icon(
                Icons.arrow_drop_up,
                size: 40.0.r,
                color: record.amount > widget.minValue
                    ? FTheme.black
                    : Colors.transparent,
              ),
              onPressed: () {
                editGoalP.userRecord.setGoal(widget.type, greaterRecord);
                setState(() {});
              },
            ),
            NumberPicker(
              onChanged: (val) {
                editGoalP.userRecord.setGoal(
                  widget.type,
                  Record.init(
                    widget.type,
                    val.toDouble(),
                    ExerciseUnit.minute,
                  ),
                );
                editGoalP.update();
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
                size: 40.0.r,
                color: record.amount < widget.maxValue
                    ? FTheme.black
                    : Colors.transparent,
              ),
              onPressed: () {
                editGoalP.userRecord.setGoal(widget.type, lessRecord);
                setState(() {});
              },
            ),
          ],
        );
      },
    );
  }
}

class DistanceRecommendView extends StatelessWidget {
  const DistanceRecommendView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EditGoalP>(
      builder: (editGoalP) {
        int ageGroup = today.difference(editGoalP.userInfo.dateOfBirth!).inDays;
        List<int> recommendTimes = [];
        ageGroup = (ageGroup / 3650).floor() * 10;

        ageGroup < 60 && editGoalP.userInfo.sex == Sex.male;

        if (ageGroup < 20) {
          recommendTimes = [60];
        } else if (ageGroup < 60) {
          recommendTimes = [20, 40];
        } else {
          recommendTimes = [30, 50];
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FTexts(
              ['$ageGroup', '대 ', editGoalP.userInfo.sex!.kr, ' 평균'],
              colors: const [
                FTheme.colorA, FTheme.black,
                FTheme.colorA, FTheme.black,
              ],
              alignment: MainAxisAlignment.start,
              space: false,
              style: textTheme.displaySmall,
            ),
            FTexts([
              '매일', '${recommendTimes.length == 1 ? recommendTimes[0] : recommendTimes.join('~')}', '분',
            ], colors: [FTheme.black, ActivityType.distance.color, FTheme.black],
              alignment: MainAxisAlignment.start,
              style: textTheme.displaySmall,
            ),
            FText(
              '유산소 운동이\n적당해요',
              style: textTheme.displaySmall,
              maxLines: 2,
            ),
          ],
        );
      },
    );
  }
}

class DistanceGoalView extends StatelessWidget {
  const DistanceGoalView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EditGoalP>(
      builder: (editGoalP) {
        DistanceRecord distance = editGoalP.userRecord.getGoal(
          ActivityType.distance,
        ) as DistanceRecord;

        int step = distance.step.round();
        int minute = distance.minute.round();
        int kilometer = distance.kilometer.round();

        Map<String, dynamic> tier = LevelPresenter.getTier(
          ActivityType.distance,
          distance,
        );

        String distanceTitle = tier['current'].title;
        DistanceRecord distanceValue = DistanceRecord(
          amount: tier['current'].amount.toDouble(),
          state: ExerciseUnit.kilometer,
        );

        const Velocity velocity = Velocity(
          pixelsPerSecond: Offset(50, 0),
        );

        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
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
                  style: textTheme.displaySmall,
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
                        style: textTheme.displaySmall?.merge(TextStyle(
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
                FText(
                  '${eulReul(distanceTitle)} 정복할 수 있어요',
                  style: textTheme.displaySmall,
                ),
                FTexts(
                  ['* 약 ', '${toLocalString(step)}보 (${kilometer}km)'],
                  colors: const [FTheme.darkGrey, FTheme.colorB],
                  space: false,
                  alignment: MainAxisAlignment.end,
                ),
              ],
            ),
            const SizedBox(height: 100.0),
          ],
        );
      },
    );
  }
}

class HeightRecommendView extends StatelessWidget {
  const HeightRecommendView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FText('한 층을', style: textTheme.displaySmall, color: FTheme.colorA),
        FText('오를 때마다', style: textTheme.displaySmall),
        FText('건강 수명이', style: textTheme.displaySmall),
        FTexts(
          const ['1분 40초', '연장돼요'],
          colors: [ActivityType.height.color, FTheme.black],
          style: textTheme.displaySmall,
          alignment: MainAxisAlignment.start,
        ),
      ],
    );
  }
}

class HeightGoalView extends StatelessWidget {
  const HeightGoalView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EditGoalP>(
      builder: (editGoalP) {
        HeightRecord goal = editGoalP.userRecord.getGoal(
          ActivityType.height,
        ) as HeightRecord;

        Map<String, dynamic> tier = LevelPresenter.getTier(
          ActivityType.height, goal,
        );

        String heightTitle = tier['current'].title;
        HeightRecord heightValue = HeightRecord(
          amount: tier['current'].amount.toDouble(),
        );

        TextStyle? style(Color color) => textTheme.displaySmall?.merge(
          TextStyle(
            color: color,
            fontWeight: FontWeight.normal,
          ),
        );

        const velocity = Velocity(pixelsPerSecond: Offset(50, 0));

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FTexts(
                  ['하루', '${goal.amount.round()}', '층이면'],
                  colors: [
                    FTheme.black,
                    ActivityType.calorie.color,
                    FTheme.black
                  ],
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
                FText('을 정복할 수 있어요', style: textTheme.displaySmall),
                const SizedBox(height: 10.0),
                FTexts(
                  ['* 수명 약', timeToString((100 * goal.amount).round()), '연장'],
                  colors: [FTheme.darkGrey, ActivityType.height.color, FTheme.darkGrey],
                  alignment: MainAxisAlignment.start,
                ),
              ],
            ),
            const Expanded(child: SizedBox()),
            Align(
              alignment: Alignment.topRight,
              child: GoalNumberPicker(
                type: ActivityType.height,
                itemWidth: 200.0,
                color: ActivityType.height.color,
                style: FTheme.largeText,
              ),
            ),
            const SizedBox(height: 100.0),
          ],
        );
      },
    );
  }
}

class CalorieCheckView extends StatelessWidget {
  const CalorieCheckView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EditGoalP>(
      builder: (editGoalP) {
        CalorieRecord goal = editGoalP.userRecord.getGoal(
          ActivityType.calorie,
        ) as CalorieRecord;

        String distanceTitle = LevelPresenter.getTier(
          ActivityType.distance,
          editGoalP.userRecord.getGoal(ActivityType.distance)!,
        )['current'].title;

        String heightTitle = LevelPresenter.getTier(
          ActivityType.height,
          editGoalP.userRecord.getGoal(ActivityType.height)!,
        )['current'].title;

        TextStyle? style(Color color) =>
            textTheme.headlineMedium?.merge(TextStyle(
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
                FText('하루에', style: textTheme.headlineMedium),
                Row(
                  children: [
                    Container(
                      constraints: const BoxConstraints(maxWidth: 200.0),
                      child: TextScroll(
                        distanceTitle,
                        style: style(ActivityType.distance.color),
                        velocity: velocity,
                        intervalSpaces: 5,
                      ),
                    ),
                    const SizedBox(width: 7.0),
                    FText(
                      '만큼 걷고',
                      style: textTheme.headlineMedium,
                    ),
                  ],
                ),
                Row(
                  children: [
                    TextScroll(
                      heightTitle,
                      style: style(ActivityType.height.color),
                      velocity: velocity,
                      intervalSpaces: 5,
                    ),
                    const SizedBox(width: 7.0),
                    FText(
                      '만큼 오르면...',
                      style: textTheme.headlineMedium,
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 300.0.h),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                FTexts(
                  ['총', '${goal.amount.round()} kcal', '를'],
                  colors: [
                    FTheme.black,
                    ActivityType.calorie.color,
                    FTheme.black
                  ],
                  style: textTheme.displaySmall,
                  alignment: MainAxisAlignment.end,
                ),
                FText(
                  '소모할 수 있어요',
                  color: FTheme.black,
                  style: textTheme.displaySmall,
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
    return GetBuilder<EditGoalP>(
      builder: (controller) {
        bool lastPage = controller.pageIndex == CarouselView.widgetCount - 1;

        return Row(
          children: [
            PButton(
              onPressed: controller.backPressed,
              text: '이전',
              textColor: Colors.black,
              backgroundColor: Colors.white,
              padding: const EdgeInsets.all(15.0),
              stretch: true,
              multiple: true,
            ),
            PButton(
              onPressed: () async {
                if (controller.keyboardVisible) {
                  FocusScope.of(context).unfocus();
                  await Future.delayed(const Duration(milliseconds: 100));
                }
                controller.nextPressed();
              },
              text: lastPage ? '완료' : '다음',
              backgroundColor: Colors.black,
              padding: const EdgeInsets.all(15.0),
              stretch: true,
              multiple: true,
            ),
          ],
        );
      },
    );
  }
}
