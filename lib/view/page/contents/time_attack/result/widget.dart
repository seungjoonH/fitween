import 'package:fitween/global/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../model/class/database/user/collection.dart';
import '../../../../../model/class/database/user/info.dart';
import '../../../../../presenter/model/json/badge.dart';
import '../../../../../presenter/model/user/collection.dart';
import '../../../../../presenter/model/user/friend.dart';
import '../../../../../presenter/model/user/info.dart';
import '../../../../widget/button/button.dart';
import '../../../../widget/widget/badge.dart';
import '../../../../widget/widget/card.dart';
import '../../../../widget/widget/text.dart';
import 'package:get/get.dart';

class TimeAttackResultView extends StatelessWidget {
  const TimeAttackResultView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: const [
          FinishCard(),
          BattleResultCard(),
          MyAchievementCard(),
        ],
      ),
    );
  }
}

class FinishCard extends StatelessWidget {
  const FinishCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 10.0),
      child: FCard(
          child: Column(
        children: [
          Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Center(
                  child: Image.asset(
                      'assets/image/page/contents/time_attack/resultBig.png')),
              Positioned(
                bottom: 35.0.h,
                child: FText(
                  '42회',
                  color: FTheme.white,
                  style: FTheme.textTheme.displayMedium,
                ),
              )
            ],
          ),
          const SizedBox(
            height: 50,
          ),
          FButton(
            stretch: true,
            text: '타임어택 완료!',
            backgroundColor: FTheme.colorA,
          )
        ],
      )),
    );
  }
}

class BattleResultCard extends StatelessWidget {
  const BattleResultCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userInfoP = Get.find<UserInfoP>();
    final userFriendP = Get.find<UserFriendP>();
    final userCollectionP = Get.find<UserCollectionP>();
    List<FUserInfo> infos = userFriendP.loggedUser.rivalInfos;
    List<FUserCollection> collections = userFriendP.loggedUser.rivalCollections;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 10.0),
      child: FCard(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FText(
            '대결 결과',
            style: FTheme.textTheme.titleLarge,
            bold: true,
            color: FTheme.darkGrey,
          ),
          const SizedBox(
            height: 10,
          ),
          FText(
            '하쿠나 님이 승리하셨어요!',
            style: FTheme.textTheme.bodyLarge,
            color: FTheme.grey,
          ),
          const SizedBox(
            height: 20,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child:Row(
                  children: [
                    Column(
                      children: [
                        FBadgeWidget(
                          badge: BadgeJsonP.getBadge(userCollectionP.loggedUser.badgeId),
                        ),
                        const SizedBox(width: 20.0),
                        FText(userInfoP.loggedUser.nickname!),
                        FText(
                            '42회'
                        ),
                      ],
                    ),
                    SvgPicture.asset(
                        'assets/image/icon/unselected/swords.svg'
                    ),
                    //지정한 한명의 Rival Badge가져오는법, 타임어택을 할때 고른 유저를 저장하는 변수가 필요한가?
                    // Column(
                    //   children: [
                    //     FBadgeWidget(
                    //       badge: BadgeJsonP.getBadge(userCollectionP.loggedUser.rivalInfos),
                    //     ),
                    //     const SizedBox(width: 20.0),
                    //     FText(userInfoP.loggedUser.nickname!),
                    //   ],
                    // )
                  ],
                ),
              ),
              const Divider(
                thickness: 1,
                color: FTheme.grey,
              ),
              const SizedBox(
                height: 15,
              ),
              FText(
                '상대 전적',
                style: FTheme.textTheme.bodyLarge,
              ),
              const SizedBox(
                height: 15,
              ),
              FButton(
                backgroundColor: FTheme.colorD,
                text: '1승 : 5패',
                stretch: true,
              )
            ],
          ),
        ],
      )),
    );
  }
}

class MyAchievementCard extends StatelessWidget {
  const MyAchievementCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 10.0),
      child: FCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FText(
              '나의 기록',
              style: FTheme.textTheme.headlineMedium,
              bold: true,
              color: FTheme.darkGrey,
            ),
            const SizedBox(
              height: 10,
            ),
            FText(
              '무게 기록 상승!',
              style: FTheme.textTheme.bodyLarge,
              color: FTheme.grey,
            ),
            const SizedBox(
              height: 15,
            ),
            Center(
              child: FText(
                '+42회',
                color: FTheme.colorD,
                style: FTheme.textTheme.displayMedium,
                bold: true,
              ),
            )
          ],
        )),
    );
  }
}
