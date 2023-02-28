import 'dart:math';
import 'package:fitween/presenter/model/user/info.dart';
import 'package:fitween/presenter/model/user/record.dart';
import 'package:fitween/presenter/page/calendar.dart';
import 'package:fitween/presenter/page/ranking.dart';
import 'package:fitween/view/page/ranking/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gif/flutter_gif.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:fitween/global/date.dart';
import 'package:fitween/global/theme.dart';
import 'package:fitween/model/enum/activity_type.dart';
import 'package:fitween/presenter/page/home.dart';
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

  // @override
  // void dispose() {
  //   HomeP.gifCont.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    final userRecordP = Get.find<UserRecordP>();

    return GetBuilder<HomeP>(
      builder: (homeP) {
        ActivityType type = ActivityType.activeValues[homeP.rotationIndex];
        double amount = userRecordP.loggedUser.getTodayAmounts(type);
        String amountString = '${amount.round()}';

        if (type == ActivityType.distance) {
          amountString = '${(amount / 1000).toStringAsFixed(
            amount % 1000 < 100 ? 0 : 1
          )}K';
        }

        return Padding(
          padding: const EdgeInsets.only(top: 60.0),
          child: Stack(
            children: [
              // onHorizontalDragEnd: (endDetails) {
              //   double velocity = endDetails.velocity.pixelsPerSecond.dx;
              //   if (velocity < -100) homeP.leftButtonPressed();
              //   if (velocity > 100) homeP.rightButtonPressed();
              // },
              Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    homeP.pngAsset,
                    width: HomeP.screenSize.width * 1.3,
                    height: HomeP.screenSize.height * .4,
                    fit: BoxFit.fitHeight,
                  ),
                  if (homeP.gifAsset != null)
                  Stack(
                    children: [
                      GifImage(
                        controller: HomeP.gifCont,
                        width: HomeP.screenSize.width * 1.3,
                        height: HomeP.screenSize.height * .4,
                        fit: BoxFit.fitHeight,
                        image: AssetImage(homeP.gifAsset!),
                      ),
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            color: FTheme.white.withOpacity(.09),
                          ),
                        ),
                      ),
                    ],
                  ) else Positioned(
                    top: 150.0.h,
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
                          style: textTheme.displaySmall,
                          color: FTheme.white,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                left: HomeP.screenSize.width * .08,
                bottom: 150.0,
                child: GestureDetector(
                  onTap: homeP.leftButtonPressed,
                  child: SvgPicture.asset(
                    'assets/image/page/home/left_arrow.svg',
                  ),
                ),
              ),
              Positioned(
                right: HomeP.screenSize.width * .08,
                bottom: 150.0,
                child: GestureDetector(
                  onTap: homeP.rightButtonPressed,
                  child: SvgPicture.asset(
                    'assets/image/page/home/right_arrow.svg',
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
      title: '기록',
      activateSeeMore: true,
      onPressed: CalendarP.toCalendar,
      constraints: const BoxConstraints(minHeight: 115.0),
      child: const WeekCalendarWidget(),
    );
  }
}

class WeekCalendarWidget extends StatelessWidget {
  const WeekCalendarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userP = Get.find<UserRecordP>();
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

            return Stack(
              alignment: Alignment.center,
              children: [
                if (isToday)
                Container(
                  width: 36.0, height: 36.0,
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
                        style: textTheme.titleSmall,
                      ),
                      const SizedBox(height: 2.0),
                      Row(
                        children: ActivityType.activeValues.map((type) {
                          Color circleColor = FTheme.lightGrey;
                          if (completed.length == 3) { circleColor = ActivityType.calorie.color; }
                          else if (completed.contains(type)) { circleColor = type.color; }
                          else if (
                            userP.loggedUser.getAmounts(type, date) == 0
                              || date.isAfter(now)
                          ) { circleColor = Colors.transparent; }

                          return Container(
                            width: 8.0, height: 8.0,
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
        ActivityType type = ActivityType.activeValues[homeP.rotationIndex];

        return FCard(
          title: '랭킹',
          activateSeeMore: true,
          onPressed: () => RankingP.toRanking(type),
          constraints: const BoxConstraints(minHeight: 160.0),
          child: Column(
            children: [
              RankingGraph(type: type),
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

        int myPrice = rankingP.infos[type]!.indexWhere((info) => info.uid == myUid);
        int firstIndex = rankingP.infos[type]!.length > 3 ? myPrice - 1 : 0;
        double maxAmount = rankingP.records[type]![firstIndex]
            .getAmounts(type, rankingP.startDate, rankingP.endDate);

        return Column(
          children: List.generate(
            min(rankingP.infos.length, 3), (index) {
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