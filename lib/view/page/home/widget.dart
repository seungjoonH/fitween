import 'dart:math';
import 'package:fitween/presenter/global.dart';
import 'package:fitween/presenter/model/user/info.dart';
import 'package:fitween/presenter/model/user/record.dart';
import 'package:fitween/presenter/page/friend.dart';
import 'package:fitween/presenter/page/home/calendar.dart';
import 'package:fitween/presenter/page/home/ranking.dart';
import 'package:fitween/view/page/home/ranking/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gif/flutter_gif.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:fitween/global/date.dart';
import 'package:fitween/global/theme.dart';
import 'package:fitween/model/enum/activity_type.dart';
import 'package:fitween/presenter/page/home/home.dart';
import 'package:fitween/presenter/widget/loading.dart';
import 'package:fitween/view/widget/widget/card.dart';
import 'package:fitween/view/widget/widget/text.dart';

class RotateCarousel extends StatefulWidget {
  const RotateCarousel({Key? key}) : super(key: key);

  @override
  State<RotateCarousel> createState() => _RotateCarouselState();
}

class _RotateCarouselState extends State<RotateCarousel>
    with TickerProviderStateMixin {
  @override
  void initState() {
    HomeP.gifCont = FlutterGifController(vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final orientation = MediaQuery.of(context).orientation;

    const double gifRatio = 16 / 9;
    const double pngRatio = 73 / 48;
    const widthRatio = pngRatio / gifRatio;

    late Size gifSize;

    bool isPortrait = orientation == Orientation.portrait;

    if (isPortrait) {
      gifSize = Size(
        screenSize.width * 1.3,
        screenSize.width * 1.3 / gifRatio,
      );
    }
    else {
      gifSize = Size(
        screenSize.height * .65 * gifRatio,
        screenSize.height * .65,
      );
    }

    Size pngSize = Size(
      gifSize.width * widthRatio,
      gifSize.height,
    );

    bool imageOverflowed = gifSize.width > screenSize.width;

    final userRecordP = Get.find<UserRecordP>();

    return GetBuilder<HomeP>(
      builder: (homeP) {
        ActivityType type = ActivityType.activeValues[homeP.rotationIndex];
        double amount = userRecordP.loggedUser.getTodayAmounts(type);
        String amountString = '${amount.round()}';

        if (type == ActivityType.distance) {
          amountString = amount < 1000
              ? '${amount.round()}' : '${(amount / 1000).toStringAsFixed(
            amount % 1000 < 100 ? 0 : 1
          )}K';
        }

        return GestureDetector(
          onHorizontalDragEnd: (endDetails) {
            double velocity = endDetails.velocity.pixelsPerSecond.dx;
            if (velocity < -100) homeP.leftButtonPressed();
            if (velocity > 100) homeP.rightButtonPressed();
          },
          child: Stack(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    homeP.pngAsset,
                    width: gifSize.width,
                    height: gifSize.height,
                    fit: BoxFit.fitHeight,
                  ),
                  if (homeP.gifAsset != null)
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      GifImage(
                        controller: HomeP.gifCont,
                        width: gifSize.width,
                        height: gifSize.height,
                        fit: BoxFit.fitHeight,
                        image: AssetImage(homeP.gifAsset!),
                      ),
                      if (!imageOverflowed)
                      Positioned.fill(
                        child: Stack(
                          children: [
                            Positioned(
                              left: -.5,
                              child: Container(
                                width: .5 * (gifSize.width - pngSize.width) + 1,
                                height: gifSize.height,
                                color: FTheme.background,
                              ),
                            ),
                            Positioned(
                              right: -.5,
                              child: Container(
                                width: .5 * (gifSize.width - pngSize.width) + 1,
                                height: gifSize.height,
                                color: FTheme.background,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ) else Positioned(
                    top: pngSize.height * .5,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        FText(
                          amountString,
                          style: FTheme.largeText,
                          color: FTheme.white,
                        ),
                        FText(
                          type.unit,
                          style: textTheme(context).displaySmall,
                          color: FTheme.white,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                left: screenSize.width * .1,
                bottom: pngSize.height * .5,
                child: GestureDetector(
                  onTap: homeP.rightButtonPressed,
                  child: SvgPicture.asset(
                    'assets/image/page/home/left_arrow.svg',
                    width: 40.0.h,
                  ),
                ),
              ),
              Positioned(
                right: screenSize.width * .1,
                bottom: pngSize.height * .5,
                child: GestureDetector(
                  onTap: homeP.leftButtonPressed,
                  child: SvgPicture.asset(
                    'assets/image/page/home/right_arrow.svg',
                    width: 40.0.h,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class CalendarCard extends StatelessWidget {
  const CalendarCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FCard(
      title: FText('기록',
        style: textTheme(context).titleMedium,
        bold: true,
      ),
      icon: const Icon(Icons.arrow_forward_ios),
      onPressed: CalendarP.toCalendar,
      constraints: BoxConstraints(minHeight: 115.0.h),
      child: const WeekCalendarWidget(),
    );
  }
}

class WeekCalendarWidget extends StatelessWidget {
  const WeekCalendarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userP = Get.find<UserRecordP>();
    final orientation = MediaQuery.of(context).orientation;

    return GetBuilder<LoadingP>(
      builder: (loadingP) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(7, (index) {
            DateTime date = firstDayOfWeek().add(Duration(days: index));
            bool isToday = isSameDate(date, today);

            Color textColor = FTheme.lightGrey;

            List<ActivityType> completed = userP.loggedUser.completedActivities(date);
            if (completed.length == 3) { textColor = ActivityType.calorie.color; }
            else if (isToday) { textColor = FTheme.white; }

            bool isPortrait = orientation == Orientation.portrait;
            double circleRadius = isPortrait ? 36.0.r : 50.0.r;

            return Stack(
              alignment: Alignment.center,
              children: [
                if (isToday)
                Container(
                  width: circleRadius,
                  height: circleRadius,
                  decoration: const BoxDecoration(
                    color: FTheme.grey,
                    shape: BoxShape.circle,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Column(
                    children: [
                      FText(
                        '월화수목금토일'[index],
                        color: textColor,
                        style: textTheme(context).titleSmall,
                      ),
                      SizedBox(height: 2.0.h),
                      Row(
                        children: ActivityType.activeValues.map((type) {
                          Color circleColor = FTheme.lightGrey;
                          if (completed.length == 3) { circleColor = ActivityType.calorie.color; }
                          else if (completed.contains(type)) { circleColor = type.color; }
                          else if (
                            userP.loggedUser.getAmounts(type, date, nextDay(date)) == 0
                              || date.isAfter(now)
                          ) { circleColor = Colors.transparent; }

                          return Container(
                            width: 8.0.r, height: 8.0.r,
                            margin: const EdgeInsets.symmetric(horizontal: 1.0),
                            decoration: BoxDecoration(
                              color: circleColor,
                              shape: BoxShape.circle,
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
        );
      },
    );
  }
}


class RankingCard extends StatelessWidget {
  const RankingCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeP>(
      builder: (homeP) {
        final rankingP = Get.find<RankingP>();
        ActivityType type = ActivityType.activeValues[homeP.rotationIndex];

        return FCard(
          title: FText('랭킹',
            style: textTheme(context).titleMedium,
            bold: true,
          ),
          icon: const Icon(Icons.arrow_forward_ios),
          onPressed: () {
            final globalP = Get.find<GlobalP>();
            int len = (rankingP.infos[type] ?? []).length;
            if (len > 1) { RankingP.toRanking(type); }
            else { globalP.navigate(1); }
          },
          constraints: BoxConstraints(minHeight: 160.0.h),
          child: Column(
            children: [
              RankingGraph(type: type),
              if ((rankingP.infos[type] ?? []).length < 2)
              Column(
                children: [
                  const SizedBox(height: 5.0),
                  const Divider(thickness: 2, color: FTheme.stroke),
                  FText(
                    '친구를 라이벌로 지정하여 함께 대결해보세요!',
                    style: textTheme(context).bodyMedium,
                    color: FTheme.darkGrey,
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

class RankingGraph extends StatelessWidget {
  const RankingGraph({
    Key? key,
    required this.type,
  }) : super(key: key);

  final ActivityType type;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RankingP>(
      builder: (rankingP) {
        final userInfoP = Get.find<UserInfoP>();
        String myUid = userInfoP.loggedUser.uid!;

        if (rankingP.infos.isEmpty) return Container();

        int myPrice = rankingP.infos[type]!.indexWhere((info) => info.uid == myUid);
        int firstIndex = rankingP.infos[type]!.length > 3
            ? max(myPrice - 2, 0) : 0;
        double maxAmount = rankingP.records[type]![firstIndex]
            .getAmounts(type, rankingP.startDate, rankingP.endDate);

        return Column(
          children: List.generate(
            min(rankingP.infos[type]!.length, 3), (index) {
              int newIndex = firstIndex + index;
              double amount = rankingP.records[type]![newIndex]
                  .getAmounts(type, rankingP.startDate, rankingP.endDate);
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: RankingIndividualGraph(
                  type: type,
                  price: newIndex + 1,
                  nickname: rankingP.infos[type]![newIndex].nickname!,
                  amount: amount,
                  maxAmount: maxAmount,
                  isMe: rankingP.infos[type]![newIndex].uid == myUid,
                ),
              );
            },
          ),
        );
      }
    );
  }
}