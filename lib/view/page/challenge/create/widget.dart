// /* 챌린지 난이도 위젯 */
//
// import 'package:flutter/material.dart';
// import 'package:flutter_polygon/flutter_polygon.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:get/get.dart';
// import 'package:fitween/global/theme.dart';
// import 'package:fitween/model/class/json/challenge.dart';
// import 'package:fitween/model/enum/difficulty.dart';
// import 'package:fitween/presenter/page/challenge/create.dart';
// import 'package:fitween/view/widget/button/button.dart';
// import 'package:fitween/view/widget/widget/badge.dart';
// import 'package:fitween/view/widget/widget/text.dart';
//
// // 챌린지 난이도 리스트 뷰
// class ChallengeCreateView extends StatelessWidget {
//   const ChallengeCreateView({
//     Key? key,
//     required this.challenge,
//   }) : super(key: key);
//
//   final Challenge challenge;
//
//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<ChallengeCreate>(
//       builder: (controller) {
//         String word = challenge.levels[controller.difficulty.name]['word'];
//         String description = challenge.descriptions['detail'].replaceAll('##', '#$word#');
//         List<String> descriptions = description.split('#');
//         List<Color> colors = List.generate(
//           descriptions.length, (index) => index % 2 == 0
//             ? FTheme.black : FTheme.colorB,
//         );
//
//         int maxMember = challenge.levels[controller.difficulty.name]['maxMember'];
//         String memberString = '${maxMember > 1 ? '1~' : ''}$maxMember';
//
//         return Stack(
//           alignment: Alignment.center,
//           children: [
//             Column(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Column(
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         SvgPicture.asset(
//                           'assets/image/page/challenge/left_wing.svg',
//                         ),
//                         FText('챌린지 난이도',
//                           style: textTheme.titleLarge,
//                           color: FTheme.black,
//                         ),
//                         SvgPicture.asset(
//                           'assets/image/page/challenge/right_wing.svg',
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 40.0),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: Difficulty.values.map((diff) => Stack(
//                         children: [
//                           GestureDetector(
//                             onTap: () => controller.changeDifficulty(diff),
//                             child: Padding(
//                               padding: EdgeInsets.all(6.0.r),
//                               child: Column(
//                                 children: [
//                                   Padding(
//                                     padding: const EdgeInsets.all(10.0),
//                                     child: Stack(
//                                       alignment: Alignment.center,
//                                       children: [
//                                         BadgeWidget(
//                                           badge: diff.active ? challenge.badges[diff] : null,
//                                           onPressed: () => controller.changeDifficulty(diff),
//                                         ),
//                                         Container(
//                                           width: 84.0.r,
//                                           height: 84.0.r,
//                                           decoration: ShapeDecoration(
//                                             color: diff == controller.difficulty
//                                                 ? Colors.transparent
//                                                 : FTheme.black.withOpacity(.5),
//                                             shape: PolygonBorder(
//                                               sides: 6,
//                                               side: BorderSide(
//                                                 width: 4.0.r,
//                                                 color: diff == controller.difficulty
//                                                     ? FTheme.colorB
//                                                     : Colors.transparent,
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   const SizedBox(height: 20.0),
//                                   FText(diff.kr,
//                                     style: textTheme.titleLarge,
//                                     color: diff == controller.difficulty
//                                         ? FTheme.colorB
//                                         : FTheme.black,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           if (!diff.active)
//                           Positioned.fill(
//                             child: Container(
//                               color: FTheme.black.withOpacity(.5),
//                               child: Icon(Icons.lock, size: 30.0.r),
//                             ),
//                           ),
//                         ],
//                       )).toList(),
//                     ),
//                   ],
//                 ),
//                 Column(
//                   mainAxisSize: MainAxisSize.min,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     FText('권장 참여 인원 : $memberString명',
//                       style: textTheme.headlineSmall,
//                     ),
//                     SizedBox(height: 20.0.h),
//                     SizedBox(
//                       height: 300.0.h,
//                       child: RichText(
//                         text: TextSpan(
//                           children: List.generate(descriptions.length, (index) => TextSpan(
//                             text: descriptions[index],
//                             style: textTheme.labelLarge?.apply(color: colors[index]),
//                           )).toList(),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//             Positioned(
//               bottom: 70.0.h,
//               child: PButton(
//                 onPressed: () => controller.challengeCreateButtonPressed(challenge),
//                 text: '챌린지 생성하기',
//                 stretch: true,
//                 constraints: const BoxConstraints(maxWidth: 340.0),
//               ),
//             ),
//           ],
//         );
//       }
//     );
//   }
// }
