// /* 챌린지 메인 위젯 */
//
import 'package:fitween/global/theme.dart';
import 'package:fitween/model/class/database/user/party.dart';
import 'package:fitween/presenter/model/user/party.dart';
import 'package:fitween/presenter/model/user/record.dart';
import 'package:fitween/presenter/page/challenge/time_attack/time_attack_main.dart';
import 'package:fitween/presenter/page/friend.dart';
import 'package:fitween/view/widget/button/button.dart';
import 'package:fitween/view/widget/widget/card.dart';
import 'package:fitween/view/widget/widget/tab_scaffold.dart';
import 'package:fitween/view/widget/widget/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../../../model/class/database/user/record.dart';
import '../../../../model/class/json/level.dart';
import '../../../../model/enum/activity_type.dart';
import '../../../../model/enum/unit.dart';
import '../../../../presenter/model/level.dart';
import '../../../../presenter/model/record.dart';
import '../../../../presenter/page/challenge/time_attack/time_attack_friend.dart';

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:fitween/global/date.dart';
import 'package:fitween/global/theme.dart';
import 'package:fitween/model/class/database/party.dart';
import 'package:fitween/model/class/database/user.dart';
import 'package:fitween/model/class/json/challenge.dart';
import 'package:fitween/model/enum/border_type.dart';
import 'package:fitween/model/enum/difficulty.dart';
import 'package:fitween/presenter/widget/loading.dart';
import 'package:fitween/presenter/model/challenge.dart';
import 'package:fitween/presenter/model/user.dart';
import 'package:fitween/presenter/page/challenge/detail.dart';
import 'package:fitween/presenter/page/challenge/main.dart';
import 'package:fitween/presenter/page/challenge/party/main.dart';
import 'package:fitween/view/widget/button/button.dart';
import 'package:fitween/view/widget/widget/badge.dart';
import 'package:fitween/view/widget/widget/text.dart';
import 'package:fitween/view/widget/widget/card.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class FTab extends StatelessWidget {
  const FTab(
    this.text, {
    Key? key,
    this.selected = false,
  }) : super(key: key);

  final String text;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: FText(
        text,
        style: textTheme.titleLarge,
        color: selected ? FTheme.darkGrey : FTheme.lightGrey,
      ),
    );
  }
}

class ChallengeMainPageView extends StatelessWidget {
  const ChallengeMainPageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TabScaffold(
      tabs: const ['월간', '업적', '타임어택'],
      bodies: [
        const ChallengeCardView(),
        const AchievementCardView(),
        FCard(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FText(
              '타임어택!',
              style: FTheme.textTheme.titleLarge,
            ),
            const SizedBox(
              height: 8,
            ),
            Image.asset('assets/image/challenge/timeAttack/timeAttack.png'),
            const SizedBox(
              height: 10,
            ),
            FText(
              '친구와 제한 시간 내에\n누가 더 스쿼트를 많이 하는지 대결해요!',
              maxLines: 2,
            ),
            const SizedBox(
              height: 20,
            ),
            FButton(
              stretch: true,
              text: '타임어택 하러가기',
              onPressed: TimeAttackFriendP.toTimeAttackFriend,
            )
          ],
        ))
      ],
    );
  }
}

class ChallengeMainView extends StatelessWidget {
  const ChallengeMainView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        ChallengeTabBar(),
        ChallengeTabView(),
      ],
    );
  }
}

class ChallengeTabBar extends StatelessWidget {
  const ChallengeTabBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final challengeMain = Get.find<ChallengeMain>();

    return GetBuilder<LoadingP>(builder: (controller) {
      return TabBar(
        controller: challengeMain.tabCont,
        tabs: challengeMain.tabs,
        indicatorColor: FTheme.black,
        indicatorSize: TabBarIndicatorSize.label,
        indicatorWeight: 1.5,
        labelPadding: const EdgeInsets.all(5.0),
        splashFactory: InkRipple.splashFactory,
        onTap: (index) {
          if (controller.loading) challengeMain.tabCont.animateTo(0);
        },
      );
    });
  }
}

class ChallengeTabView extends StatelessWidget {
  const ChallengeTabView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ChallengeMain>();

    return Expanded(
      child: TabBarView(
        controller: controller.tabCont,
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          ChallengeListView(),
          MyPartyListView(),
        ],
      ),
    );
  }
}

class ChallengeListView extends StatelessWidget {
  const ChallengeListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoadingP>(builder: (controller) {
      return Padding(
        padding: EdgeInsets.fromLTRB(20.0.r, 20.0.r, 20.0.r, 0.0),
        child: controller.loading
            ? ChallengeCardViewLoading(color: controller.color)
            : const ChallengeCardView(),
      );
    });
  }
}

class ChallengeCardView extends StatelessWidget {
  const ChallengeCardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final userP = Get.find<UserPartyP>();
    // FUserParty user = userP.loggedUser;

    return GetBuilder<LoadingP>(builder: (controller) {
      return SmartRefresher(
        controller: ChallengeMain.refreshCont,
        onRefresh: () async {
          ChallengeMain.toChallengeMain();
          ChallengeMain.refreshCont.refreshCompleted();
        },
        onLoading: () async {
          await Future.delayed(const Duration(milliseconds: 100));
          ChallengeMain.refreshCont.loadComplete();
        },
        header: const MaterialClassicHeader(
          color: FTheme.black,
          backgroundColor: FTheme.surface,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: FText('참여 중인 챌린지'),
              ),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: ChallengeP.orderedChallenges.length,
                itemBuilder: (_, index) {
                  return ChallengeCard(
                    challenge: ChallengeP.orderedChallenges[index],
                  );
                },
                separatorBuilder: (_, index) => SizedBox(height: 30.0.h),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: FText('새로운 챌린지'),
              ),
              // if (user.parties.isEmpty)
              //   Padding(
              //     padding: EdgeInsets.all(20.0.h),
              //     child: Column(
              //       children: [
              //         ListView.separated(
              //           shrinkWrap: true,
              //           itemCount: user.parties.length,
              //           physics: const NeverScrollableScrollPhysics(),
              //           itemBuilder: (_, index) => MyPartyListTile(
              //             party: user.parties.values.toList()[index],
              //           ),
              //           separatorBuilder: (_, index) => SizedBox(height: 20.0.h),
              //         ),
              //         SizedBox(height: 20.0.h),
              //         GetBuilder<ChallengeMain>(
              //           builder: (controller) {
              //             return Row(
              //               children: [
              //                 PButton(
              //                   text: '챌린지 살펴보기',
              //                   onPressed: () => controller.tabCont.index = 0,
              //                   stretch: true,
              //                   fill: false,
              //                   multiple: true,
              //                 ),
              //                 SizedBox(width: 20.0.w),
              //                 PButton(
              //                   text: '챌린지 참여하기',
              //                   onPressed: controller.challengeJoinButtonPressed,
              //                   stretch: true,
              //                   multiple: true,
              //                 ),
              //               ],
              //             );
              //           },
              //         ),
              //       ],
              //     ),
              //   )
              // else
              //   Container(),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: ChallengeP.orderedChallenges.length,
                itemBuilder: (_, index) {
                  return InkWell(
                    onTap: () => ChallengeDetail.toChallengeDetail(
                        ChallengeP.orderedChallenges[index]),
                    child: ChallengeCard(
                      challenge: ChallengeP.orderedChallenges[index],
                    ),
                  );
                },
                separatorBuilder: (_, index) => SizedBox(height: 30.0.h),
              ),
            ],
          ),
        ),
      );
    });
  }
}

class ChallengeCard extends StatelessWidget {
  const ChallengeCard({
    Key? key,
    required this.challenge,
  }) : super(key: key);

  final Challenge challenge;

  @override
  Widget build(BuildContext context) {
    final userP = Get.find<UserPartyP>();

    return Stack(
      children: [
        PCard(
          color: FTheme.background,
          padding: EdgeInsets.zero,
          child: Row(
            children: [
              // ParallaxWidget(
              //   background: Image.asset(
              //     challenge.imageUrls['default'],
              //     fit: BoxFit.fitHeight,
              //   ),
              //   child: Container(height: 200.0),
              // ),
              if (challenge.locked)
                Container(
                  width: 100.0.w,
                  height: 100.0.h,
                  color: FTheme.lightGrey,
                )
              else
                Image.asset(
                  challenge.imageUrls['default'],
                  width: 100.0.w,
                  height: 100.0.h,
                  fit: BoxFit.cover,
                ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(8.0.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      FText(
                        challenge.title ?? '',
                        style: textTheme.bodyMedium,
                        maxLines: 2,
                      ),
                      SizedBox(height: 4.0.h),
                      FText(
                        challenge.descriptions['sub']!,
                        style: textTheme.bodySmall,
                        color: FTheme.lightGrey,
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
              ),
              // userP.alreadyJoinedChallenge(challenge.id!)
              //     ? PButton(
              //         onPressed: () =>
              //             ChallengePartyMain.toChallengePartyMain(userP
              //                 .getPartyByChallengeId(challenge.id!)!),
              //         text: '챌린지 이동하기',
              //         stretch: true,
              //         height: 50.0,
              //       )
              //     : PButton(
              //         onPressed: () =>
              //             ChallengeDetail.toChallengeDetail(challenge),
              //         text: '알아보러 가기',
              //         stretch: true,
              //         height: 50.0,
              //       ),
            ],
          ),
        ),
        if (challenge.locked)
          Positioned.fill(
            child: Container(
              color: FTheme.black.withOpacity(.5),
              child: const Icon(
                Icons.lock,
                color: FTheme.black,
                size: 70.0,
              ),
            ),
          ),
      ],
    );
  }
}

class ChallengeCardViewLoading extends StatelessWidget {
  const ChallengeCardViewLoading({
    Key? key,
    this.color = FTheme.black,
  }) : super(key: key);

  final Color color;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: 2,
      itemBuilder: (_, index) => ChallengeCardLoading(color: color),
      separatorBuilder: (_, index) => SizedBox(height: 50.0.h),
    );
  }
}

class ChallengeCardLoading extends StatelessWidget {
  const ChallengeCardLoading({
    Key? key,
    this.color = FTheme.black,
  }) : super(key: key);

  final Color color;

  @override
  Widget build(BuildContext context) {
    BoxDecoration decoration = BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(15.0),
    );

    return PCard(
      borderType: BorderType.none,
      color: FTheme.background,
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          Container(
            height: 232.0.h,
            decoration: decoration,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0.0, 20.0.r, 20.0.r, 20.0.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: 200.0.w,
                          height: 80.0.h,
                          decoration: decoration,
                        ),
                        SizedBox(height: 20.0.h),
                        Container(
                          width: 200.0.w,
                          height: 20.0.h,
                          decoration: decoration,
                        ),
                      ],
                    ),
                    BadgeWidget(size: 80.0.r, color: color),
                  ],
                ),
                SizedBox(height: 20.0.h),
                Container(
                  width: 200.0.w,
                  height: 30.0.h,
                  decoration: decoration,
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            height: 50.0.h,
            decoration: decoration,
          ),
        ],
      ),
    );
  }
}

class MyPartyListView extends StatelessWidget {
  const MyPartyListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userP = Get.find<UserPartyP>();
    FUserParty user = userP.loggedUser;

    return Stack(
      children: [
        if (user.parties.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: PCard(
                color: FTheme.surface,
                padding: EdgeInsets.zero,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 30.0.w,
                        vertical: 150.0.h,
                      ),
                      child: FText(
                        '챌린지가 없습니다',
                        style: textTheme.displaySmall,
                      ),
                    ),
                    const Divider(
                      color: FTheme.black,
                      thickness: 1.5,
                      height: 0.0,
                    ),
                    GetBuilder<ChallengeMain>(
                      builder: (controller) {
                        return Row(
                          children: [
                            PButton(
                              text: '챌린지 살펴보기',
                              onPressed: () => controller.tabCont.index = 0,
                              stretch: true,
                              fill: false,
                              multiple: true,
                              border: false,
                            ),
                            PButton(
                              text: '챌린지 참여하기',
                              onPressed: controller.challengeJoinButtonPressed,
                              stretch: true,
                              multiple: true,
                              border: false,
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          )
        else
          Padding(
            padding: EdgeInsets.all(20.0.h),
            child: Column(
              children: [
                ListView.separated(
                  shrinkWrap: true,
                  itemCount: user.parties.length,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (_, index) => MyPartyListTile(
                    party: user.parties.values.toList()[index],
                  ),
                  separatorBuilder: (_, index) => SizedBox(height: 20.0.h),
                ),
                SizedBox(height: 20.0.h),
                GetBuilder<ChallengeMain>(
                  builder: (controller) {
                    return Row(
                      children: [
                        PButton(
                          text: '챌린지 살펴보기',
                          onPressed: () => controller.tabCont.index = 0,
                          stretch: true,
                          fill: false,
                          multiple: true,
                        ),
                        SizedBox(width: 20.0.w),
                        PButton(
                          text: '챌린지 참여하기',
                          onPressed: controller.challengeJoinButtonPressed,
                          stretch: true,
                          multiple: true,
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class MyPartyListTile extends StatelessWidget {
  const MyPartyListTile({
    Key? key,
    required this.party,
  }) : super(key: key);

  final Party party;

  @override
  Widget build(BuildContext context) {
    List<Color> orderedColors = [FTheme.darkGrey, ...FTheme.orderedColors];
    int index = min(max((party.remainDays ~/ 4) + 1, 0), 4);

    return Stack(
      alignment: Alignment.center,
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => ChallengePartyMain.toChallengePartyMain(party),
            child: Container(
              height: 80.0.h,
              decoration: BoxDecoration(
                border: Border.all(color: FTheme.black, width: 1.5),
              ),
              child: Row(
                children: [
                  AspectRatio(
                    aspectRatio: 1.0,
                    child: Image.asset(
                      party.challenge!.imageUrls['focus'],
                      width: 100.0.w,
                      height: 100.0.h,
                      fit: BoxFit.fill,
                    ),
                  ),
                  const VerticalDivider(
                    width: 1.5,
                    thickness: 1.5,
                    color: FTheme.black,
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(10.0.r),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              FText(
                                party.challenge!.title!.replaceAll('\n', ' '),
                                style: textTheme.bodyLarge,
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 3.0,
                                  horizontal: 10.0,
                                ),
                                decoration: BoxDecoration(
                                  color: orderedColors[index].withOpacity(.6),
                                  borderRadius: BorderRadius.circular(6.0.r),
                                ),
                                child: FText(party.dDay),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    const Icon(Icons.people_alt, size: 14.0),
                                    const SizedBox(width: 10.0),
                                    FText(
                                        '${party.memberInfos.length}/${party.level['maxMember']}'),
                                  ],
                                ),
                              ),
                              Expanded(
                                  child: FText('난이도 : ${party.difficulty.kr}')),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 50.0.w,
                    child: const Icon(Icons.arrow_forward_ios),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (party.over)
          Positioned.fill(
            child: Container(
              alignment: Alignment.center,
              color: FTheme.black.withOpacity(.2),
            ),
          ),
        if (party.complete)
          RotationTransition(
            turns: const AlwaysStoppedAnimation(-.075),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 7.0),
              decoration: BoxDecoration(
                border: Border.all(
                  color: party.complete ? FTheme.colorB : FTheme.black,
                  width: 2.0,
                ),
              ),
              child: FText(
                party.complete ? ' 완 료 ' : ' 실 패 ',
                color: party.complete ? FTheme.colorB : FTheme.black,
                style: textTheme.headlineLarge,
              ),
            ),
          )
      ],
    );
  }
}

class AchievementCardView extends StatelessWidget {
  const AchievementCardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FUserRecord loggedUser = Get.find<UserRecordP>().loggedUser;

    return SingleChildScrollView(
      child: Column(
        children: ActivityType.values.sublist(1, 3).map((type) {
          double amount = loggedUser.getAmounts(type);
          Record record = Record.init(type, amount, ExerciseUnit.step);

          Map<String, dynamic> tier = LevelPresenter.getTier(type, record);
          Level next = tier['next'] ?? Level.fromJson({'amount': 0});

          Record nextValue = Record.init(
            type,
            next.amount!.toDouble(),
            ExerciseUnit.kilometer,
          );

          nextValue.convert(ExerciseUnit.step);

          return Card(
            child: Column(
              children: [
                InkWell(
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FText(
                          '하쿠나님은 지금까지',
                          style: textTheme.bodyMedium,
                        ),
                        Container(
                          padding: const EdgeInsets.all(4.0),
                          decoration: BoxDecoration(
                            color: type.color,
                            borderRadius: BorderRadius.circular(10.0.r),
                          ),
                          child: FText(
                            tier['current']?.title ?? '',
                            maxLines: 2,
                            style: textTheme.displayMedium,
                            color: FTheme.white,
                            bold: true,
                          ),
                        ),
                        FText(
                          '만큼 걸었어요!',
                          style: textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 8.0),
                        SizedBox(
                          width: 300,
                          height: 280,
                          child: Stack(
                            children: [
                              Image.asset(
                                'assets/image/page/achievement/Union.png',
                                height: 280,
                                width: 300,
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: SizedBox(
                                        width: 100.0.w,
                                        child: tier['current'] != null
                                            ? Image.asset(
                                                'assets/image/level/${type.name}/${tier['current'].id}.png',
                                                width: 40.0.w,
                                              )
                                            : Container(),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12.0,
                                      ),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: FText(
                                          '현재 진행도',
                                          style: textTheme.bodyMedium,
                                          color: FTheme.black,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 8.0,
                                        horizontal: 12.0,
                                      ),
                                      child: LinearPercentIndicator(
                                        padding: EdgeInsets.zero,
                                        progressColor: type.color,
                                        backgroundColor: FTheme
                                            .lightGrey, // Colors.transparent,
                                        percent: tier['percent'] ?? .0,
                                        lineHeight: 48.0,
                                        barRadius: Radius.circular(10.0.r),
                                        animation: true,
                                        animationDuration: 1000,
                                        curve: Curves.easeInOut,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12.0,
                                      ),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: FText(
                                          '${tier['percent'].toInt()}%',
                                          style: textTheme.bodyMedium,
                                          color: type.color,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          // child: SizedBox(
                          //   width: 70.0.w,
                          //   child: tier['current'] != null
                          //       ? Image.asset(
                          //           'assets/image/level/${type.name}/${tier['current'].id}.png',
                          //           width: 40.0.w,
                          //         )
                          //       : Container(),
                          // ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (!type.active)
                  Positioned.fill(
                    child: Stack(
                      children: [
                        Container(
                          color: FTheme.surface,
                          alignment: Alignment.center,
                          child: Icon(Icons.lock, size: 30.0.r),
                        ),
                        Container(
                          color: FTheme.black.withOpacity(.3),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
  //   return GetBuilder<LoadingP>(builder: (controller) {
  //     return ListView.separated(
  //       itemCount: 3,
  //       itemBuilder: (_, index) {
  //         return AchievementCard();
  //       },
  //       separatorBuilder: (_, index) => SizedBox(height: 20.0.h),
  //     );
  //   });
  // }
}

class AchievementCard extends StatelessWidget {
  final Challenge challenge;

  const AchievementCard({Key? key, required this.challenge}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userP = Get.find<UserPartyP>();

    return Column(
      children: [
        Stack(
          children: [
            PCard(
              color: FTheme.background,
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  if (challenge.locked)
                    Container(height: 230.0.h, color: FTheme.lightGrey)
                  else
                    Image.asset(
                      challenge.imageUrls['default'],
                      // height: 230.0.h,
                      fit: BoxFit.fitWidth,
                    ),
                  Divider(height: 1.0.h, color: FTheme.black, thickness: 1.5),
                  Padding(
                    padding: EdgeInsets.all(20.0.r),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 80.0.h,
                                  child: FText(
                                    challenge.title ?? '',
                                    style: textTheme.headlineMedium,
                                    maxLines: 2,
                                  ),
                                ),
                                SizedBox(height: 20.0.h),
                                SizedBox(
                                  height: 20.0.h,
                                  child: FText(
                                    '${today.month}월의 챌린지',
                                    style: textTheme.labelLarge,
                                    color: FTheme.grey,
                                  ),
                                ),
                              ],
                            ),
                            BadgeWidget(
                              size: 80.0.r,
                              badge: challenge.locked
                                  ? null
                                  : challenge.badges[Difficulty.hard],
                            ),
                          ],
                        ),
                        SizedBox(height: 20.0.h),
                        SizedBox(
                          height: 30.0.h,
                          child: FText(
                            challenge.descriptions['sub']!,
                            style: textTheme.titleSmall,
                            color: FTheme.black,
                            maxLines: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  userP.alreadyJoinedChallenge(challenge.id!)
                      ? PButton(
                          onPressed: () =>
                              ChallengePartyMain.toChallengePartyMain(
                                  userP.getPartyByChallengeId(challenge.id!)!),
                          text: '챌린지 이동하기',
                          stretch: true,
                          height: 50.0,
                        )
                      : PButton(
                          onPressed: () =>
                              ChallengeDetail.toChallengeDetail(challenge),
                          text: '알아보러 가기',
                          stretch: true,
                          height: 50.0,
                        ),
                ],
              ),
            ),
            if (challenge.locked)
              Positioned.fill(
                child: Container(
                  color: FTheme.black.withOpacity(.5),
                  child: const Icon(
                    Icons.lock,
                    color: FTheme.black,
                    size: 70.0,
                  ),
                ),
              ),
          ],
        ),
        SizedBox(height: 20.0.h),
      ],
    );
  }
}
