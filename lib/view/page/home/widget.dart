import 'dart:math';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:fitween/global/date.dart';
import 'package:fitween/global/string.dart';
import 'package:fitween/global/theme.dart';
import 'package:fitween/model/class/database/collection.dart';
import 'package:fitween/model/class/database/user.dart';
import 'package:fitween/model/class/json/level.dart';
import 'package:fitween/model/enum/activity_type.dart';
import 'package:fitween/model/enum/border_type.dart';
import 'package:fitween/model/enum/unit.dart';
import 'package:fitween/presenter/global.dart';
import 'package:fitween/presenter/model/badge.dart';
import 'package:fitween/presenter/model/level.dart';
import 'package:fitween/presenter/model/quest.dart';
import 'package:fitween/presenter/model/record.dart';
import 'package:fitween/presenter/model/user.dart';
import 'package:fitween/presenter/page/collection/main.dart';
import 'package:fitween/presenter/page/home.dart';
import 'package:fitween/presenter/page/my/record/main.dart';
import 'package:fitween/presenter/page/quest/main.dart';
import 'package:fitween/presenter/widget/loading.dart';
import 'package:fitween/view/widget/button/button.dart';
import 'package:fitween/view/widget/widget/card.dart';
import 'package:fitween/view/widget/widget/badge.dart';
import 'package:fitween/view/widget/widget/indicator.dart';
import 'package:fitween/view/widget/widget/text.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomePresenter>(
      builder: (homeP) {
        return GetBuilder<LoadingPresenter>(
          builder: (loadingP) {
            return SmartRefresher(
              controller: HomePresenter.refreshCont,
              onRefresh: () async {
                await homeP.init();
                HomePresenter.refreshCont.refreshCompleted();
              },
              onLoading: () async {
                await Future.delayed(const Duration(milliseconds: 100));
                HomePresenter.refreshCont.loadComplete();
              },
              header: const MaterialClassicHeader(
                color: PTheme.black,
                backgroundColor: PTheme.surface,
              ),
              child: SingleChildScrollView(
                child: !loadingP.loading ? Column(
                  children: [
                    const HomeRandomCardView(),
                    Column(
                      children: [
                        SizedBox(height: 30.0.h),
                        const DailyActivityCardView(),
                        SizedBox(height: 30.0.h),
                        const MonthlyQuestWidget(),
                        SizedBox(height: 30.0.h),
                        const CollectionCardView(),
                        SizedBox(height: 30.0.h),
                      ],
                    ),
                  ],
                ) : HomeLoading(color: loadingP.color),
              ),
            );
          },
        );
      },
    );
  }
}

class WidgetHeader extends StatelessWidget {
  const WidgetHeader({
    Key? key,
    required this.title,
    required this.button,
  }) : super(key: key);

  final String title;
  final Widget button;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      height: 40.0.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          PText(title, style: textTheme.headlineSmall),
          button,
        ],
      ),
    );
  }
}

class HomeRandomCardView extends StatelessWidget {
  const HomeRandomCardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PUser user = Get.find<UserPresenter>().loggedUser;

    List<Widget> items = [
      const QuestRecommendCard(),
      const LifeExtensionCard(),
      if (ignoreTime(user.regDate!) != today)
      const YesterdayComparisonCard(),
      const MyRecordCard(),
    ].map((widget) => Padding(
      padding: EdgeInsets.fromLTRB(20.0.r, 20.0.r, 20.0.r, 0.0.r),
      child: widget,
    )).toList();

    items.shuffle();

    return CarouselSlider(
      items: items,
      options: CarouselOptions(
        height: 250.0.h,
        viewportFraction: 1.0,
        autoPlay: true,
      ),
    );
  }
}

class QuestRecommendCard extends StatelessWidget {
  const QuestRecommendCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PCard(
      color: PTheme.white,
      onPressed: QuestMain.toQuestMain,
      rounded: true,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              PTexts(
                ['${today.month}월', '의 목표'],
                colors: const [PTheme.colorA, PTheme.black],
                style: textTheme.titleLarge,
                alignment: MainAxisAlignment.start,
                space: false,
              ),
              SizedBox(height: 10.0.h),
              PText(
                '를 달성하고 컬렉션을 모아보세요.',
                style: textTheme.labelMedium,
                color: PTheme.grey,
              ),
            ],
          ),
          SizedBox(height: 20.0.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              BadgeWidget(
                badge: BadgePresenter.getBadge(
                  '10401${(today.month - 1).toString().padLeft(2, '0')}'),
                size: 54.0,
              ).animate().fadeIn(
                delay: const Duration(milliseconds: 300),
                duration: const Duration(milliseconds: 500),
              ).scale(
                begin: const Offset(.7, .7),
                duration: const Duration(milliseconds: 1000),
                curve: Curves.elasticOut,
              ),
              BadgeWidget(
                badge: BadgePresenter.getBadge(
                  '10400${(today.month - 1).toString().padLeft(2, '0')}'),
                size: 70.0,
              ).animate().fadeIn(
                delay: const Duration(milliseconds: 700),
                duration: const Duration(milliseconds: 500),
              ).scale(
                begin: const Offset(.7, .7),
                duration: const Duration(milliseconds: 1000),
                curve: Curves.elasticOut,
              ),
              BadgeWidget(
                badge: BadgePresenter.getBadge(
                  '10402${(today.month - 1).toString().padLeft(2, '0')}'),
                size: 54.0,
              ).animate().fadeIn(
                delay: const Duration(milliseconds: 500),
                duration: const Duration(milliseconds: 500),
              ).scale(
                begin: const Offset(.7, .7),
                duration: const Duration(milliseconds: 1000),
                curve: Curves.elasticOut,
              ),
            ],
          ),
          SizedBox(height: 20.0.h),
        ],
      ),
    );
  }
}

class LifeExtensionCard extends StatelessWidget {
  const LifeExtensionCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userP = Get.find<UserPresenter>();
    PUser user = userP.loggedUser;
    double todayHeights = user.getTodayAmounts(ActivityType.height);
    double lifeExtension = 100 * todayHeights;
    String string = timeToString(lifeExtension.ceil());

    if (lifeExtension >= 60 * 60 * 24) {
      string = '약 ${timeToString((lifeExtension ~/ 3600) * 3600)}';
    } else if (lifeExtension >= 60 * 60) {
      string = '약 ${timeToString((lifeExtension ~/ 60) * 60)}';
    }
    return PCard(
      color: PTheme.white,
      rounded: true,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (todayHeights == 0)
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              PText(
                '계단을 올라 수명을 연장해보세요',
                style: textTheme.titleLarge,
              ),
              SizedBox(height: 10.0.h),
              PText(
                '한 층을 오르면 수명이 1분 40초 늘어나요!',
                style: textTheme.labelMedium,
                color: PTheme.grey,
              ),
            ],
          ),
          if (todayHeights > 0)
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                PTexts(
                  ['수명이', string, '연장되었어요'],
                  colors: [PTheme.black, ActivityType.height.color, PTheme.black],
                  style: textTheme.titleLarge,
                  alignment: MainAxisAlignment.start,
                ),
                SizedBox(height: 10.0.h),
                PText(
                  '한 층을 오르면 수명이 1분 40초 늘어나요!',
                  style: textTheme.labelMedium,
                  color: PTheme.grey,
                ),
              ],
            ),
          SizedBox(height: 20.0.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/image/page/home/heart.png',
                height: 80.0.h,
              ).animate(
                onPlay: (cont) => cont.repeat(),
              ).scale(
                duration: const Duration(milliseconds: 1000),
                begin: const Offset(.9, .9),
                end: const Offset(.7, .7),
              ),
              SizedBox(width: 20.0.w),
            ],
          ),
          SizedBox(height: 20.0.h),
        ],
      ),
    );
  }
}

class YesterdayComparisonCard extends StatelessWidget {
  const YesterdayComparisonCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomePresenter>(
      builder: (controller) {
        return PCard(
          color: PTheme.white,
          rounded: true,
          onPressed: controller.slideLeftActivityCard,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              PText('어제와 비교해서', style: textTheme.titleLarge),
              const SizedBox(height: 10.0),
              Expanded(
                child: GetBuilder<UserPresenter>(
                  builder: (controller) {
                    Map<ActivityType, double> diffs = {};
                    Map<ActivityType, List<String>> diffMessages = {};
                    late String last;

                    for (ActivityType type in ActivityType.activeValues) {
                      double todays = controller.loggedUser.getTodayAmounts(type);
                      double yesterdays = controller.loggedUser.getAmounts(
                        type, yesterday, oneSecondBefore(today),
                      );

                      double diff = todays - yesterdays;
                      diffs[type] = diff;
                      diffMessages[type] = [];

                      last = type == ActivityType.calorie
                          ? type.did : '${type.and},';

                      if (diff == 0) {
                        diffMessages[type]!.addAll(['비슷하게', last]);
                        continue;
                      }
                      diffMessages[type]!.add('${diff.abs().round()}${type.unit}');
                      diffMessages[type]!.add('${diff > 0 ? '더' : '덜'} $last');
                    }

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Stack(
                          children: [
                            PTexts(
                              diffMessages[ActivityType.distance]!,
                              colors: [ActivityType.distance.color, PTheme.black],
                              style: textTheme.titleLarge,
                              alignment: MainAxisAlignment.start,
                            ).animate().fadeIn(
                              duration: const Duration(milliseconds: 600),
                              delay: const Duration(milliseconds: 300),
                            ),
                          ],
                        ),
                        Stack(
                          children: [
                            PTexts(
                              diffMessages[ActivityType.height]!,
                              colors: [ActivityType.height.color, PTheme.black],
                              style: textTheme.titleLarge,
                              alignment: MainAxisAlignment.center,
                            ).animate().fadeIn(
                              duration: const Duration(milliseconds: 600),
                              delay: const Duration(milliseconds: 600),
                            ),
                          ],
                        ),
                        Stack(
                          children: [
                            PTexts(
                              diffMessages[ActivityType.calorie]!,
                              colors: [ActivityType.calorie.color, PTheme.black],
                              style: textTheme.titleLarge,
                              alignment: MainAxisAlignment.end,
                            ).animate().fadeIn(
                              duration: const Duration(milliseconds: 600),
                              delay: const Duration(milliseconds: 900),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class MyRecordCard extends StatelessWidget {
  const MyRecordCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ActivityType randomType = (
      ActivityType.activeValues.sublist(1, 3)..shuffle()
    ).first;
    PUser user = Get.find<UserPresenter>().loggedUser;
    double amounts = user.getAmounts(randomType);
    Record record = Record.init(randomType, amounts, ExerciseUnit.step);

    Map<String, dynamic> tier = LevelPresenter.getTier(randomType, record);
    Level current = tier['current'];

    return PCard(
      color: PTheme.waterLight,
      rounded: true,
      padding: EdgeInsets.zero,
      onPressed: () => MyRecordMain.toMyRecordMain(randomType),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            bottom: 20.0.h,
            child: Image.asset(
              'assets/image/level/${randomType.name}/${current.id}.png',
              width: 70.0.w,
              fit: BoxFit.fitWidth,
            ),
          ).animate(
          ).fadeIn(
            delay: const Duration(milliseconds: 300),
          ).move(
            begin: const Offset(0.0, -20.0),
            curve: Curves.elasticOut,
            duration: const Duration(milliseconds: 2500),
          ),
          Container(
            padding: EdgeInsets.all(20.0.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                PTexts(['지금까지 ', '${amounts.round()}${randomType.unitAlt}',
                  '를 ${randomType.cause}'
                ], colors: [PTheme.black, randomType.color, PTheme.black],
                  style: textTheme.titleLarge,
                  alignment: MainAxisAlignment.start,
                  space: false,
                  shadows: const [Shadow(
                    blurRadius: 20.0,
                    color: PTheme.white,
                  )],
                ),
                if (current.title!.length > 12)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PText(current.title!,
                      color: randomType.color,
                      style: textTheme.titleLarge,
                      shadows: const [Shadow(
                        blurRadius: 20.0,
                        color: PTheme.white,
                      )],
                    ),
                    PText('${eulReul(current.title!)} 정복했어요!',
                      color: PTheme.black,
                      style: textTheme.titleLarge,
                      shadows: const [Shadow(
                        blurRadius: 20.0,
                        color: PTheme.white,
                      )],
                    ),
                  ],
                ) else PTexts(
                  ['${current.title}', '${eulReul(current.title!)} 정복했어요!'],
                  colors: [randomType.color, PTheme.black],
                  style: textTheme.titleLarge,
                  alignment: MainAxisAlignment.start,
                  space: false,
                  shadows: const [Shadow(
                    blurRadius: 20.0,
                    color: PTheme.white,
                  )],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


class DailyActivityCardView extends StatelessWidget {
  const DailyActivityCardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomePresenter>(
      builder: (controller) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            WidgetHeader(
              title: '${controller.isToday ? '오늘' : '어제'} 활동량',
              button: const PTextButton(
                text: '목표 수정',
                color: PTheme.grey,
                onPressed: HomePresenter.showRouteEditGoalCheckDialog,
              ),
            ),
            SizedBox(height: 10.0.h),
            Stack(
              alignment: Alignment.center,
              children: [
                PCard(
                  padding: EdgeInsets.zero,
                  borderType: BorderType.horizontal,
                  borderWidth: 3.0,
                  color: PTheme.surface,
                  child: CarouselSlider(
                    carouselController: HomePresenter.carouselCont,
                    items: [
                      GridView(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1.w / 1.h,
                        ),
                        children: ActivityType.values.map((type) => DailyActivityCircularGraph(
                          type: type, date: yesterday, animation: false,
                        )).toList(),
                      ),
                      GridView(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1.w / 1.h,
                        ),
                        children: ActivityType.values.map((type) => DailyActivityCircularGraph(
                          type: type,
                        )).toList(),
                      )
                    ],
                    options: CarouselOptions(
                      aspectRatio: 1.w / 1.h,
                      viewportFraction: 1.0,
                      enableInfiniteScroll: false,
                      initialPage: 1,
                      onPageChanged: (index, _) => controller.pageChanged(index),
                    ),
                  ),
                ),
                if (controller.isToday)
                Positioned(
                  left: 5.0,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    onPressed: controller.slideLeftActivityCard,
                    color: PTheme.grey,
                  ).animate().fadeIn(),
                ) else Positioned(
                  right: 5.0,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_forward_ios),
                    onPressed: controller.slideRightActivityCard,
                    color: PTheme.grey,
                  ).animate().fadeIn(),
                ),
              ],
            ),
          ],
        );
      }
    );
  }
}

class DailyActivityCircularGraph extends StatelessWidget {
  DailyActivityCircularGraph({
    Key? key,
    required this.type,
    DateTime? date,
    this.animation = true,
  }) : date = date ?? today, super(key: key);

  final ActivityType type;
  final DateTime date;
  final bool animation;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomePresenter>(
      builder: (controller) {
        final userP = Get.find<UserPresenter>();
        PUser user = userP.loggedUser;

        DateTime nextDate = date.add(const Duration(days: 1));
        DateTime startTime = date;
        DateTime endTime = oneSecondBefore(nextDate);

        int dailyRecord = user.getAmounts(type, startTime, endTime).round();
        int goal = max((user.getGoal(type)!.amount).round(), 1);

        double earlierPercent = min(dailyRecord / goal, 1);
        double laterPercent = max(min(dailyRecord - goal, goal) / goal, 0);
        double totalPercent = max(earlierPercent + laterPercent, .0001);

        const int totalDuration = 1500;
        int earlierDuration = totalDuration * earlierPercent ~/ totalPercent;
        if (laterPercent == 0) earlierDuration = totalDuration;
        int laterDuration = totalDuration * laterPercent ~/ totalPercent;

        return Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    PCircularPercentIndicator(
                      percent: earlierPercent,
                      duration: earlierDuration,
                      centerText: type.kr,
                      color: type.color,
                      textColor: type.color,
                      borderColor: PTheme.black,
                      backgroundColor: PTheme.bar,
                      onAnimationEnd: () => controller.showLaterGraph(type),
                      animation: animation,
                    ),
                    PCircularPercentIndicator(
                      visible: controller.graphStates[type]!,
                      percent: laterPercent,
                      duration: laterDuration,
                      color: PTheme.white.withOpacity(.3),
                      borderColor: PTheme.black,
                      backgroundColor: Colors.transparent,
                      animation: animation,
                    ),
                  ],
                ),
                SizedBox(height: 10.0.h),
                SizedBox(
                  height: 20.0.h,
                  child: PTexts(
                    ['$dailyRecord', '/$goal ${type.unit}'],
                    colors: [type.color, PTheme.black],
                    style: textTheme.labelLarge,
                    space: false,
                  ),
                ),
              ],
            ),
            if (!type.active)
            Positioned.fill(
              child: Stack(
                children: [
                  Container(
                    color: PTheme.surface,
                    alignment: Alignment.center,
                    child: Icon(Icons.lock, size: 30.0.r),
                  ),
                  Container(
                    color: PTheme.black.withOpacity(.3),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class MonthlyQuestWidget extends StatelessWidget {
  const MonthlyQuestWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const WidgetHeader(
          title: '월간 목표',
          button: PTextButton(
            text: '더 보기',
            color: PTheme.grey,
            onPressed: QuestMain.toQuestMain,
          ),
        ),
        SizedBox(height: 10.0.h),
        Container(
          decoration: BoxDecoration(
            border: Border.symmetric(
              horizontal: BorderSide(
                color: PTheme.black,
                width: 2.5.h,
              ),
            ),
          ),
          child: Column(
            children: ActivityType.values.map((type) => MonthlyQuestProgressWidget(
              type: type,
            )).toList(),
          ),
        ),
      ],
    );
  }
}

class MonthlyQuestProgressWidget extends StatelessWidget {
  const MonthlyQuestProgressWidget({
    Key? key,
    required this.type,
  }) : super(key: key);

  final ActivityType type;

  @override
  Widget build(BuildContext context) {
    final userP = Get.find<UserPresenter>();
    PUser user = userP.loggedUser;
    const String directory = 'assets/image/page/home/';

    Record record = Record.init(
      type, user.getThisMonthAmounts(type),
      ExerciseUnit.step,
    );

    int goal = QuestPresenter.quests[type] ?? 1;
    double percent = min(record.amount / goal, 1);

    // Badge? questBadge = BadgePresenter.getThisMonthQuestBadge(type);

    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            border: Border.symmetric(
              horizontal: BorderSide(
                color: PTheme.black,
                width: .5,
              ),
            ),
          ),
          height: 80.0.h,
          child: Row(
            children: [
              Expanded(
                flex: 1,
                // child: BadgeWidget(badge: questBadge, size: 60.0),
                child: type.active
                    ? Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Image.asset('$directory${type.name}.png'),
                    ) : Container(),
              ),
              const VerticalDivider(
                color: PTheme.black,
                width: 0.0,
                thickness: 1.0,
              ),
              Expanded(
                flex: 3,
                child: Stack(
                  children: [
                    LinearPercentIndicator(
                      padding: const EdgeInsets.only(left: 1.0),
                      progressColor: type.color,
                      lineHeight: double.infinity,
                      backgroundColor: PTheme.surface,
                      percent: percent < .01 ? .01 : percent,
                    ),
                    Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            PText(
                              type.kr,
                              style: textTheme.titleMedium,
                            ),
                            PText(
                              '${(percent * 100).ceil()} %',
                              style: textTheme.titleMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (!type.active)
          Positioned.fill(
            child: Stack(
              children: [
                Container(
                  color: PTheme.surface,
                  alignment: Alignment.center,
                  child: Icon(Icons.lock, size: 30.0.r),
                ),
                Container(
                  color: PTheme.black.withOpacity(.3),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class CollectionCardView extends StatelessWidget {
  const CollectionCardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userP = Get.find<UserPresenter>();
    PUser user = userP.loggedUser;

    List<Widget> collectionWidgets =
        List.generate(3, (_) => CollectionWidget());
    for (int i = 0; i < min(user.orderedCollections.length, 3); i++) {
      Collection collection = user.orderedCollections[i];
      collectionWidgets[i] = CollectionWidget(
        onPressed: () => GlobalPresenter.showCollectionDialog(collection),
        collection: collection,
        detail: true,
      );
    }

    return Column(
      children: [
        const WidgetHeader(
          title: '컬렉션',
          button: PTextButton(
            text: '더 보기',
            color: PTheme.grey,
            onPressed: CollectionMain.toCollectionMain,
          ),
        ),
        SizedBox(height: 10.0.h),
        PCard(
          borderType: BorderType.horizontal,
          borderWidth: 3.0,
          color: PTheme.surface,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: collectionWidgets,
          ),
        ),
      ],
    );
  }
}

class HomeLoading extends StatelessWidget {
  const HomeLoading({
    Key? key,
    this.color = PTheme.black,
  }) : super(key: key);

  final Color color;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(20.0.r, 20.0.r, 20.0.r, 0.0),
            child: PCard(
              color: color,
              rounded: true,
              borderColor: Colors.transparent,
              child: Container(
                height: 187.0.h,
              ),
            ),
          ),
          Container(height: 82.0.h),
          Container(
            color: color,
            height: 362.0.h,
            child: GridView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.w / 1.h,
              ),
              children: List.generate(
                  4,
                  (_) => Padding(
                        padding: EdgeInsets.all(20.0.r),
                        child: Column(
                          children: [
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  width: 112.0.r,
                                  height: 112.0.r,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: PTheme.white,
                                  ),
                                ),
                                Container(
                                  width: 112.0.r,
                                  height: 112.0.r,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: PTheme.background,
                                  ),
                                ),
                                Container(
                                  width: 76.0.r,
                                  height: 76.0.r,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: color,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )),
            ),
          ),
          SizedBox(height: 82.0.h),
          Container(
            height: 326.0.h,
            color: color,
          ),
          SizedBox(height: 78.0.h),
          PCard(
            borderType: BorderType.horizontal,
            borderWidth: 3.0,
            color: color,
            borderColor: Colors.transparent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(3, (_) => Stack(
                children: [
                  CollectionWidget(
                    color: PTheme.surface,
                    border: false,
                    detail: true,
                  ),
                ],
              )),
            ),
          ),
          SizedBox(height: 30.0.h),
        ],
      ),
    );
  }
}
