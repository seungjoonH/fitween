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

    return GetBuilder<EditGoal>(
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
                        carouselController: EditGoal.carouselCont,
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
    this.color = PTheme.black,
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
    return GetBuilder<EditGoal>(
      builder: (controller) {
        Record record = controller.user.getGoal(widget.type)!;
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
                    ? PTheme.black
                    : Colors.transparent,
              ),
              onPressed: () {
                controller.user.setGoal(widget.type, greaterRecord);
                setState(() {});
              },
            ),
            NumberPicker(
              onChanged: (val) {
                controller.user.setGoal(
                  widget.type,
                  Record.init(
                    widget.type,
                    val.toDouble(),
                    ExerciseUnit.minute,
                  ),
                );
                controller.update();
              },
              itemCount: widget.itemCount,
              itemWidth: widget.itemWidth,
              itemHeight: widget.itemHeight,
              value: record.amount.round(),
              minValue: widget.minValue,
              maxValue: widget.maxValue,
              textStyle: widget.style?.apply(color: PTheme.grey),
              selectedTextStyle: widget.style?.apply(color: widget.color),
            ),
            IconButton(
              icon: Icon(
                Icons.arrow_drop_down,
                size: 40.0.r,
                color: record.amount < widget.maxValue
                    ? PTheme.black
                    : Colors.transparent,
              ),
              onPressed: () {
                controller.user.setGoal(widget.type, lessRecord);
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
    return GetBuilder<EditGoal>(
      builder: (controller) {
        int ageGroup = today.difference(controller.user.dateOfBirth!).inDays;
        List<int> recommendTimes = [];
        ageGroup = (ageGroup / 3650).floor() * 10;

        ageGroup < 60 && controller.user.sex == Sex.male;

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
            PTexts(
              ['$ageGroup', '대 ', controller.user.sex!.kr, ' 평균'],
              colors: const [
                PTheme.colorA,
                PTheme.black,
                PTheme.colorA,
                PTheme.black,
              ],
              alignment: MainAxisAlignment.start,
              space: false,
              style: textTheme.displaySmall,
            ),
            PTexts(
              [
                '매일',
                '${recommendTimes.length == 1 ? recommendTimes[0] : recommendTimes.join('~')}',
                '분',
              ],
              colors: [PTheme.black, ActivityType.distance.color, PTheme.black],
              alignment: MainAxisAlignment.start,
              style: textTheme.displaySmall,
            ),
            PText(
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
    return GetBuilder<EditGoal>(
      builder: (controller) {
        DistanceRecord distance = controller.user.getGoal(
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
                style: PTheme.largeText,
                maxValue: 200,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                PTexts(
                  ['하루 ', '$minute', '분이면'],
                  colors: const [PTheme.black, PTheme.colorA, PTheme.black],
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
                    PText('(${unitDistance(distanceValue.step.round())}보)'),
                  ],
                ),
                PText(
                  '${eulReul(distanceTitle)} 정복할 수 있어요',
                  style: textTheme.displaySmall,
                ),
                PTexts(
                  ['* 약 ', '${toLocalString(step)}보 (${kilometer}km)'],
                  colors: const [PTheme.grey, PTheme.colorB],
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
        PText('한 층을', style: textTheme.displaySmall, color: PTheme.colorA),
        PText('오를 때마다', style: textTheme.displaySmall),
        PText('건강 수명이', style: textTheme.displaySmall),
        PTexts(
          const ['1분 40초', '연장돼요'],
          colors: [ActivityType.height.color, PTheme.black],
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
    return GetBuilder<EditGoal>(
      builder: (controller) {
        HeightRecord goal = controller.user.getGoal(
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
                PTexts(
                  ['하루', '${goal.amount.round()}', '층이면'],
                  colors: [
                    PTheme.black,
                    ActivityType.calorie.color,
                    PTheme.black
                  ],
                  alignment: MainAxisAlignment.start,
                  style: style(PTheme.black),
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
                    PText('(${heightValue.amount.round()}층)'),
                  ],
                ),
                PText('을 정복할 수 있어요', style: textTheme.displaySmall),
                const SizedBox(height: 10.0),
                PTexts(
                  ['* 수명 약', timeToString((100 * goal.amount).round()), '연장'],
                  colors: [PTheme.grey, ActivityType.height.color, PTheme.grey],
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
                style: PTheme.largeText,
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
    return GetBuilder<EditGoal>(
      builder: (controller) {
        CalorieRecord goal = controller.user.getGoal(
          ActivityType.calorie,
        ) as CalorieRecord;

        String distanceTitle = LevelPresenter.getTier(
          ActivityType.distance,
          controller.user.getGoal(ActivityType.distance)!,
        )['current'].title;

        String heightTitle = LevelPresenter.getTier(
          ActivityType.height,
          controller.user.getGoal(ActivityType.height)!,
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
                PText('하루에', style: textTheme.headlineMedium),
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
                    PText(
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
                    PText(
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
                PTexts(
                  ['총', '${goal.amount.round()} kcal', '를'],
                  colors: [
                    PTheme.black,
                    ActivityType.calorie.color,
                    PTheme.black
                  ],
                  style: textTheme.displaySmall,
                  alignment: MainAxisAlignment.end,
                ),
                PText(
                  '소모할 수 있어요',
                  color: PTheme.black,
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
    return GetBuilder<EditGoal>(
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
