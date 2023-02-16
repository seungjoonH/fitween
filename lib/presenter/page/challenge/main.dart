import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:fitween/global/string.dart';
import 'package:fitween/global/theme.dart';
import 'package:fitween/model/class/database/party.dart';
import 'package:fitween/model/class/database/user.dart';
import 'package:fitween/model/enum/dialog.dart';
import 'package:fitween/presenter/model/party.dart';
import 'package:fitween/presenter/page/challenge/party/main.dart';
import 'package:fitween/presenter/widget/loading.dart';
import 'package:fitween/presenter/model/challenge.dart';
import 'package:fitween/presenter/model/user.dart';
import 'package:fitween/view/widget/function/dialog.dart';
import 'package:fitween/view/widget/widget/text.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:get/get.dart';

class ChallengeMainP extends GetxController {
  static void toChallengeMain() => Get.toNamed('/challengeMain');

  /// methods
  Future init() async {
    final userP = Get.find<UserP>();
    final loadingP = Get.find<LoadingPresenter>();

    loadingP.loadStart();

    // tabCont.index = 0;
    await ChallengePresenter.importFile();
    await userP.load();
    await userP.loadMyParties();

    loadingP.loadEnd();
  }
}

// class ChallengeMain extends GetxController with GetSingleTickerProviderStateMixin {
//
//   /// static variables
//   static final refreshCont = RefreshController();
//   static final codeCont = TextEditingController();
//
//   /// static methods
//   // 챌린지 메인 페이지로 이동
//   static Future toChallengeMain() async {
//     final challengeMain = Get.find<ChallengeMain>();
//
//     Get.offAllNamed('/challenge/main');
//     await challengeMain.init();
//   }
//
//   /// attributes
//   late TabController tabCont;
//   List<Widget> tabs = ['이달의 챌린지', '내 챌린지']
//       .map((title) => FText(title)).toList();
//   bool codeInvalid = false;
//   String? codeHintText = '';
//

//
//   // 챌린지 참가 버튼 클릭 시
//   void challengeJoinButtonPressed() async {
//     codeCont.clear();
//     codeHintText = null;
//
//     Get.dialog(
//       PAlertDialog(
//         title: '코드 입력',
//         content: Padding(
//           padding: const EdgeInsets.symmetric(
//             horizontal: 10.0, vertical: 20.0,
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               FText('참여할 챌린지 코드를 입력하세요'),
//               SizedBox(height: 10.0.h),
//               GetBuilder<ChallengeMain>(
//                 builder: (controller) {
//                   return PInputField(
//                     controller: codeCont,
//                     invalid: controller.codeInvalid,
//                     hintText: controller.codeHintText ?? 'ABC1234',
//                     hintColor: controller.codeHintText == null
//                         ? FTheme.grey : FTheme.colorB,
//                   );
//                 }
//               ),
//             ],
//           ),
//         ),
//         type: DialogType.bi,
//         leftPressed: Get.back,
//         rightPressed: partyJoinButtonPressed,
//       ),
//     );
//   }
//
//   // 파티 참가 버튼 클릭 시
//   void partyJoinButtonPressed() async {
//     final userP = Get.find<UserPresenter>();
//     PUser user = userP.loggedUser;
//
//     if (!await validate()) return;
//     Party? party = await PartyPresenter.loadParty(codeCont.text);
//
//     if (party == null) return;
//     party.records[user.uid!] = user.getAmounts(
//       party.challenge!.type!, party.startDate, party.endDate,
//     );
//
//     PartyPresenter.save(party);
//     userP.joinParty(codeCont.text);
//
//     Get.back();
//     ChallengeMain.toChallengeMain();
//     ChallengePartyMain.toChallengePartyMain(party);
//   }
//
//   // 파티 코드 입력 필드 유효성 검사
//   Future<bool> validate() async {
//     final userP = Get.find<UserPresenter>();
//     String text = codeCont.text;
//
//     Map<String, bool> conditions = {
//       '정원이 차 참여할 수 없습니다': await PartyPresenter.partyFulled(text),
//       '이미 참여중인 챌린지 입니다': userP.alreadyJoinedParty(text),
//       '해당 코드의 챌린지가 없습니다': !await PartyPresenter.partyExists(text),
//       '7글자로 입력해주세요': text.length != 7,
//       '공백을 포함할 수 없습니다': text.contains(' '),
//       '한글을 포함할 수 없습니다': hasKorean(text),
//       '특수문자는 포함할 수 없습니다': RegExp(r'[`~!@#$%^&*|"' r"'‘’””;:/?]").hasMatch(text),
//       '별명을 입력해주세요': text == '',
//     };
//
//     conditions.forEach((message, condition) {
//       if (condition) codeHintText = message;
//     });
//
//     if (conditions.values.any((condition) => condition)) {
//       codeCont.clear();
//       codeInvalid = true; update();
//       await Future.delayed(const Duration(milliseconds: 500), () {
//         codeInvalid = false; update();
//       });
//       await Future.delayed(const Duration(milliseconds: 500), () {
//         codeCont.text = text; update();
//         codeHintText = null;
//       });
//       return false;
//     }
//     return true;
//   }
//
//
//   @override
//   void onClose() {
//     tabCont.dispose();
//     super.onClose();
//   }
// }
