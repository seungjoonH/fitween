import 'package:fitween/global/string.dart';
import 'package:fitween/global/theme.dart';
import 'package:fitween/model/class/database/party.dart';
import 'package:fitween/model/class/database/user/record.dart';
import 'package:fitween/model/enum/dialog.dart';
import 'package:fitween/presenter/model/json/challenge.dart';
import 'package:fitween/presenter/model/party.dart';
import 'package:fitween/presenter/model/json/party.dart';
import 'package:fitween/presenter/model/user/record.dart';
import 'package:fitween/presenter/page/contents/challenge/party.dart';
import 'package:fitween/presenter/widget/loading.dart';
import 'package:fitween/view/widget/function/dialog.dart';
import 'package:fitween/view/widget/widget/text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContentsP extends GetxController {
  /// static variables
  static final codeCont = TextEditingController();

  bool codeInvalid = false;
  String? codeHintText = '';

  static void toContents() async {
    Get.offAllNamed('/contents');
  }

  /// methods
  static Future init() async {
    final contentsP = Get.find<ContentsP>();
    final loadingP = Get.find<LoadingP>();

    if (loadingP.loading) return;
    loadingP.loadStart();
    await contentsP.loadAll();
    loadingP.loadEnd();

  }

  Future loadAll() async {
    final userPartyP = Get.find<UserPartyP>();
    final userRecordP = Get.find<UserRecordP>();

    await ChallengeJsonP.importFile();
    await userPartyP.load();
    await userPartyP.loadMyParties();

    await userRecordP.load();

    update();
  }

  /// challenges
  // 챌린지 참가 버튼 클릭 시
  void challengeJoinButtonPressed() async {
    codeCont.clear();
    codeHintText = null;

    Get.dialog(
      PAlertDialog(
        title: '챌린지 참여코드',
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GetBuilder<ContentsP>(
              builder: (controller) {
                return FInputField(
                  controller: codeCont,
                  invalid: controller.codeInvalid,
                  hintText: controller.codeHintText ?? '참여코드를 입력해주세요',
                  hintColor: controller.codeHintText == null
                      ? FTheme.darkGrey
                      : FTheme.colorB,
                );
              },
            ),
          ],
        ),
        type: DialogType.bi,
        leftPressed: Get.back,
        rightPressed: partyJoinButtonPressed,
      ),
    );
  }

  // 파티 참가 버튼 클릭 시
  void partyJoinButtonPressed() async {
    final userPartyP = Get.find<UserPartyP>();
    final userRecordP = Get.find<UserRecordP>();
    FUserRecord user = userRecordP.loggedUser;

    if (!await validate()) return;
    Party? party = await PartyJsonP.loadParty(codeCont.text);

    if (party == null) return;
    party.memberUids.add(user.uid!);

    PartyJsonP.save(party);
    userPartyP.joinParty(codeCont.text);

    Get.back();
    ContentsP.toContents();
    PartyP.toParty(party);
  }

  // 파티 코드 입력 필드 유효성 검사
  Future<bool> validate() async {
    final userP = Get.find<UserPartyP>();
    String text = codeCont.text;

    Map<String, bool> conditions = {
      '정원이 차 참여할 수 없습니다': await PartyJsonP.partyFulled(text),
      '이미 참여중인 챌린지 입니다': userP.alreadyJoinedParty(text),
      '해당 코드의 챌린지가 없습니다': !await PartyJsonP.partyExists(text),
      '7글자로 입력해주세요': text.length != 7,
      '공백을 포함할 수 없습니다': text.contains(' '),
      '한글을 포함할 수 없습니다': hasKorean(text),
      '특수문자는 포함할 수 없습니다': RegExp(r'[`~!@#$%^&*|"' r"'‘’””;:/?]").hasMatch(text),
      '별명을 입력해주세요': text == '',
    };

    conditions.forEach((message, condition) {
      if (condition) codeHintText = message;
    });

    if (conditions.values.any((condition) => condition)) {
      codeCont.clear();
      codeInvalid = true;
      update();
      await Future.delayed(const Duration(milliseconds: 500), () {
        codeInvalid = false;
        update();
      });
      await Future.delayed(const Duration(milliseconds: 500), () {
        codeCont.text = text;
        update();
        codeHintText = null;
      });
      return false;
    }
    return true;
  }
}