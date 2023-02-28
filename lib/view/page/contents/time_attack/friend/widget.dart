import 'package:fitween/global/theme.dart';
import 'package:fitween/model/class/database/user/collection.dart';
import 'package:fitween/model/class/database/user/info.dart';
import 'package:fitween/presenter/model/json/badge.dart';
import 'package:fitween/presenter/model/user/collection.dart';
import 'package:fitween/presenter/model/user/friend.dart';
import 'package:fitween/presenter/model/user/info.dart';
import 'package:fitween/presenter/page/contents/time_attack/ready.dart';
import 'package:fitween/view/widget/button/button.dart';
import 'package:fitween/view/widget/widget/badge.dart';
import 'package:fitween/view/widget/widget/card.dart';
import 'package:fitween/view/widget/widget/text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TimeAttackFriendView extends StatelessWidget {
  const TimeAttackFriendView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userInfoP = Get.find<UserInfoP>();
    final userFriendP = Get.find<UserFriendP>();
    final userCollectionP = Get.find<UserCollectionP>();
    List<FUserInfo> infos = userFriendP.loggedUser.rivalInfos;
    List<FUserCollection> collections = userFriendP.loggedUser.rivalCollections;

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              FText(
                maxLines: 2,
                '라이벌과 제한 시간 내에\n누가 더 스쿼트를 많이 하는지 대결해요!',
                color: FTheme.darkGrey,
                style: FTheme.textTheme.titleMedium,
              ),
              const SizedBox(height: 50.0),
              FCard(
                backgroundColor: FTheme.colorD,
                child: Row(
                  children: [
                    FBadgeWidget(
                      badge: BadgeJsonP.getBadge(userCollectionP.loggedUser.badgeId),
                    ),
                    const SizedBox(width: 20.0),
                    FText(userInfoP.loggedUser.nickname!),
                  ],
                ),
              ),
              const SizedBox(height: 20.0),
              ListView.separated(
                shrinkWrap: true,
                itemCount: infos.length,
                itemBuilder: (context, index) => FCard(
                  child: Row(
                    children: [
                      FBadgeWidget(badge: BadgeJsonP.getBadge(collections[index].badgeId)),
                      const SizedBox(width: 20.0),
                      FText(infos[index].nickname!),
                    ],
                  ),
                ),
                separatorBuilder: (context, index) => const SizedBox(height: 20.0),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 60.0),
            child: FButton(
              text: '선택완료',
              stretch: true,
              onPressed: TimeAttackReadyP.toTimeAttackReady,
            ),
          ),
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
        margin: const EdgeInsets.only(top: 7),
        child: Row(
          children: [
            /*BadgeWidget(
              badge: BadgeJsonP.getBadge(controller.loggedUser.badgeId),
              size: 80.0.r,
            ),*/
            const SizedBox(
              width: 18,
            ),
            Image.asset('assets/image/badge/1000000.png', height: 48, width: 48),
            const SizedBox(width: 12.0, height: 90.0),
            FText(
              name,
              style: textTheme.labelLarge,
              color: FTheme.darkGrey,
            ),
          ],
        ),
      ),
    );
  }
}

