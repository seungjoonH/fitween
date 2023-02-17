import 'package:fitween/presenter/page/challenge/time_attack/time_attack_main.dart';
import 'package:fitween/view/widget/widget/card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../global/theme.dart';
import '../../../../widget/button/button.dart';
import '../../../../widget/widget/text.dart';

class TimeAttackFriendPageView extends StatelessWidget {
  const TimeAttackFriendPageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 28.0, right: 28.0),
            child: FText(
              maxLines: 2,
              '친구와 제한 시간 내에\n누가 더 스쿼트를 많이 하는지 대결해요!',
              color: FTheme.grey,
              style: FTheme.textTheme.titleMedium,
            ),
          ),
          SizedBox(
            height: 50,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 28.0, right: 28.0),
            child: Column(
              children: [
                FriendCard('추성훈'),
                FriendCard('황장군'),
                FriendCard('춘자'),
                FriendCard('뻘컵')
              ],
            )
          ),
          SizedBox(
            height: 110,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 28.0, right: 28.0),
            child: FButton(
              text: '선택완료',
              stretch: true,
              onPressed: TimeAttackMainP.toTimeAttackMain,
            ),
          )
        ],
      ),
    );
  }
}

class FriendCard extends StatelessWidget{
  const FriendCard(this.name,{Key? key}) : super(key: key);

  final String name;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        height: 87,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: FTheme.white
        ),
        margin: EdgeInsets.only(top: 7),
        child: Row(
          children: [
            /*BadgeWidget(
              badge: BadgePresenter.getBadge(controller.loggedUser.badgeId),
              size: 80.0.r,
            ),*/
            SizedBox(
              width: 18,
            ),
            Image.asset('assets/image/badge/1000000.png', height: 48, width: 48),
            const SizedBox(width: 12.0, height: 90.0),
            FText(
              name,
              style: textTheme.labelLarge,
              color: FTheme.grey,
            ),
          ],
        ),
      ),
    );
  }
}

