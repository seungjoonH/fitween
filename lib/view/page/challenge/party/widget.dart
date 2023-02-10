import 'dart:math';

import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:fitween/global/theme.dart';
import 'package:fitween/model/class/database/party.dart';
import 'package:fitween/model/class/database/user.dart';
import 'package:fitween/model/enum/activity_type.dart';
import 'package:fitween/presenter/global.dart';
import 'package:fitween/presenter/model/user.dart';
import 'package:fitween/presenter/page/challenge/party/complete.dart';
import 'package:fitween/presenter/page/challenge/party/main.dart';
import 'package:fitween/presenter/widget/loading.dart';
import 'package:fitween/view/widget/button/button.dart';
import 'package:fitween/view/widget/effect/effect.dart';
import 'package:fitween/view/widget/widget/badge.dart';
import 'package:fitween/view/widget/widget/text.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class PartyMainView extends StatelessWidget {
  const PartyMainView({
    Key? key,
    required this.party,
  }) : super(key: key);

  final Party? party;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChallengePartyMain>(
      builder: (challengePartyMain) {
        return GetBuilder<LoadingPresenter>(
          builder: (loadingP) {
            return SmartRefresher(
              controller: ChallengePartyMain.refreshCont,
              onRefresh: () async {
                if (party != null) await challengePartyMain.init(party!.id!);
                ChallengePartyMain.refreshCont.refreshCompleted();
              },
              onLoading: () async {
                await Future.delayed(const Duration(milliseconds: 100));
                ChallengePartyMain.refreshCont.loadComplete();
              },
              header: const MaterialClassicHeader(
                color: PTheme.black,
                backgroundColor: PTheme.surface,
              ),
              child: (!loadingP.loading) && party != null
                  ? SingleChildScrollView(
                child: Column(
                  children: [
                    ChallengeInfoWidget(party: party!),
                    const Divider(
                      color: PTheme.lightGrey,
                      thickness: 8,
                    ),
                    MyScoreWidget(party: party!),
                    const Divider(
                      color: PTheme.lightGrey,
                      thickness: 8,
                    ),
                    RankWidget(party: party!),
                    const Divider(
                      color: PTheme.lightGrey,
                      thickness: 8,
                    ),
                    ChallengeBadgeWidget(party: party!),
                    const SizedBox(height: 100.0),
                  ],
                ),
              ) : ChallengePartyMainLoading(color: loadingP.color, party: party),
            );
          },
        );
      },
    );
  }
}

class ChallengeInfoWidget extends StatelessWidget {
  const ChallengeInfoWidget({
    Key? key,
    required this.party,
  }) : super(key: key);

  final Party party;

  @override
  Widget build(BuildContext context) {
    BorderRadius imageRadius = BorderRadius.circular(20.0.r);
    List<Color> orderedColors = [PTheme.grey, ...PTheme.orderedColors];
    int index = min(max((party.remainDays ~/ 4) + 1, 0), 4);

    return Padding(
      padding: EdgeInsets.all(20.0.r),
      child: Column(
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: imageRadius,
                child: Image.asset(
                  party.challenge?.imageUrls['default'],
                  fit: BoxFit.fitHeight,
                  height: 230.0.h,
                ),
              ),
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: imageRadius,
                    gradient: LinearGradient(
                      colors: [
                        PTheme.black.withOpacity(.1),
                        PTheme.black.withOpacity(.3),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 10.0.h, right: 10.0.w,
                child: GetBuilder<ChallengePartyMain>(
                  builder: (controller) {
                    return Material(
                      color: PTheme.white.withOpacity(.5),
                      borderRadius: BorderRadius.circular(10.0.r),
                      child: InkWell(
                        onTap: () => controller.copyPartyId(party.id!),
                        borderRadius: BorderRadius.circular(10.0.r),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6.0, vertical: 3.0,
                          ),
                          width: 140.0.w,
                          height: 40.0.h,
                          child: controller.copied ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              PText('복사완료',
                                style: textTheme.titleLarge,
                                color: PTheme.black,
                              ),
                              const SizedBox(width: 5.0),
                              const Icon(Icons.check,
                                color: PTheme.black,
                              ),
                            ],
                          ) : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              PText(party.id!,
                                style: textTheme.titleLarge,
                                color: PTheme.colorB,
                              ),
                              const SizedBox(width: 5.0),
                              const Icon(Icons.copy,
                                color: PTheme.colorB,
                                size: 20.0,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                ),
              ),
            ],
          ),
          SizedBox(height: 20.0.h),
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                alignment: Alignment.center,
                height: 40.0.h,
                child: PText('난이도: ${party.difficulty.kr}',
                  style: textTheme.labelLarge,
                  color: PTheme.grey,
                ),
              ),
              Positioned(
                right: 60.0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 3.0, horizontal: 10.0,
                  ),
                  decoration: BoxDecoration(
                    color: orderedColors[index].withOpacity(.6),
                    borderRadius: BorderRadius.circular(6.0.r),
                  ),
                  child: PText(party.dDay),
                ),
              )
            ],
          ),
          SizedBox(height: 10.0.h),
          Container(
            alignment: Alignment.center,
            height: 40.0.h,
            child: PText(party.challenge?.titleOneLine ?? '',
              style: textTheme.headlineMedium,
              maxLines: 2,
            ),
          ),
          SizedBox(height: 10.0.h),
          SizedBox(
            height: 20.0.h,
            child: PText(party.periodString,
              color: PTheme.colorD,
            ),
          ),
          SizedBox(height: 10.0.h),
          Container(
            alignment: Alignment.center,
            height: 120.0.h,
            child: PText(party.challenge?.descriptions['detail']!.replaceAll(
                '##', party.level['word'],
              ),
              style: textTheme.labelLarge,
              color: PTheme.grey,
              align: TextAlign.center,
              maxLines: 7,
            ),
          ),
        ],
      ),
    );
  }
}

class MyScoreWidget extends StatelessWidget {
  const MyScoreWidget({
    Key? key,
    required this.party,
  }) : super(key: key);

  final Party party;

  @override
  Widget build(BuildContext context) {
    ActivityType type = party.challenge!.type!;

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          SizedBox(
            height: 40.0.h,
            child: Row(
              children: [
                PText('내 활동',
                  style: textTheme.headlineSmall,
                  color: PTheme.black,
                ),
                const SizedBox(width: 10.0),
                PText('*현재 챌린지 기준',
                  style: textTheme.bodySmall,
                  color: PTheme.grey,
                ),
              ],
            ),
          ),
          SizedBox(height: 30.0.h),
          SizedBox(
            height: 70.0.h,
            child: GetBuilder<ChallengePartyMain>(
              builder: (controller) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedFlipCounter(
                      value: controller.value.toInt(),
                      textStyle: textTheme.displayLarge?.apply(
                        color: type.color,
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    PText(type.unitAlt,
                      style: textTheme.bodySmall,
                      color: PTheme.grey,
                    ),
                  ],
                );
              }
            ),
          ),
          SizedBox(height: 20.0.h),
          SizedBox(
            height: 40.0.h,
            child: PTexts(['모두가 합심하여 ',
              '${party.recordSum.round()}${type.unitAlt}',
              '을 ${type.did}'
            ], colors: [PTheme.grey, type.color, PTheme.grey],
              space: false,
              style: textTheme.headlineSmall,
            ),
          ),
        ],
      ),
    );
  }
}

class RankWidget extends StatelessWidget {
  const RankWidget({
    Key? key,
    required this.party,
  }) : super(key: key);

  final Party party;

  @override
  Widget build(BuildContext context) {
    const String trophyAsset = 'assets/image/page/challenge/';

    PUser loggedUser = Get.find<UserPresenter>().loggedUser;
    int myRank = party.getRank(loggedUser.uid!);
    double goal = party.challenge!.levels[party.difficulty.name]['goal'].toDouble();
    double totalRecords = party.records.values.reduce((a, b) => a + b).toDouble();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Column(
                children: [
                  SizedBox(
                    height: 40.0.h,
                    child: Row(
                      children: [
                        PText('순위',
                          style: textTheme.headlineSmall,
                          color: PTheme.black,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.0.h),
                  SizedBox(
                    height: 150.0.h,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        EternalRotation(
                          rps: .3,
                          child: Image.asset(
                            GlobalPresenter.effectAsset,
                            width: 120.0.r,
                            height: 120.0.r,
                          ),
                        ),
                        if (myRank > 0)
                        Image.asset(
                          '${trophyAsset}trophy${myRank > 3 ? '' : '_$myRank'}.png',
                          width: 50.0.r, height: 50.0.r,
                        ),
                        Positioned(
                          top: 45.0.r,
                          child: Container(
                            alignment: Alignment.center,
                            width: 40.0.r,
                            height: 40.0.r,
                            child: PText(
                              '$myRank',
                              style: textTheme.headlineSmall,
                              color: myRank > 3
                                  ? PTheme.white : PTheme.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.0.h),
              SizedBox(
                height: 50.0.h,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PText('현재 1위: ${party.winner.nickname} 님',
                      style: textTheme.titleMedium,
                      color: PTheme.black,
                    ),
                    PText('나의 순위: ${party.getRank(loggedUser.uid!)}위',
                      style: textTheme.titleMedium,
                      color: PTheme.black,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.0.h),
              Container(
                height: 50.0.h,
                decoration: BoxDecoration(
                  border: Border.all(color: PTheme.black, width: .75),
                ),
                child: Row(
                  children: party.members.map((user) {
                    double record = party.records[user.uid].toDouble();
                    double percent = 100 * record / goal;
                    return Expanded(
                      flex: max(party.records[user.uid!], 1),
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: user.uid! == loggedUser.uid!
                              ? party.challenge!.type!.color
                              : PTheme.black.withOpacity(.3),
                          border: Border.all(color: PTheme.black, width: .75),
                        ),
                        child: PText('${percent.round()} %'),
                      ),
                    );
                  }).toList()..add(
                    Expanded(
                      flex: max((goal - totalRecords).round(), 1),
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: PTheme.background,
                          border: Border.all(color: PTheme.black, width: .75),
                        ),
                        child: PText(
                          '${(goal - totalRecords).round()
                          }${party.challenge!.type!.unit
                          }',
                          color: PTheme.colorB,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const Divider(
          color: PTheme.grey,
          thickness: 1,
          height: 1.0,
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: party.records.length,
          itemBuilder: (context, index) {
            PUser loggedUser = Get.find<UserPresenter>().loggedUser;
            PUser user = party.getMemberByRank(index + 1);

            return Container(
              height: 80.0.h,
              color: user.uid == loggedUser.uid ? PTheme.bar : null,
              padding: const EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(width: 10.0.w, child: PText('${index + 1}')),
                  SizedBox(
                    width: 50.0.w,
                    height: 50.0.h,
                    child: BadgeWidget(
                      badge: user.collection?.badge, size: 40.0,
                    ),
                  ),
                  SizedBox(
                    width: 130.0.w,
                    child: PText(user.nickname!),
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    width: 70.0.w,
                    child: PText(
                      '${party.records[user.uid!]}${party.challenge!.type!.unit}',
                    ),
                  ),
                ],
              ),
            );
          },
          separatorBuilder: (context, index) => const Divider(
            color: PTheme.grey,
            thickness: 1,
            height: 1.0,
          ),
        ),
        const Divider(
          color: PTheme.grey,
          thickness: 1,
          height: 1.0,
        ),
        SizedBox(height: 40.0.h),
      ],
    );
  }
}

class ChallengeBadgeWidget extends StatelessWidget {
  const ChallengeBadgeWidget({
    Key? key,
    required this.party,
  }) : super(key: key);

  final Party party;

  @override
  Widget build(BuildContext context) {
    PUser user = Get.find<UserPresenter>().loggedUser;

    return GetBuilder<ChallengePartyMain>(
      builder: (controller) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Column(
                    children: [
                      SizedBox(
                        height: 40.0.h,
                        child: Row(
                          children: [
                            PText('보상',
                              style: textTheme.headlineSmall,
                              color: PTheme.black,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.0.h),
                      SizedBox(
                        height: 150.0.h,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            if (!party.complete)
                            EternalRotation(
                              rps: .3,
                              child: Image.asset(
                                GlobalPresenter.effect2Asset,
                              ),
                            ),
                            BadgeWidget(
                              badge: party.badge,
                              greyscale: party.complete,
                            ),
                            if (party.complete)
                            RotationTransition(
                              turns: const AlwaysStoppedAnimation(-.075),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 7.0),
                                decoration: BoxDecoration(
                                  border: Border.all(color: PTheme.colorB, width: 2.0),
                                ),
                                child: PText(' 완 료 ',
                                  style: textTheme.displayMedium,
                                  color: PTheme.colorB,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.0.h),
                      if (party.satisfy &&
                          party.leaderUid == user.uid)
                      PButton(
                        text: '완료하기',
                        stretch: true,
                        onPressed: () =>
                            ChallengePartyComplete.toChallengePartyComplete(party),
                      ) else PButton(
                        text: '완료하기',
                        stretch: true,
                        backgroundColor: PTheme.lightGrey,
                        textColor: PTheme.grey,
                        border: false,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      }
    );
  }
}


class ChallengePartyMainLoading extends StatelessWidget {
  const ChallengePartyMainLoading({
    Key? key,
    this.color = PTheme.black,
    this.party,
  }) : super(key: key);

  final Color color;
  final Party? party;

  @override
  Widget build(BuildContext context) {
    BoxDecoration decoration = BoxDecoration(
      color: color, borderRadius: BorderRadius.circular(15.0),
    );

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.all(20.0.r),
            child: Column(
              children: [
                Container(
                  height: 230.0.h,
                  decoration: BoxDecoration(
                    color: decoration.color,
                    borderRadius: BorderRadius.circular(20.0.r),
                  ),
                ),
                SizedBox(height: 20.0.h),
                Column(
                  children: [
                    SizedBox(height: 10.0.h),
                    Container(width: 240.0.w, height: 20.0.h, decoration: decoration),
                    SizedBox(height: 10.0.h),
                  ],
                ),
                SizedBox(height: 10.0.h),
                Container(height: 40.0.h, decoration: decoration),
                SizedBox(height: 20.0.h),
                Container(height: 140.0.h, decoration: decoration),
              ],
            ),
          ),
          const Divider(color: PTheme.lightGrey, thickness: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    SizedBox(height: 5.0.h),
                    Container(width: 200.0.w, height: 30.0.h, decoration: decoration),
                    SizedBox(height: 5.0.h),
                  ],
                ),
                SizedBox(height: 30.0.h),
                Container(height: 70.0.h, decoration: decoration),
                SizedBox(height: 20.0.h),
                Container(height: 40.0.h, decoration: decoration),
              ],
            ),
          ),
          const Divider(color: PTheme.lightGrey, thickness: 8),
          Container(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    SizedBox(height: 5.0.h),
                    Container(width: 200.0.w, height: 30.0.h, decoration: decoration),
                    SizedBox(height: 5.0.h),
                  ],
                ),
                SizedBox(height: 20.0.h),
                Container(height: 150.0.h, decoration: decoration),
                SizedBox(height: 20.0.h),
                Container(height: 50.0.h, decoration: decoration),
                SizedBox(height: 20.0.h),
                Container(height: 50.0.h, decoration: decoration),
              ],
            ),
          ),
          const Divider(color: PTheme.grey, thickness: 1, height: 1.0),
          Column(
            children: [
              Container(
                height: ((party?.memberUids.length ?? 1.0) * 80.0).h,
                color: color,
              ),
              SizedBox(height: 40.0.h),
            ],
          ),
          const Divider(color: PTheme.lightGrey, thickness: 8),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        SizedBox(height: 5.0.h),
                        Container(width: 200.0.w, height: 30.0.h, decoration: decoration),
                        SizedBox(height: 5.0.h),
                      ],
                    ),
                    SizedBox(height: 20.0.h),
                    Container(height: 150.0.h, decoration: decoration),
                    SizedBox(height: 20.0.h),
                    Container(height: 40.0.h, decoration: decoration),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 100.0),
        ],
      ),
    );
  }
}
