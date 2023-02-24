import 'dart:math';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:fitween/model/class/database/user/info.dart';
import 'package:fitween/model/class/database/user/record.dart';
import 'package:fitween/presenter/model/user/friend.dart';
import 'package:fitween/presenter/model/user/info.dart';
import 'package:fitween/presenter/model/user/record.dart';
import 'package:fitween/presenter/page/calendar.dart';
import 'package:fitween/presenter/page/record/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_gif/flutter_gif.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
  void dispose() {
    HomeP.gifCont.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeP>(
      builder: (homeP) {
        return Padding(
          padding: const EdgeInsets.only(top: 60.0),
          child: Stack(
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
              ),
              Positioned(
                left: HomeP.screenSize.width * .08,
                bottom: 150.0,
                child: GestureDetector(
                  onTap: homeP.leftButtonPressed,
                  child:
                      SvgPicture.asset('assets/image/page/home/left_arrow.svg'),
                ),
              ),
              Positioned(
                right: HomeP.screenSize.width * .08,
                bottom: 150.0,
                child: GestureDetector(
                  onTap: homeP.rightButtonPressed,
                  child: SvgPicture.asset(
                      'assets/image/page/home/right_arrow.svg'),
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
    return const FCard(
      title: '기록',
      activateSeeMore: true,
      onPressed: CalendarP.toCalendar,
      child: WeekCalendarWidget(),
    );
  }
}

class WeekCalendarWidget extends StatelessWidget {
  const WeekCalendarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserRecordP>(
      builder: (userP) {
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
      }
    );
  }
}


class RankingCard extends StatelessWidget {
  const RankingCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FCard(
      title: '랭킹',
      activateSeeMore: true,
      onPressed: () {},
      child: Column(
        children: [
          const RankingGraph(type: ActivityType.distance),
        ],
      ),
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
    final startDate = firstDayOfWeek(today);
    final endDate = today;

    return GetBuilder<UserFriendP>(
      builder: (userFriendP) {
        final userInfoP = Get.find<UserInfoP>();
        final userRecordP = Get.find<UserRecordP>();

        String myUid = userRecordP.loggedUser.uid!;

        List<FUserInfo> infos = userFriendP.loggedUser.rivalInfos;
        List<FUserRecord> records = userFriendP.loggedUser.rivalRecords;

        infos.add(userInfoP.loggedUser);
        records.add(userRecordP.loggedUser);
        records.sort((a, b) => (
            b.getAmounts(type, startDate, endDate)
                - a.getAmounts(type, startDate, endDate)
        ).round());

        infos.sort((a, b) {
          int priceA = records.indexWhere((record) => record.uid == a.uid);
          int priceB = records.indexWhere((record) => record.uid == b.uid);
          return (records[priceB].getAmounts(type, startDate, endDate)
              - records[priceA].getAmounts(type, startDate, endDate)).round();
        });

        int myPrice = infos.indexWhere((info) => info.uid == myUid);
        int firstIndex = infos.length > 3 ? myPrice : 0;
        double maxAmount = records[firstIndex].getAmounts(type, startDate, endDate);

        return Column(
          children: List.generate(
            min(infos.length, 3), (index) {
              int newIndex = firstIndex + index;
              double amount = records[newIndex].getAmounts(type, startDate, endDate);
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: RankingIndividualGraph(
                  type: type,
                  price: newIndex + 1,
                  nickname: infos[newIndex].nickname!,
                  amount: amount,
                  maxAmount: maxAmount,
                  isMe: infos[newIndex].uid == myUid,
                ),
              );
            },
          ),
        );
      }
    );
  }
}

class RankingIndividualGraph extends StatelessWidget {
  const RankingIndividualGraph({
    Key? key,
    required this.type,
    required this.price,
    required this.nickname,
    required this.amount,
    required this.maxAmount,
    this.isMe = false,
  }) : super(key: key);

  final ActivityType type;
  final int price;
  final String nickname;
  final double amount;
  final double maxAmount;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            if (price < 4)
            SvgPicture.asset(
              'assets/image/page/home/ranking/$price.svg',
              width: 18.0,
            )
            else Container(
              width: 18.0,
              height: 16.0,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: FTheme.darkGrey,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: FText(
                '$price',
                color: FTheme.white,
                style: textTheme.labelSmall,
              ),
            ),
            const SizedBox(width: 5.0),
            FText(nickname,
              color: FTheme.darkGrey,
              style: textTheme.bodyMedium,
            ),
          ],
        ),
        const SizedBox(height: 5.0),
        Row(
          children: [
            Expanded(
              flex: amount.round(),
              child: Container(
                height: 36.0,
                decoration: BoxDecoration(
                  color: isMe ? type.color : FTheme.lightGrey,
                  borderRadius: const BorderRadius.horizontal(
                    right: Radius.circular(8.0),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: (maxAmount - amount).round(),
              child: Container(),
            ),
          ],
        ),
      ],
    );
  }
}