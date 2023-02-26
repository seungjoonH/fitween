import 'package:fitween/global/theme.dart';
import 'package:fitween/model/class/database/user/info.dart';
import 'package:fitween/model/class/database/user/record.dart';
import 'package:fitween/model/enum/activity_type.dart';
import 'package:fitween/presenter/model/user/info.dart';
import 'package:fitween/presenter/page/ranking.dart';
import 'package:fitween/view/widget/widget/card.dart';
import 'package:fitween/view/widget/widget/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class RankingCardView extends StatelessWidget {
  const RankingCardView({
    Key? key,
    required this.type,
  }) : super(key: key);

  final ActivityType type;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(28.0),
      child: FCard(
        title: '친구들의 순위를 확인해보세요!',
        child: GetBuilder<RankingP>(
          builder: (rankingP) {
            String myUid = Get.find<UserInfoP>().loggedUser.uid!;
            double maxAmount = rankingP.records[type]![0]
                .getAmounts(type, rankingP.startDate, rankingP.endDate);

            return Column(
              children: List.generate(
                rankingP.infos.length, (index) {
                  FUserInfo info = rankingP.infos[type]![index];
                  FUserRecord record = rankingP.records[type]![index];
                  double amount = record.getAmounts(type, rankingP.startDate, rankingP.endDate);

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: RankingIndividualGraph(
                      type: type,
                      price: index + 1,
                      nickname: info.nickname!,
                      amount: amount,
                      maxAmount: maxAmount,
                      isMe: info.uid == myUid,
                    ),
                  );
                },
              ),
            );
          }
        ),
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
  }) : super(key: key);

  final ActivityType type;
  final int price;
  final String nickname;
  final double amount;
  final double maxAmount;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    int leftFlex = amount.round();
    int rightFlex = (maxAmount - amount).round();

    if (amount == 0) {
      leftFlex = 1;
      rightFlex = 49;
    }

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
              flex: leftFlex,
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
              flex: rightFlex,
              child: Container(),
            ),
          ],
        ),
      ],
    );
  }
}