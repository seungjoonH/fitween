
// /// class
// class ChallengeCreate extends GetxController {
//   /// static methods
//   // 챌린지 생성 페이지로 이동
//   static void toChallengeCreate(Challenge challenge) {
//     final challengeCreate = Get.find<ChallengeCreate>();
//     challengeCreate.init();
//     Get.toNamed('/challenge/create', arguments: challenge);
//   }
//
//   /// attributes
//   Difficulty difficulty = Difficulty.easy;
//
//   /// methods
//   // 초기화
//   void init() {
//     difficulty = Difficulty.easy;
//     update();
//   }
//
//   // 난이도 변경
//   void changeDifficulty(Difficulty diff) {
//     difficulty = diff; update();
//   }
//
//   // 챌린지 생성 버튼 클릭 시
//   void challengeCreateButtonPressed(Challenge challenge) async {
//     final userP = Get.find<UserPresenter>();
//     String code = await userP.createMyParty(challenge, difficulty);
//     showChallengeCreatedDialog(code);
//   }
//
//   // 챌린지 생성 팝업
//   void showChallengeCreatedDialog(String code) {
//     showPDialog(
//       title: '챌린지 생성',
//       content: Column(
//         children: [
//           Center(
//             child: FText(code,
//               style: textTheme.titleLarge,
//               color: FTheme.colorB,
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(20.0),
//             child: FText('챌린지가 생성되었습니다.'),
//           ),
//         ],
//       ),
//       type: DialogType.mono,
//       onPressed: () {
//         Get.back();
//         PUser user = Get.find<UserPresenter>().loggedUser;
//         ChallengeMain.toChallengeMain();
//         ChallengePartyMain.toChallengePartyMain(user.parties[code]!);
//       },
//     );
//   }
// }