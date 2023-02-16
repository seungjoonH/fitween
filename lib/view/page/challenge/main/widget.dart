// /* 챌린지 메인 위젯 */
//
import 'package:fitween/global/theme.dart';
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

import '../../../../presenter/page/challenge/time_attack/time_attack_friend.dart';

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
        color: selected ? FTheme.grey : FTheme.lightGrey,
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
        Container(),
        Container(),
        FCard(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FText(
              '타임어택!',
              style: FTheme.textTheme.titleLarge,
            ),
            SizedBox(
              height: 8,
            ),
            Image.asset('assets/image/challenge/timeAttack/timeAttack.png'),
            SizedBox(
              height: 10,
            ),
            FText(
              '친구와 제한 시간 내에\n누가 더 스쿼트를 많이 하는지 대결해요!',
              maxLines: 2,
            ),
            SizedBox(
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

// import 'dart:math';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:fitween/global/date.dart';
// import 'package:fitween/global/theme.dart';
// import 'package:fitween/model/class/database/party.dart';
// import 'package:fitween/model/class/database/user.dart';
// import 'package:fitween/model/class/json/challenge.dart';
// import 'package:fitween/model/enum/border_type.dart';
// import 'package:fitween/model/enum/difficulty.dart';
// import 'package:fitween/presenter/widget/loading.dart';
// import 'package:fitween/presenter/model/challenge.dart';
// import 'package:fitween/presenter/model/user.dart';
// import 'package:fitween/presenter/page/challenge/detail.dart';
// import 'package:fitween/presenter/page/challenge/main.dart';
// import 'package:fitween/presenter/page/challenge/party/main.dart';
// import 'package:fitween/view/widget/button/button.dart';
// import 'package:fitween/view/widget/widget/badge.dart';
// import 'package:fitween/view/widget/widget/text.dart';
// import 'package:fitween/view/widget/widget/card.dart';
// import 'package:pull_to_refresh/pull_to_refresh.dart';
//
// class ChallengeMainView extends StatelessWidget {
//   const ChallengeMainView({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: const [
//         ChallengeTabBar(),
//         ChallengeTabView(),
//       ],
//     );
//   }
// }
//
// class ChallengeTabBar extends StatelessWidget {
//   const ChallengeTabBar({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final challengeMain = Get.find<ChallengeMain>();
//
//     return GetBuilder<LoadingPresenter>(
//       builder: (controller) {
//         return TabBar(
//           controller: challengeMain.tabCont,
//           tabs: challengeMain.tabs,
//           indicatorColor: FTheme.black,
//           indicatorSize: TabBarIndicatorSize.label,
//           indicatorWeight: 1.5,
//           labelPadding: const EdgeInsets.all(5.0),
//           splashFactory: InkRipple.splashFactory,
//           onTap: (index) {
//             if (controller.loading) challengeMain.tabCont.animateTo(0);
//           },
//         );
//       }
//     );
//   }
// }
//
// class ChallengeTabView extends StatelessWidget {
//   const ChallengeTabView({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.find<ChallengeMain>();
//
//     return Expanded(
//       child: TabBarView(
//         controller: controller.tabCont,
//         physics: const NeverScrollableScrollPhysics(),
//         children: const [
//           ChallengeListView(),
//           MyPartyListView(),
//         ],
//       ),
//     );
//   }
// }
//
// class ChallengeListView extends StatelessWidget {
//   const ChallengeListView({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<LoadingPresenter>(
//       builder: (controller) {
//         return Padding(
//           padding: EdgeInsets.fromLTRB(20.0.r, 20.0.r, 20.0.r, 0.0),
//           child: controller.loading
//               ? ChallengeCardViewLoading(color: controller.color)
//               : const ChallengeCardView(),
//         );
//       }
//     );
//   }
// }
//
// class ChallengeCardView extends StatelessWidget {
//   const ChallengeCardView({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<LoadingPresenter>(
//       builder: (controller) {
//         return SmartRefresher(
//           controller: ChallengeMain.refreshCont,
//           onRefresh: () async {
//             ChallengeMain.toChallengeMain();
//             ChallengeMain.refreshCont.refreshCompleted();
//           },
//           onLoading: () async {
//             await Future.delayed(const Duration(milliseconds: 100));
//             ChallengeMain.refreshCont.loadComplete();
//           },
//           header: const MaterialClassicHeader(
//             color: FTheme.black,
//             backgroundColor: FTheme.surface,
//           ),
//           child: ListView.separated(
//             itemCount: ChallengePresenter.orderedChallenges.length,
//             itemBuilder: (_, index) {
//               return ChallengeCard(
//                 challenge: ChallengePresenter.orderedChallenges[index],
//               );
//             },
//             separatorBuilder: (_, index) => SizedBox(height: 30.0.h),
//           ),
//         );
//       }
//     );
//   }
// }
//
//
// class ChallengeCard extends StatelessWidget {
//   const ChallengeCard({
//     Key? key,
//     required this.challenge,
//   }) : super(key: key);
//
//   final Challenge challenge;
//
//   @override
//   Widget build(BuildContext context) {
//     final userP = Get.find<UserPresenter>();
//
//     return Column(
//       children: [
//         Stack(
//           children: [
//             PCard(
//               color: FTheme.background,
//               padding: EdgeInsets.zero,
//               child: Column(
//                 children: [
//                   // ParallaxWidget(
//                   //   background: Image.asset(
//                   //     challenge.imageUrls['default'],
//                   //     fit: BoxFit.fitHeight,
//                   //   ),
//                   //   child: Container(height: 200.0),
//                   // ),
//                   if (challenge.locked)
//                   Container(height: 230.0.h, color: FTheme.lightGrey)
//                   else Image.asset(
//                     challenge.imageUrls['default'],
//                     // height: 230.0.h,
//                     fit: BoxFit.fitWidth,
//                   ),
//                   Divider(height: 1.0.h, color: FTheme.black, thickness: 1.5),
//                   Padding(
//                     padding: EdgeInsets.all(20.0.r),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.stretch,
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 SizedBox(
//                                   height: 80.0.h,
//                                   child: FText(challenge.title ?? '',
//                                     style: textTheme.headlineMedium,
//                                     maxLines: 2,
//                                   ),
//                                 ),
//                                 SizedBox(height: 20.0.h),
//                                 SizedBox(
//                                   height: 20.0.h,
//                                   child: FText('${today.month}월의 챌린지',
//                                     style: textTheme.labelLarge,
//                                     color: FTheme.grey,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             BadgeWidget(
//                               size: 80.0.r,
//                               badge: challenge.locked
//                                   ? null : challenge.badges[Difficulty.hard],
//                             ),
//                           ],
//                         ),
//                         SizedBox(height: 20.0.h),
//                         SizedBox(
//                           height: 30.0.h,
//                           child: FText(
//                             challenge.descriptions['sub']!,
//                             style: textTheme.titleSmall,
//                             color: FTheme.black,
//                             maxLines: 2,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   userP.alreadyJoinedChallenge(challenge.id!) ? PButton(
//                     onPressed: () => ChallengePartyMain.toChallengePartyMain(
//                       userP.getPartyByChallengeId(challenge.id!)!
//                     ),
//                     text: '챌린지 이동하기',
//                     stretch: true,
//                     height: 50.0,
//                   ) : PButton(
//                     onPressed: () => ChallengeDetail.toChallengeDetail(challenge),
//                     text: '알아보러 가기',
//                     stretch: true,
//                     height: 50.0,
//                   ),
//                 ],
//               ),
//             ),
//             if (challenge.locked)
//             Positioned.fill(
//               child: Container(
//                 color: FTheme.black.withOpacity(.5),
//                 child: const Icon(Icons.lock,
//                   color: FTheme.black,
//                   size: 70.0,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         SizedBox(height: 20.0.h),
//       ],
//     );
//   }
// }
//
// class ChallengeCardViewLoading extends StatelessWidget {
//   const ChallengeCardViewLoading({
//     Key? key,
//     this.color = FTheme.black,
//   }) : super(key: key);
//
//   final Color color;
//
//   @override
//   Widget build(BuildContext context) {
//     return ListView.separated(
//       itemCount: 2,
//       itemBuilder: (_, index) => ChallengeCardLoading(color: color),
//       separatorBuilder: (_, index) => SizedBox(height: 50.0.h),
//     );
//   }
// }
//
//
// class ChallengeCardLoading extends StatelessWidget {
//   const ChallengeCardLoading({
//     Key? key, this.color = FTheme.black,
//   }) : super(key: key);
//
//   final Color color;
//
//   @override
//   Widget build(BuildContext context) {
//     BoxDecoration decoration = BoxDecoration(
//       color: color, borderRadius: BorderRadius.circular(15.0),
//     );
//
//     return PCard(
//       borderType: BorderType.none,
//       color: FTheme.background,
//       padding: EdgeInsets.zero,
//       child: Column(
//         children: [
//           Container(
//             height: 232.0.h,
//             decoration: decoration,
//           ),
//           Padding(
//             padding: EdgeInsets.fromLTRB(0.0, 20.0.r, 20.0.r, 20.0.r),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         Container(
//                           width: 200.0.w,
//                           height: 80.0.h,
//                           decoration: decoration,
//                         ),
//                         SizedBox(height: 20.0.h),
//                         Container(
//                           width: 200.0.w,
//                           height: 20.0.h,
//                           decoration: decoration,
//                         ),
//                       ],
//                     ),
//                     BadgeWidget(size: 80.0.r, color: color, border: false),
//                   ],
//                 ),
//                 SizedBox(height: 20.0.h),
//                 Container(
//                   width: 200.0.w,
//                   height: 30.0.h,
//                   decoration: decoration,
//                 ),
//               ],
//             ),
//           ),
//           Container(
//             width: double.infinity,
//             height: 50.0.h,
//             decoration: decoration,
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class MyPartyListView extends StatelessWidget {
//   const MyPartyListView({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final userP = Get.find<UserPresenter>();
//     PUser user = userP.loggedUser;
//
//     return Stack(
//       children: [
//         if (user.parties.isEmpty)
//         Center(
//           child: Padding(
//             padding: const EdgeInsets.all(20.0),
//             child: PCard(
//               color: FTheme.surface,
//               padding: EdgeInsets.zero,
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Padding(
//                     padding: EdgeInsets.symmetric(
//                       horizontal: 30.0.w, vertical: 150.0.h,
//                     ),
//                     child: FText('챌린지가 없습니다',
//                       style: textTheme.displaySmall,
//                     ),
//                   ),
//                   const Divider(
//                     color: FTheme.black,
//                     thickness: 1.5,
//                     height: 0.0,
//                   ),
//                   GetBuilder<ChallengeMain>(
//                     builder: (controller) {
//                       return Row(
//                         children: [
//                           PButton(
//                             text: '챌린지 살펴보기',
//                             onPressed: () => controller.tabCont.index = 0,
//                             stretch: true,
//                             fill: false,
//                             multiple: true,
//                             border: false,
//                           ),
//                           PButton(
//                             text: '챌린지 참여하기',
//                             onPressed: controller.challengeJoinButtonPressed,
//                             stretch: true,
//                             multiple: true,
//                             border: false,
//                           ),
//                         ],
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ) else Padding(
//           padding: EdgeInsets.all(20.0.h),
//           child: Column(
//             children: [
//               ListView.separated(
//                 shrinkWrap: true,
//                 itemCount: user.parties.length,
//                 physics: const NeverScrollableScrollPhysics(),
//                 itemBuilder: (_, index) => MyPartyListTile(
//                   party: user.parties.values.toList()[index],
//                 ),
//                 separatorBuilder: (_, index) => SizedBox(height: 20.0.h),
//               ),
//               SizedBox(height: 20.0.h),
//               GetBuilder<ChallengeMain>(
//                 builder: (controller) {
//                   return Row(
//                     children: [
//                       PButton(
//                         text: '챌린지 살펴보기',
//                         onPressed: () => controller.tabCont.index = 0,
//                         stretch: true,
//                         fill: false,
//                         multiple: true,
//                       ),
//                       SizedBox(width: 20.0.w),
//                       PButton(
//                         text: '챌린지 참여하기',
//                         onPressed: controller.challengeJoinButtonPressed,
//                         stretch: true,
//                         multiple: true,
//                       ),
//                     ],
//                   );
//                 },
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// class MyPartyListTile extends StatelessWidget {
//   const MyPartyListTile({
//     Key? key,
//     required this.party,
//   }) : super(key: key);
//
//   final Party party;
//
//   @override
//   Widget build(BuildContext context) {
//     List<Color> orderedColors = [FTheme.grey, ...FTheme.orderedColors];
//     int index = min(max((party.remainDays ~/ 4) + 1, 0), 4);
//
//     return Stack(
//       alignment: Alignment.center,
//       children: [
//         Material(
//           color: Colors.transparent,
//           child: InkWell(
//             onTap: () => ChallengePartyMain.toChallengePartyMain(party),
//             child: Container(
//               height: 80.0.h,
//               decoration: BoxDecoration(
//                 border: Border.all(color: FTheme.black, width: 1.5),
//               ),
//               child: Row(
//                 children: [
//                   AspectRatio(
//                     aspectRatio: 1.0,
//                     child: Image.asset(
//                       party.challenge!.imageUrls['focus'],
//                       width: 100.0.w,
//                       height: 100.0.h,
//                       fit: BoxFit.fill,
//                     ),
//                   ),
//                   const VerticalDivider(
//                     width: 1.5,
//                     thickness: 1.5,
//                     color: FTheme.black,
//                   ),
//                   Expanded(
//                     child: Padding(
//                       padding: EdgeInsets.all(10.0.r),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               FText(party.challenge!.title!.replaceAll('\n', ' '),
//                                 style: textTheme.bodyLarge,
//                               ),
//                               Container(
//                                 padding: const EdgeInsets.symmetric(
//                                   vertical: 3.0, horizontal: 10.0,
//                                 ),
//                                 decoration: BoxDecoration(
//                                   color: orderedColors[index].withOpacity(.6),
//                                   borderRadius: BorderRadius.circular(6.0.r),
//                                 ),
//                                 child: FText(party.dDay),
//                               ),
//                             ],
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Expanded(
//                                 child: Row(
//                                   children: [
//                                     const Icon(Icons.people_alt, size: 14.0),
//                                     const SizedBox(width: 10.0),
//                                     FText('${party.members.length}/${
//                                       party.level['maxMember']
//                                     }'),
//                                   ],
//                                 ),
//                               ),
//                               Expanded(child: FText('난이도 : ${party.difficulty.kr}')),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   SizedBox(
//                     width: 50.0.w,
//                     child: const Icon(Icons.arrow_forward_ios),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//         if (party.over)
//         Positioned.fill(
//           child: Container(
//             alignment: Alignment.center,
//             color: FTheme.black.withOpacity(.2),
//           ),
//         ),
//         if (party.complete)
//         RotationTransition(
//           turns: const AlwaysStoppedAnimation(-.075),
//           child: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 7.0),
//             decoration: BoxDecoration(
//               border: Border.all(
//                 color: party.complete
//                     ? FTheme.colorB
//                     : FTheme.black,
//                 width: 2.0,
//               ),
//             ),
//             child: FText(
//               party.complete ? ' 완 료 ' : ' 실 패 ',
//               color: party.complete ? FTheme.colorB : FTheme.black,
//               style: textTheme.headlineLarge,
//             ),
//           ),
//         )
//       ],
//     );
//   }
// }
