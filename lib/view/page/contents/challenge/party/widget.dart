import 'dart:math';

import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:fitween/presenter/model/json/party.dart';
import 'package:fitween/presenter/page/contents/challenge/party.dart';
import 'package:fitween/presenter/widget/loading.dart';
import 'package:fitween/view/widget/widget/card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:fitween/global/theme.dart';
import 'package:fitween/model/class/database/party.dart';
import 'package:fitween/model/enum/activity_type.dart';
import 'package:fitween/view/widget/widget/text.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class PartyView extends StatelessWidget {
  const PartyView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final refreshCont = RefreshController();
    final userP = Get.find<UserPartyP>();

    return GetBuilder<PartyP>(
      builder: (partyP) {
        return SmartRefresher(
          controller: refreshCont,
          onRefresh: () async {
            // try {
            await PartyP.init(partyP.loadedParty!.id!);
            refreshCont.refreshCompleted();
            // } catch (e) {
            //   refreshCont.refreshFailed();
            // }
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
            child: Column(
              children: [
                ChallengeInfoCard(party: partyP.loadedParty),
                SizedBox(height: 20.0.h),
                ChallengeScoreCard(party: partyP.loadedParty),
                const SizedBox(height: 100.0),
                // const Divider(
                //   color: FTheme.lightGrey,
                //   thickness: 8,
                // ),
                // RankWidget(party: party),
                // const Divider(
                //   color: FTheme.lightGrey,
                //   thickness: 8,
                // ),
                // ChallengeBadgeWidget(party: party),
                // const SizedBox(height: 100.0),
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
    BorderRadius imageRadius = const BorderRadius.vertical(top: Radius.circular(12.0));
    // List<Color> orderedColors = [FTheme.darkGrey, ...FTheme.orderedColors];
    // int index = min(max((party!.remainDays ~/ 4) + 1, 0), 4);

    return GetBuilder<LoadingP>(
      builder: (loadingP) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0.r),
          child: FCard(
            constraints: BoxConstraints(minHeight: 450.0.h),
            padding: EdgeInsets.zero,
            child: loadingP.loading ? Container() : Column(
              children: [
                ClipRRect(
                  borderRadius: imageRadius,
                  child: Image.asset(
                    party?.challenge?.imageUrls['default'],
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 230.0.h,
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
                            '최대인원 | ${party?.level['maxMember']}명',
                            style: textTheme.bodyMedium,
                            color: FTheme.lightGrey,
                          ),
                          SizedBox(width: 40.0.w),
                          FText(
                            '마감기한 | D-${party?.remainDays}',
                            style: textTheme.bodyMedium,
                            color: FTheme.lightGrey,
                          ),
                        ],
                      ),
                      SizedBox(height: 8.0.h),
                      FText(
                        party?.challenge?.titleOneLine ?? '',
                        style: textTheme.headlineSmall,
                        bold: true,
                        maxLines: 2,
                      ),
                      SizedBox(height: 16.0.h),
                      FText(
                        party?.challenge?.descriptions['detail']!.replaceAll(
                          '##',
                          party?.level['word'],
                        ),
                        style: textTheme.labelLarge,
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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.0.r),
      child: FCard(
        title: '점수판',
        constraints: const BoxConstraints(minHeight: 270.0),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FText(
                '전체 점수',
                style: textTheme.bodyMedium,
                color: FTheme.grey,
              ),
              SizedBox(height: 8.0.h),
              if (party != null) ChallengeScoreLinearIndicator(party: party!),
              SizedBox(height: 8.0.h),
              FText(
                '친구 ${party?.memberUids.length}/${party?.level['maxMember']}',
                style: textTheme.bodyMedium,
                color: FTheme.grey,
              ),
            ],
          ),
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
    int amount = widget.party.recordSum.round();
    int goal = widget.party.level['goal'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              flex: max(1, amount),
              child: Container(
                height: 100.0,
                decoration: BoxDecoration(
                  color: widget.party.challenge?.type?.color,
                  borderRadius: const BorderRadius.horizontal(
                    right: Radius.circular(20.0),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: amount == 0 ? 49 : max(0, goal - amount),
              child: const SizedBox(),
            ),
          ],
        ),
        FText(
          '$amount / $goal ${widget.party.challenge?.type?.unit}',
          color: amount >= goal
              ? widget.party.challenge?.type?.color
              : FTheme.black,
          style: textTheme.bodyMedium,
        ),
        const SizedBox(height: 10.0),
      ],
    );
  }
}

// class ChallengeInfoWidget extends StatelessWidget {
//   const ChallengeInfoWidget({
//     Key? key,
//     required this.party,
//   }) : super(key: key);
//
//   final Party party;
//
//   @override
//   Widget build(BuildContext context) {
//     BorderRadius imageRadius = BorderRadius.circular(20.0.r);
//     List<Color> orderedColors = [FTheme.darkGrey, ...FTheme.orderedColors];
//     int index = min(max((party.remainDays ~/ 4) + 1, 0), 4);
//
//     return Padding(
//       padding: EdgeInsets.all(20.0.r),
//       child: Column(
//         children: [
//           Stack(
//             children: [
//               ClipRRect(
//                 borderRadius: imageRadius,
//                 child: Image.asset(
//                   party.challenge?.imageUrls['default'],
//                   fit: BoxFit.fitHeight,
//                   height: 230.0.h,
//                 ),
//               ),
//               Positioned.fill(
//                 child: Container(
//                   decoration: BoxDecoration(
//                     borderRadius: imageRadius,
//                     gradient: LinearGradient(
//                       colors: [
//                         FTheme.black.withOpacity(.1),
//                         FTheme.black.withOpacity(.3),
//                       ],
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomRight,
//                     ),
//                   ),
//                 ),
//               ),
//               Positioned(
//                 top: 10.0.h,
//                 right: 10.0.w,
//                 child: GetBuilder<ChallengePartyMainP>(builder: (controller) {
//                   return Material(
//                     color: FTheme.white.withOpacity(.5),
//                     borderRadius: BorderRadius.circular(10.0.r),
//                     child: InkWell(
//                       onTap: () => controller.copyPartyId(party.id!),
//                       borderRadius: BorderRadius.circular(10.0.r),
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 6.0,
//                           vertical: 3.0,
//                         ),
//                         width: 140.0.w,
//                         height: 40.0.h,
//                         child: controller.copied
//                             ? Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   FText(
//                                     '복사완료',
//                                     style: textTheme.titleLarge,
//                                     color: FTheme.black,
//                                   ),
//                                   const SizedBox(width: 5.0),
//                                   const Icon(
//                                     Icons.check,
//                                     color: FTheme.black,
//                                   ),
//                                 ],
//                               )
//                             : Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   FText(
//                                     party.id!,
//                                     style: textTheme.titleLarge,
//                                     color: FTheme.colorB,
//                                   ),
//                                   const SizedBox(width: 5.0),
//                                   const Icon(
//                                     Icons.copy,
//                                     color: FTheme.colorB,
//                                     size: 20.0,
//                                   ),
//                                 ],
//                               ),
//                       ),
//                     ),
//                   );
//                 }),
//               ),
//             ],
//           ),
//           SizedBox(height: 20.0.h),
//           Stack(
//             alignment: Alignment.center,
//             children: [
//               Container(
//                 alignment: Alignment.center,
//                 height: 40.0.h,
//                 child: FText(
//                   '난이도: ${party.difficulty.kr}',
//                   style: textTheme.labelLarge,
//                   color: FTheme.darkGrey,
//                 ),
//               ),
//               Positioned(
//                 right: 60.0,
//                 child: Container(
//                   padding: const EdgeInsets.symmetric(
//                     vertical: 3.0,
//                     horizontal: 10.0,
//                   ),
//                   decoration: BoxDecoration(
//                     color: orderedColors[index].withOpacity(.6),
//                     borderRadius: BorderRadius.circular(6.0.r),
//                   ),
//                   child: FText(party.dDay),
//                 ),
//               )
//             ],
//           ),
//           SizedBox(height: 10.0.h),
//           Container(
//             alignment: Alignment.center,
//             height: 40.0.h,
//             child: FText(
//               party.challenge?.titleOneLine ?? '',
//               style: textTheme.headlineMedium,
//               maxLines: 2,
//             ),
//           ),
//           SizedBox(height: 10.0.h),
//           SizedBox(
//             height: 20.0.h,
//             child: FText(
//               party.periodString,
//               color: FTheme.colorD,
//             ),
//           ),
//           SizedBox(height: 10.0.h),
//           Container(
//             alignment: Alignment.center,
//             height: 120.0.h,
//             child: FText(
//               party.challenge?.descriptions['detail']!.replaceAll(
//                 '##',
//                 party.level['word'],
//               ),
//               style: textTheme.labelLarge,
//               color: FTheme.darkGrey,
//               align: TextAlign.center,
//               maxLines: 7,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

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
                  style: textTheme.headlineSmall,
                  color: FTheme.black,
                ),
                const SizedBox(width: 10.0),
                FText(
                  '*현재 챌린지 기준',
                  style: textTheme.bodySmall,
                  color: FTheme.darkGrey,
                ),
              ],
            ),
          ),
          SizedBox(height: 30.0.h),
          SizedBox(
            height: 70.0.h,
            child: GetBuilder<PartyP>(
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
                    FText(
                      type.unitAlt,
                      style: textTheme.bodySmall,
                      color: FTheme.darkGrey,
                    ),
                  ],
                );
              },
            ),
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
              style: textTheme.headlineSmall,
            ),
          ),
        ],
      ),
    );
  }
}

// class RankWidget extends StatelessWidget {
//   const RankWidget({
//     Key? key,
//     this.party,
//   }) : super(key: key);
//
//   final Party? party;
//
//   @override
//   Widget build(BuildContext context) {
//     const String trophyAsset = 'assets/image/page/challenge/';
//
//     FUserParty loggedUser = Get.find<UserPartyP>().loggedUser;
//     int myRank = party?.getRank(loggedUser.uid!);
//     double goal = party.challenge!.levels[party.difficulty.name]['goal'].toDouble();
//     double totalRecords = party.records.values.reduce((a, b) => a + b).toDouble();
//
//     return Column(
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Column(
//             children: [
//               Column(
//                 children: [
//                   SizedBox(
//                     height: 40.0.h,
//                     child: Row(
//                       children: [
//                         FText(
//                           '순위',
//                           style: textTheme.headlineSmall,
//                           color: FTheme.black,
//                         ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(height: 20.0.h),
//                   SizedBox(
//                     height: 150.0.h,
//                     child: Stack(
//                       alignment: Alignment.center,
//                       children: [
//                         EternalRotation(
//                           rps: .3,
//                           child: Image.asset(
//                             GlobalP.effectAsset,
//                             width: 120.0.r,
//                             height: 120.0.r,
//                           ),
//                         ),
//                         if (myRank > 0)
//                           Image.asset(
//                             '${trophyAsset}trophy${myRank > 3 ? '' : '_$myRank'}.png',
//                             width: 50.0.r,
//                             height: 50.0.r,
//                           ),
//                         Positioned(
//                           top: 45.0.r,
//                           child: Container(
//                             alignment: Alignment.center,
//                             width: 40.0.r,
//                             height: 40.0.r,
//                             child: FText(
//                               '$myRank',
//                               style: textTheme.headlineSmall,
//                               color: myRank > 3 ? FTheme.white : FTheme.black,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 20.0.h),
//               SizedBox(
//                 height: 50.0.h,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     FText(
//                       '현재 1위: ${party.winnerInfo.nickname} 님',
//                       style: textTheme.titleMedium,
//                       color: FTheme.black,
//                     ),
//                     FText(
//                       '나의 순위: ${party.getRank(loggedUser.uid!)}위',
//                       style: textTheme.titleMedium,
//                       color: FTheme.black,
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(height: 20.0.h),
//               Container(
//                 height: 50.0.h,
//                 decoration: BoxDecoration(
//                   border: Border.all(color: FTheme.black, width: .75),
//                 ),
//                 child: Row(
//                   children: party.memberInfos.map((user) {
//                     double record = party.records[user.uid].toDouble();
//                     double percent = 100 * record / goal;
//                     return Expanded(
//                       flex: max(party.records[user.uid!], 1),
//                       child: Container(
//                         alignment: Alignment.center,
//                         decoration: BoxDecoration(
//                           color: user.uid! == loggedUser.uid!
//                               ? party.challenge!.type!.color
//                               : FTheme.black.withOpacity(.3),
//                           border: Border.all(color: FTheme.black, width: .75),
//                         ),
//                         child: FText('${percent.round()} %'),
//                       ),
//                     );
//                   }).toList()
//                     ..add(
//                       Expanded(
//                         flex: max((goal - totalRecords).round(), 1),
//                         child: Container(
//                           alignment: Alignment.center,
//                           decoration: BoxDecoration(
//                             color: FTheme.background,
//                             border: Border.all(color: FTheme.black, width: .75),
//                           ),
//                           child: FText(
//                             '${(goal - totalRecords).round()}${party.challenge!.type!.unit}',
//                             color: FTheme.colorB,
//                           ),
//                         ),
//                       ),
//                     ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         const Divider(
//           color: FTheme.darkGrey,
//           thickness: 1,
//           height: 1.0,
//         ),
//         ListView.separated(
//           shrinkWrap: true,
//           physics: const NeverScrollableScrollPhysics(),
//           padding: EdgeInsets.zero,
//           itemCount: party.records.length,
//           itemBuilder: (context, index) {
//             FUserInfo loggedUser = Get.find<UserInfoP>().loggedUser;
//             FUserInfo userInfo = party.getMemberInfoByRank(index + 1);
//             FUserCollection userCollection =
//                 party.getMemberCollectionByRank(index + 1);
//
//             return Container(
//               height: 80.0.h,
//               color: userInfo.uid == loggedUser.uid ? FTheme.bar : null,
//               padding: const EdgeInsets.all(15.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   SizedBox(width: 10.0.w, child: FText('${index + 1}')),
//                   SizedBox(
//                     width: 50.0.w,
//                     height: 50.0.h,
//                     child: BadgeWidget(
//                       badge: userCollection.collection?.badge,
//                       size: 40.0,
//                     ),
//                   ),
//                   SizedBox(
//                     width: 130.0.w,
//                     child: FText(userInfo.nickname!),
//                   ),
//                   Container(
//                     alignment: Alignment.centerRight,
//                     width: 70.0.w,
//                     child: FText(
//                       '${party.records[userInfo.uid!]}${party.challenge!.type!.unit}',
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           },
//           separatorBuilder: (context, index) => const Divider(
//             color: FTheme.darkGrey,
//             thickness: 1,
//             height: 1.0,
//           ),
//         ),
//         const Divider(
//           color: FTheme.darkGrey,
//           thickness: 1,
//           height: 1.0,
//         ),
//         SizedBox(height: 40.0.h),
//       ],
//     );
//   }
// }
//
// class ChallengeBadgeWidget extends StatelessWidget {
//   const ChallengeBadgeWidget({
//     Key? key,
//     required this.party,
//   }) : super(key: key);
//
//   final Party party;
//
//   @override
//   Widget build(BuildContext context) {
//     FUserInfo user = Get.find<UserInfoP>().loggedUser;
//
//     return GetBuilder<PartyP>(
//       builder: (partyP) {
//         return Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(20.0),
//               child: Column(
//                 children: [
//                   Column(
//                     children: [
//                       SizedBox(
//                         height: 40.0.h,
//                         child: Row(
//                           children: [
//                             FText(
//                               '보상',
//                               style: textTheme.headlineSmall,
//                               color: FTheme.black,
//                             ),
//                           ],
//                         ),
//                       ),
//                       SizedBox(height: 20.0.h),
//                       SizedBox(
//                         height: 150.0.h,
//                         child: Stack(
//                           alignment: Alignment.center,
//                           children: [
//                             if (!party.complete)
//                               EternalRotation(
//                                 rps: .3,
//                                 child: Image.asset(
//                                   GlobalP.effect2Asset,
//                                 ),
//                               ),
//                             BadgeWidget(
//                               badge: party.badge,
//                               greyscale: party.complete,
//                             ),
//                             if (party.complete)
//                             RotationTransition(
//                               turns: const AlwaysStoppedAnimation(-.075),
//                               child: Container(
//                                 padding:
//                                     const EdgeInsets.symmetric(horizontal: 7.0),
//                                 decoration: BoxDecoration(
//                                   border: Border.all(
//                                       color: FTheme.colorB, width: 2.0),
//                                 ),
//                                 child: FText(
//                                   ' 완 료 ',
//                                   style: textTheme.displayMedium,
//                                   color: FTheme.colorB,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       SizedBox(height: 20.0.h),
//                       if (party.satisfy && party.leaderUid == user.uid)
//                       PButton(
//                         text: '완료하기',
//                         stretch: true,
//                         onPressed: partyP.complete,
//                       )
//                       else PButton(
//                         text: '완료하기',
//                         stretch: true,
//                         backgroundColor: FTheme.lightGrey,
//                         textColor: FTheme.darkGrey,
//                         border: false,
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }