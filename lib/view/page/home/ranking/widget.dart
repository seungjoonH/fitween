import 'dart:math';

import 'package:fitween/global/number.dart';
import 'package:fitween/global/theme.dart';
import 'package:fitween/global/unit.dart';
import 'package:fitween/model/class/database/user/info.dart';
import 'package:fitween/model/class/database/user/record.dart';
import 'package:fitween/model/enum/activity_type.dart';
import 'package:fitween/presenter/lang/language.dart';
import 'package:fitween/presenter/model/user/info.dart';
import 'package:fitween/presenter/page/home/ranking.dart';
import 'package:fitween/view/widget/widget/card.dart';
import 'package:fitween/view/widget/widget/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class RankingCardView extends StatelessWidget {
  const RankingCardView({
    Key? key,
    required this.type,
  }) : super(key: key);

  final ActivityType type;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 28.0.w,
        vertical: 28.0.h,
      ),
      child: Column(
        children: [
          FCard(
            title: FText(Lang.tr('rnk.cmt'),
              style: textTheme(context).titleSmall,
              bold: true,
            ),
            child: GetBuilder<RankingP>(
              builder: (rankingP) {
                String myUid = Get.find<UserInfoP>().loggedUser.uid!;
                double maxAmount = rankingP.records[type]![0]
                    .getAmounts(type, rankingP.startDate, rankingP.endDate);

                return Column(
                  children: List.generate(
                    rankingP.infos[type]!.length, (index) {
                      FUserInfo info = rankingP.infos[type]![index];
                      FUserRecord record = rankingP.records[type]![index];
                      double amount = record.getAmounts(type, rankingP.startDate, rankingP.endDate);

                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 5.0.h),
                        child: RankingIndividualGraph(
                          type: type,
                          price: index + 1,
                          nickname: info.nickname!,
                          amount: amount,
                          maxAmount: maxAmount,
                          isMe: info.uid == myUid,
                          showText: true,
                        ),
                      );
                    },
                  ),
                );
              }
            ),
          ),
        ],
      ),
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
    this.showText = false,
  }) : super(key: key);

  final ActivityType type;
  final int price;
  final String nickname;
  final double amount;
  final double maxAmount;
  final bool isMe;
  final bool showText;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            if (price < 4)
            SvgPicture.asset(
              'assets/image/page/home/ranking/$price.svg',
              width: 18.0.r,
            ) else Container(
              width: 18.0.w,
              height: 16.0.h,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: FTheme.darkGrey,
                borderRadius: BorderRadius.circular(10.0.r),
              ),
              child: FText(
                '$price',
                color: FTheme.white,
                style: textTheme(context).labelSmall,
              ),
            ),
            const SizedBox(width: 5.0),
            FText(nickname,
              color: FTheme.darkGrey,
              style: textTheme(context).bodyMedium,
            ),
          ],
        ),
        const SizedBox(height: 5.0),
        Stack(
          alignment: Alignment.centerLeft,
          children: [
            LinearPercentIndicator(
              percent: max(amount / max(maxAmount, 1), .02),
              backgroundColor: Colors.transparent,
              fillColor: Colors.transparent,
              progressColor: isMe ? type.color : FTheme.lightGrey,
              lineHeight: 36.0.h,
              padding: EdgeInsets.zero,
              barRadius: Radius.circular(5.0.r),
              animation: true,
              curve: Curves.easeInOut,
              animationDuration: 800,
            ),
            if (showText)
            Padding(
              padding: EdgeInsets.only(left: 8.0.w),
              child: FText(
                typeUnit(amount, type, short: false),
                style: textTheme(context).bodyMedium,
              ),
            ),
          ],
        ),
      ],
    );
  }
}