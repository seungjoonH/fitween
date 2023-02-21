import 'dart:math';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_shake_animated/flutter_shake_animated.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
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
import 'package:fitween/presenter/page/register.dart';
import 'package:fitween/view/widget/button/button.dart';
import 'package:fitween/view/widget/widget/card.dart';
import 'package:fitween/view/widget/widget/text.dart';
import 'package:text_scroll/text_scroll.dart';

// 회원가입 페이지 위젯 모음

// Carousel 뷰 위젯
class CarouselView extends StatelessWidget {
  const CarouselView({Key? key}) : super(key: key);

  // 회원가입 페이지 carousel 리스트
  static List<Widget> carouselWidgets() => const [
    UserInfoView(),
    WeightHeightView(),
    SettingIntroView(),
    DistanceRecommendView(),
    DistanceGoalView(),
    HeightRecommendView(),
    HeightGoalView(),
    WeightRecommendView(),
    WeightGoalView(),
    CalorieCheckView(),
  ];

  static int widgetCount = carouselWidgets().length;

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    String asset = 'assets/image/page/register/';
    const List<int> widthFitIndex = [5, 6];

    return GetBuilder<RegisterP>(
      builder: (controller) {
        return Stack(
          children: [
            for (int i = 0; i < controller.imageExistence.length; i++)
            AnimatedPositioned(
              left: screenSize.width * (i - controller.pageIndex),
              bottom: 140.0.h,
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeInOut,
              width: screenSize.width,
              height: screenSize.height * .4,
              child: controller.imageExistence[i]
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
                        carouselController: RegisterP.carouselCont,
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

// 닉네임 입력 뷰
class UserInfoView extends StatelessWidget {
  const UserInfoView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RegisterP>(
      builder: (controller) {
        return Padding(
          padding: const EdgeInsets.all(30.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FText('별명',
                      style: textTheme.headlineSmall,
                      color: FTheme.darkGrey,
                    ),
                    const SizedBox(height: 8.0),
                    PInputField(
                      invalid: controller.fields['nickname']!.invalid,
                      controller: controller.fields['nickname']!.controller,
                      hintText: controller.fields['nickname']?.hintText ?? '별명을 입력해주세요',
                      hintColor: controller.fields['nickname']?.hintText == null
                          ? FTheme.lightGrey : FTheme.colorB,
                    ),
                    const SizedBox(height: 40.0),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FText(
                      '생년월일',
                      style: textTheme.headlineSmall,
                      color: FTheme.darkGrey,
                    ),
                    const SizedBox(height: 8.0),
                    PInputField(
                      invalid: controller.fields['dateOfBirth']!.invalid,
                      controller: controller.fields['dateOfBirth']!.controller,
                      hintText: controller.fields['dateOfBirth']?.hintText ?? 'YYYYMMDD',
                      hintColor: controller.fields['dateOfBirth']?.hintText == null
                        ? FTheme.lightGrey : FTheme.colorB,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 40.0),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FText(
                      '성별',
                      style: textTheme.headlineSmall,
                      color: FTheme.darkGrey,
                    ),
                    const SizedBox(height: 8.0),
                    ShakeWidget(
                      autoPlay: controller.fields['sex']!.invalid,
                      shakeConstant: ShakeHorizontalConstant2(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: const [
                          SexSelectionButton(sex: Sex.male),
                          SizedBox(width: 20.0),
                          SexSelectionButton(sex: Sex.female),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.0.h),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// 성별 선택 버튼
class SexSelectionButton extends StatelessWidget {
  const SexSelectionButton({Key? key, required this.sex}) : super(key: key);

  final Sex sex;

  @override
  Widget build(BuildContext context) {
    const Map<Sex, String> texts = {
      Sex.male: '남성',
      Sex.female: '여성',
    };

    return GetBuilder<RegisterP>(
      builder: (registerP) {
        return FButton(
          stretch: true,
          multiple: true,
          text: texts[sex],
          onPressed: () => registerP.setSex(sex),
          backgroundColor: sex == registerP.newcomerInfo.sex
              ? FTheme.darkGrey
              : FTheme.background,
          textColor: sex == registerP.newcomerInfo.sex
              ? FTheme.background
              : FTheme.darkGrey,
        );
      },
    );
  }
}

// 체중 신장 선택 뷰
class WeightHeightView extends StatelessWidget {
  const WeightHeightView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map<String, Widget> contents = {
      '체중': Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GetBuilder<RegisterP>(
            builder: (controller) {
              return NumberPicker(
                onChanged: controller.setWeight,
                value: controller.newcomerInfo.weight!,
                minValue: 30,
                maxValue: 220,
                textStyle: textTheme.bodyMedium?.copyWith(
                  color: FTheme.lightGrey,
                ),
                selectedTextStyle: textTheme.headlineSmall?.copyWith(
                  color: FTheme.darkGrey,
                ),
                itemHeight: 30.0,
              );
            },
          ),
          FText('kg', color: FTheme.darkGrey),
        ],
      ),
      '신장': Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GetBuilder<RegisterP>(
            builder: (controller) {
              return NumberPicker(
                onChanged: controller.setHeight,
                value: controller.newcomerInfo.height!,
                minValue: 100,
                maxValue: 220,
                textStyle: textTheme.bodyMedium?.copyWith(
                  color: FTheme.lightGrey,
                ),
                selectedTextStyle: textTheme.headlineSmall?.copyWith(
                  color: FTheme.darkGrey,
                ),
                itemHeight: 30.0,
              );
            },
          ),
          FText('cm', color: FTheme.darkGrey),
        ],
      ),
    };

    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: contents.entries.map((content) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FText(
                    content.key,
                    style: textTheme.headlineSmall,
                    color: FTheme.darkGrey,
                  ),
                  SizedBox(height: 5.0.h),
                  FCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        content.value,
                      ],
                    ),
                  ),
                  SizedBox(height: 10.0.h),
                ],
              )).toList(),
            ),
          ),
          Center(
            child: FText(
              '*체중과 신장은 간편한 계산을 위해서만 사용될 뿐\n다른 곳에는 이용되지 않아요!',
              style: textTheme.bodyMedium,
              color: FTheme.lightGrey,
              maxLines: 2,
              align: TextAlign.center,
            ),
          ),
        ],
      ),
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
    return GetBuilder<RegisterP>(
      builder: (registerP) {
        Record record = registerP.newcomerRecord.getGoal(widget.type)!;
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
                registerP.newcomerRecord.setGoal(widget.type, greaterRecord);
                setState(() {});
              },
            ),
            NumberPicker(
              onChanged: (val) {
                registerP.newcomerRecord.setGoal(
                  widget.type, Record.init(
                    widget.type, val.toDouble(), {
                      ActivityType.distance: ExerciseUnit.minute,
                      ActivityType.weight: ExerciseUnit.count,
                    }[widget.type],
                  ),
                );
                registerP.update();
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
                registerP.newcomerRecord.setGoal(widget.type, lessRecord);
                setState(() {});
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
            style: textTheme.displaySmall,
            align: TextAlign.start,
          ),
          FTexts(
            const ['이제 ', '일일 목표', '를'],
            colors: const [FTheme.black, FTheme.colorB, FTheme.black],
            alignment: MainAxisAlignment.start,
            style: textTheme.displaySmall,
            space: false,
          ),
          FText(
            '설정하러 가볼까요?',
            style: textTheme.displaySmall,
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
    return GetBuilder<RegisterP>(
      builder: (registerP) {
        int ageGroup = today.difference(
          registerP.newcomerInfo.dateOfBirth!,
        ).inDays;
        List<int> recommendTimes = [];
        ageGroup = (ageGroup / 3650).floor() * 10;

        ageGroup < 60 && registerP.newcomerInfo.sex == Sex.male;

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
                ['$ageGroup', '대 ', registerP.newcomerInfo.sex!.kr, ' 평균'],
                colors: const [
                  FTheme.colorA, FTheme.black,
                  FTheme.colorA, FTheme.black,
                ],
                alignment: MainAxisAlignment.start,
                space: false,
                style: textTheme.displaySmall,
              ),
              FTexts(
                ['매일', '${recommendTimes.length == 1
                    ? recommendTimes[0]
                    : recommendTimes.join('~')}', '분',
                ],
                colors: [FTheme.black, ActivityType.distance.color, FTheme.black],
                alignment: MainAxisAlignment.start,
                style: textTheme.displaySmall,
              ),
              FText(
                '유산소 운동이\n적당해요',
                style: textTheme.displaySmall,
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
    return GetBuilder<RegisterP>(
      builder: (registerP) {
        DistanceRecord distance = registerP.newcomerRecord.getGoal(
          ActivityType.distance,
        ) as DistanceRecord;

        int step = distance.step.round();
        int minute = distance.minute.round();
        int kilometer = distance.kilometer.round();

        Map<String, dynamic> tier = LevelPresenter.getTier(
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
                        FText('만큼 걸을 수 있어요', style: textTheme.displaySmall),
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
      ),
    );
  }
}

class HeightGoalView extends StatelessWidget {
  const HeightGoalView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RegisterP>(
      builder: (registerP) {
        HeightRecord goal = registerP.newcomerRecord.getGoal(
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
                  FText('만큼 오를 수 있어요', style: textTheme.displaySmall),
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
          FText('무게 멘트', style: textTheme.displaySmall, color: FTheme.colorA),
          FText('무게 멘트', style: textTheme.displaySmall),
          FText('무게 멘트', style: textTheme.displaySmall),
          FTexts(
            const ['무게', '멘트'],
            colors: [ActivityType.weight.color, FTheme.black],
            style: textTheme.displaySmall,
            alignment: MainAxisAlignment.start,
          ),
        ],
      ),
    );
  }
}


class WeightGoalView extends StatelessWidget {
  const WeightGoalView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RegisterP>(
      builder: (registerP) {
        WeightRecord goal = registerP.newcomerRecord.getGoal(
          ActivityType.weight,
        ) as WeightRecord;

        Map<String, dynamic> tier = LevelPresenter.getTier(
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
                          weightTitle,
                          style: textTheme.displaySmall?.merge(TextStyle(
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
                    style: textTheme.displaySmall,
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
    return GetBuilder<RegisterP>(
      builder: (registerP) {
        CalorieRecord goal = registerP.newcomerRecord.getGoal(
          ActivityType.calorie,
        ) as CalorieRecord;

        String distanceTitle = LevelPresenter.getTier(
          ActivityType.distance,
          registerP.newcomerRecord.getGoal(ActivityType.distance)!,
        )['current'].title;

        String heightTitle = LevelPresenter.getTier(
          ActivityType.height,
          registerP.newcomerRecord.getGoal(ActivityType.height)!,
        )['current'].title;

        TextStyle? style(Color color) => textTheme.headlineMedium?.merge(TextStyle(
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
                FText('하루에', style: textTheme.headlineMedium),
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
                      style: textTheme.headlineMedium,
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
                      style: textTheme.headlineMedium,
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
                  style: textTheme.displaySmall,
                  alignment: MainAxisAlignment.end,
                ),
                FText('소모할 수 있어요',
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
    return GetBuilder<RegisterP>(
      builder: (controller) {
        bool lastPage = controller.pageIndex == CarouselView.widgetCount - 1;

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
