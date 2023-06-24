import 'dart:math';

import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:fitween/global/number.dart';
import 'package:fitween/model/class/database/user/collection.dart';
import 'package:fitween/model/class/database/user/info.dart';
import 'package:fitween/model/class/database/user/party.dart';
import 'package:fitween/model/class/database/user/record.dart';
import 'package:fitween/presenter/global.dart';
import 'package:fitween/presenter/model/json/badge.dart';
import 'package:fitween/presenter/model/user/party.dart';
import 'package:fitween/presenter/model/user/info.dart';
import 'package:fitween/presenter/page/contents/challenge/party.dart';
import 'package:fitween/presenter/widget/loading.dart';
import 'package:fitween/view/widget/button/button.dart';
import 'package:fitween/view/widget/effect/effect.dart';
import 'package:fitween/view/widget/widget/badge.dart';
import 'package:fitween/view/widget/widget/card.dart';
import 'package:fitween/view/widget/widget/tag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:fitween/global/theme.dart';
import 'package:fitween/model/class/database/party.dart';
import 'package:fitween/model/enum/activity_type.dart';
import 'package:fitween/view/widget/widget/text.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class PartyView extends StatelessWidget {
  const PartyView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PartyP>(
      builder: (partyP) {
        final refreshCont = RefreshController();
        final orientation = MediaQuery.of(context).orientation;

        bool isPortrait = orientation == Orientation.portrait;

        return SmartRefresher(
          controller: refreshCont,
          onRefresh: () async {
            await PartyP.init(partyP.loadedParty!.id!);
            refreshCont.refreshCompleted();
          },
          onLoading: () async {
            await Future.delayed(const Duration(milliseconds: 100));
            refreshCont.loadComplete();
          },
          header: const MaterialClassicHeader(
            color: FTheme.black,
            backgroundColor: FTheme.surface,
            offset: 40.0,
          ),
          child: SingleChildScrollView(
            child: isPortrait ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ChallengeInfoCard(party: partyP.loadedParty),
                SizedBox(height: 20.0.h),
                ChallengeScoreCard(party: partyP.loadedParty),
              ],
            ) : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(child: ChallengeInfoCard(party: partyP.loadedParty)),
                SizedBox(width: 20.0.w),
                Expanded(child: ChallengeScoreCard(party: partyP.loadedParty)),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ChallengeInfoCard extends StatelessWidget {
  const ChallengeInfoCard({
    Key? key,
    this.party,
  }) : super(key: key);

  final Party? party;

  @override
  Widget build(BuildContext context) {
    const imageRadius = BorderRadius.vertical(top: Radius.circular(12.0));
    final size = MediaQuery.of(context).size;

    if (party == null) Container();

    return GetBuilder<LoadingP>(
      builder: (loadingP) {
        return FCard(
          height: max(size.height * .6, 500.0.h),
          padding: EdgeInsets.zero,
          child: loadingP.loading ? Container() : Expanded(
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: imageRadius,
                  child: Image.asset(
                    party?.challenge?.imageUrls['default'],
                    fit: BoxFit.fitWidth,
                    width: double.infinity,
                    height: 300.0.h,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20.0.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          FText(
                            '최대인원 | ${party!.level['maxMember']}명',
                            style: textTheme(context).bodyMedium,
                            color: FTheme.lightGrey,
                          ),
                          SizedBox(width: 40.0.w),
                          FText(
                            '마감기한 | D${withSign(party!.overDays)}',
                            style: textTheme(context).bodyMedium,
                            color: FTheme.lightGrey,
                          ),
                        ],
                      ),
                      SizedBox(height: 8.0.h),
                      FText(
                        party?.challenge?.titleOneLine ?? '',
                        style: textTheme(context).headlineSmall,
                        bold: true,
                        maxLines: 2,
                      ),
                      SizedBox(height: 16.0.h),
                      FText(
                        party?.challenge?.descriptions['detail']!.replaceAll(
                          '##', party?.level['word'],
                        ),
                        style: textTheme(context).labelLarge,
                        color: FTheme.grey,
                        // align: TextAlign.center,
                        maxLines: 7,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}

class ChallengeScoreCard extends StatelessWidget {
  const ChallengeScoreCard({
    Key? key,
    this.party,
  }) : super(key: key);

  final Party? party;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return FCard(
      height: max(size.height * .6, 500.0.h),
      title: FText('점수판',
        style: textTheme(context).titleLarge,
        color: FTheme.darkGrey,
        bold: true,
      ),
      child: Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FText(
                  '전체 점수',
                  style: textTheme(context).bodyMedium,
                  color: FTheme.grey,
                ),
                SizedBox(height: 8.0.h),
                if (party != null) ChallengeScoreLinearIndicator(party: party!),
                SizedBox(height: 8.0.h),
                FText(
                  '친구 ${party?.memberUids.length}/${party?.level['maxMember']}',
                  style: textTheme(context).bodyMedium,
                  color: FTheme.grey,
                ),
                MyPartyRankingWidget(party: party),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(
                  color: FTheme.lightGrey,
                  thickness: 2,
                ),
                SizedBox(height: 12.0.h),
                GetBuilder<PartyP>(
                  builder: (partyP) {
                    return Material(
                      color: FTheme.grey,
                      borderRadius: BorderRadius.circular(10.0.r),
                      child: InkWell(
                        onTap: () => partyP.copyPartyId(party!.id!),
                        borderRadius: BorderRadius.circular(10.0.r),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 6.0.w,
                            vertical: 3.0.h,
                          ),
                          child: partyP.copied ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FText(
                                '복사완료',
                                style: textTheme(context).titleLarge,
                                color: FTheme.white,
                              ),
                              SizedBox(width: 5.0.w),
                              const Icon(
                                Icons.check,
                                color: FTheme.black,
                              ),
                            ],
                          ) : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FText(
                                party!.id!,
                                style: textTheme(context).titleLarge,
                                color: FTheme.white,
                              ),
                              const SizedBox(width: 8.0),
                              const Icon(
                                Icons.copy_rounded,
                                color: FTheme.white,
                                size: 20.0,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 10.0),
                FText(
                  '참여 코드를 친구에게 공유하여 함께 도전해요!',
                  style: textTheme(context).bodyLarge,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ChallengeScoreLinearIndicator extends StatefulWidget {
  const ChallengeScoreLinearIndicator({
    Key? key,
    required this.party,
  }) : super(key: key);

  final Party party;

  @override
  State<ChallengeScoreLinearIndicator> createState() =>
      _ChallengeScoreLinearIndicatorState();
}

class _ChallengeScoreLinearIndicatorState
    extends State<ChallengeScoreLinearIndicator> {
  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;

    double amount = widget.party.recordSum;
    double goal = widget.party.level['goal'].toDouble();

    if (widget.party.type == ActivityType.distance) {
      amount = (amount / 100).round() / 10;
      goal = (goal / 100).round() / 10;
    }

    String amountString = '${amount}K';
    String goalString = '${goal}K';

    if (amount * 10 % 10 == 0) amountString = '${amount.round()}K';
    if (goal * 10 % 10 == 0) goalString = '${goal.round()}K';

    bool isPortrait = orientation == Orientation.portrait;
    double lineHeight = (isPortrait ? 100.0 : 80.0).h;
    Radius radius = Radius.circular(isPortrait ? 20.0.r : 10.0.r);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LinearPercentIndicator(
          percent: max(amount / goal, .02),
          lineHeight: lineHeight,
          backgroundColor: FTheme.background,
          barRadius: radius,
          progressColor: widget.party.type.color,
          animation: true,
          animationDuration: 1000,
          curve: Curves.easeInOut,
        ),
        FText(
          '$amountString/$goalString',
          color: amount >= goal
              ? widget.party.challenge?.type?.color
              : FTheme.darkGrey,
          style: textTheme(context).bodyLarge,
        ),
        const SizedBox(height: 10.0),
      ],
    );
  }
}

class MyPartyRankingWidget extends StatelessWidget {
  const MyPartyRankingWidget({
    Key? key,
    this.party,
  }) : super(key: key);

  final Party? party;

  @override
  Widget build(BuildContext context) {
    final userP = Get.find<UserInfoP>();
    FUserInfo user = userP.loggedUser;

    return GetBuilder<LoadingP>(
      builder: (loadingP) {
        return loadingP.loading ? Container() : ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: party!.memberInfos.length,
          itemBuilder: (context, index) {
            // FUserInfo userInfo = party!.getMemberInfoByRank(index + 1);
            // FUserCollection userCollection = party!.getMemberCollectionByRank(index + 1);

            List<FUserInfo> infos = party!.memberInfos;
            List<FUserCollection> collections = party!.memberCollections;
            List<FUserRecord> records = party!.memberRecords;

            int amount = records[index].getAmounts(
              party!.type, party!.startDate, party!.endDate,
            ).round();

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  FBadgeWidget(
                    badge: BadgeJsonP.getBadge(collections[index].badgeId!),
                  ),
                  SizedBox(width: 12.0.w),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              constraints: BoxConstraints(maxWidth: 100.0.w),
                              child: FText(
                                infos[index].nickname!,
                                style: textTheme(context).bodyLarge,
                              ),
                            ),
                            if (infos[index].uid == user.uid)
                            const MeTag(),
                          ],
                        ),
                        FText(
                          '${toLocalString(amount)}${party!.type.unit}',
                          style: textTheme(context).bodyLarge,
                          color: FTheme.darkGrey,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
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
                FText(
                  '내 활동',
                  style: textTheme(context).headlineSmall,
                  color: FTheme.black,
                ),
                const SizedBox(width: 10.0),
                FText(
                  '*현재 챌린지 기준',
                  style: textTheme(context).bodySmall,
                  color: FTheme.darkGrey,
                ),
              ],
            ),
          ),
          SizedBox(height: 30.0.h),
          SizedBox(
            height: 70.0.h,
            child: GetBuilder<PartyP>(builder: (controller) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedFlipCounter(
                    value: controller.value.toInt(),
                    textStyle: textTheme(context).displayLarge?.apply(
                      color: type.color,
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  FText(
                    type.unitAlt,
                    style: textTheme(context).bodySmall,
                    color: FTheme.darkGrey,
                  ),
                ],
              );
            }),
          ),
          SizedBox(height: 20.0.h),
          SizedBox(
            height: 40.0.h,
            child: FTexts(
              [
                '모두가 합심하여 ',
                '${party.recordSum.round()}${type.unitAlt}',
                '을 ${type.did}'
              ],
              colors: [FTheme.darkGrey, type.color, FTheme.darkGrey],
              space: false,
              style: textTheme(context).headlineSmall,
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

    FUserParty loggedUser = Get.find<UserPartyP>().loggedUser;
    int myRank = party.getRank(loggedUser.uid!);
    double goal =
    party.challenge!.levels[party.difficulty.name]['goal'].toDouble();
    double totalRecords =
    party.records.values.reduce((a, b) => a + b).toDouble();

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
                        FText(
                          '순위',
                          style: textTheme(context).headlineSmall,
                          color: FTheme.black,
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
                            GlobalP.effectAsset,
                            width: 120.0.r,
                            height: 120.0.r,
                          ),
                        ),
                        if (myRank > 0)
                          Image.asset(
                            '${trophyAsset}trophy${myRank > 3 ? '' : '_$myRank'}.png',
                            width: 50.0.r,
                            height: 50.0.r,
                          ),
                        Positioned(
                          top: 45.0.r,
                          child: Container(
                            alignment: Alignment.center,
                            width: 40.0.r,
                            height: 40.0.r,
                            child: FText(
                              '$myRank',
                              style: textTheme(context).headlineSmall,
                              color: myRank > 3 ? FTheme.white : FTheme.black,
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
                    FText(
                      '현재 1위: ${party.winnerInfo.nickname} 님',
                      style: textTheme(context).titleMedium,
                      color: FTheme.black,
                    ),
                    FText(
                      '나의 순위: ${party.getRank(loggedUser.uid!)}위',
                      style: textTheme(context).titleMedium,
                      color: FTheme.black,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.0.h),
              Container(
                height: 50.0.h,
                decoration: BoxDecoration(
                  border: Border.all(color: FTheme.black, width: .75),
                ),
                child: Row(
                  children: party.memberInfos.map((user) {
                    double? record = party.records[user.uid];
                    double percent = 100 * record! / goal;
                    return Expanded(
                      flex: max(party.records[user.uid!] as int, 1),
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: user.uid! == loggedUser.uid!
                              ? party.challenge!.type!.color
                              : FTheme.black.withOpacity(.3),
                          border: Border.all(color: FTheme.black, width: .75),
                        ),
                        child: FText('${percent.round()} %'),
                      ),
                    );
                  }).toList()..add(
                    Expanded(
                      flex: max((goal - totalRecords).round(), 1),
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: FTheme.background,
                          border: Border.all(color: FTheme.black, width: .75),
                        ),
                        child: FText(
                          '${(goal - totalRecords).round()}${party.challenge!.type!.unit}',
                          color: FTheme.colorB,
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
          color: FTheme.darkGrey,
          thickness: 1,
          height: 1.0,
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: party.records.length,
          itemBuilder: (context, index) {
            FUserInfo loggedUser = Get.find<UserInfoP>().loggedUser;
            FUserInfo userInfo = party.getMemberInfoByRank(index + 1);
            FUserCollection userCollection =
            party.getMemberCollectionByRank(index + 1);

            return Container(
              height: 80.0.h,
              color: userInfo.uid == loggedUser.uid ? FTheme.bar : null,
              padding: const EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(width: 10.0.w, child: FText('${index + 1}')),
                  SizedBox(
                    width: 50.0.w,
                    height: 50.0.h,
                    child: FBadgeWidget(
                      badge: userCollection.collection?.badge,
                      size: 40.0,
                    ),
                  ),
                  SizedBox(
                    width: 130.0.w,
                    child: FText(userInfo.nickname!),
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    width: 70.0.w,
                    child: FText(
                      '${party.records[userInfo.uid!]}${party.challenge!.type!.unit}',
                    ),
                  ),
                ],
              ),
            );
          },
          separatorBuilder: (context, index) => const Divider(
            color: FTheme.darkGrey,
            thickness: 1,
            height: 1.0,
          ),
        ),
        const Divider(
          color: FTheme.darkGrey,
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
    FUserInfo user = Get.find<UserInfoP>().loggedUser;

    return GetBuilder<PartyP>(
      builder: (controller) {
        return Center(
          child: Padding(
            padding: EdgeInsets.all(20.0.r),
            child: Column(
              children: [
                Column(
                  children: [
                    Column(
                      children: [
                        SizedBox(
                          height: 160.0.h,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              if (!party.complete)
                              EternalRotation(
                                rps: .3,
                                child: Image.asset(
                                  GlobalP.effectAsset,
                                ),
                              ),
                              FBadgeWidget(
                                badge: party.badge,
                                // greyscale: party.complete,
                              ),
                              if (party.complete)
                                RotationTransition(
                                  turns: const AlwaysStoppedAnimation(-.075),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 7.0),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: FTheme.colorB, width: 2.0),
                                    ),
                                    child: FText(
                                      ' 완 료 ',
                                      style: textTheme(context).displayMedium,
                                      color: FTheme.colorB,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        SizedBox(height: 12.0.h),
                        if (party.satisfy && party.leaderUid == user.uid)
                          FButton(
                            text: '챌린지 완료!',
                            backgroundColor: party.complete
                                ? FTheme.lightGrey
                                : ActivityType.calorie.color,
                            onPressed: party.complete
                                ? () {}
                                : () => controller.complete(),
                            // onPressed: () =>
                            //     ChallengePartyComplete.toChallengePartyComplete(
                            //   party,
                            // ),
                          )
                        else FButton(
                          text: '챌린지 완료!',
                          backgroundColor: FTheme.lightGrey,
                          textColor: FTheme.darkGrey,
                          border: false,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
