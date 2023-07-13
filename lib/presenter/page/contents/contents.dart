import 'package:fitween/global/string.dart';
import 'package:fitween/global/theme.dart';
import 'package:fitween/model/class/database/battle.dart';
import 'package:fitween/model/class/database/party.dart';
import 'package:fitween/model/class/database/user/info.dart';
import 'package:fitween/model/class/database/user/record.dart';
import 'package:fitween/model/enum/dialog.dart';
import 'package:fitween/presenter/inspection/inspection.dart';
import 'package:fitween/presenter/model/json/battle.dart';
import 'package:fitween/presenter/model/json/challenge.dart';
import 'package:fitween/presenter/model/json/party.dart';
import 'package:fitween/presenter/model/user/battle.dart';
import 'package:fitween/presenter/model/user/friend.dart';
import 'package:fitween/presenter/model/user/info.dart';
import 'package:fitween/presenter/model/user/party.dart';
import 'package:fitween/presenter/model/user/record.dart';
import 'package:fitween/presenter/page/contents/challenge/party.dart';
import 'package:fitween/presenter/page/contents/workout/battle/camera.dart';
import 'package:fitween/presenter/widget/loading.dart';
import 'package:fitween/view/widget/function/dialog.dart';
import 'package:fitween/view/widget/widget/text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContentsP extends GetxController {
  /// static variables
  static final codeCont = TextEditingController();
  int tabIndex = 0;

  bool codeInvalid = false;
  String? codeHintText = '';

  static void toContents([bool initialize = false]) async {
    Get.offAllNamed('/contents');
    if (initialize) await init();
  }

  /// methods
  static Future init() async {
    if (await Inspection.load()) return;

    final contentsP = Get.find<ContentsP>();
    final loadingP = Get.find<LoadingP>();

    if (loadingP.loading) return;
    loadingP.loadStart();
    await contentsP.loadAll();
    loadingP.loadEnd();

  }

  static bool cardPressed = false;
  static void unfinishedBattleCardPressed(String id) async {
    if (cardPressed) return;
    cardPressed = true;
    final userInfoP = Get.find<UserInfoP>();
    Battle? battle = await BattleJsonP.load(id);

    if (battle == null) return;
    String myUid = userInfoP.loggedUser.uid!;
    String rivalUid = battle.data.keys.firstWhere((uid) => uid != myUid);
    int remainChance = battle.getRemainChance(userInfoP.loggedUser.uid!);

    FUserInfo? rivalInfo = await UserInfoP.loadUser(rivalUid);
    if (rivalInfo == null) return;

    if (remainChance > 0) {
      showFDialog(
        title: '타임어택 신청',
        content: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FText('정말 '),
                FText(rivalInfo.nickname!, bold: true),
                FText('님에게'),
              ],
            ),
            FText('${['', '다시'][2 - remainChance]} 도전 하시겠습니까?'),
            const SizedBox(height: 20.0),
            FText(
              '주의! ${['시작하는 즉시 기회가 1회 소모됩니다', '마지막 도전입니다'][2 - remainChance]}',
              color: FTheme.error,
              style: FTheme.textTheme.labelLarge,
            ),
          ],
        ),
        type: DialogType.bi,
        leftPressed: Get.back,
        rightPressed: () async {
          Get.back();
          await BattleJsonP.reduceChance(id);
          BattleCameraP.toBattleCamera(id);
        },
      );
    }
    else {
      showFDialog(
        title: '경고!',
        content: Column(
          children: [
            FText(
              '남은 기회가 없어 더 이상\n타임어택을 진행할 수 없습니다.',
              maxLines: 2,
              color: FTheme.error,
              style: FTheme.textTheme.titleSmall,
            ),
            const SizedBox(height: 20.0),
          ],
        ),
        type: DialogType.mono,
        onPressed: Get.back,
      );
    }
    cardPressed = false;
  }

  Future loadAll() async {
    await ChallengeJsonP.importFile();

    if (tabIndex == 0) await loadParty();
    if (tabIndex == 1) await loadRecord();
    if (tabIndex == 2) { await loadBattle(); await loadFriend(); }

    loadParty();
    loadRecord();
    loadBattle();
    loadFriend();

    update();
  }

  Future loadParty() async {
    final userPartyP = Get.find<UserPartyP>();
    await userPartyP.load();
    await userPartyP.loadMyParties();
  }

  Future loadRecord() async {
    final userRecordP = Get.find<UserRecordP>();
    await userRecordP.load();
  }

  Future loadBattle() async {
    final userBattleP = Get.find<UserBattleP>();
    await userBattleP.load();
    await userBattleP.loadMyBattles();
  }

  Future loadFriend() async {
    final userFriendP = Get.find<UserFriendP>();
    await userFriendP.load();
    await userFriendP.loadFriends();
  }

  /// challenges
  // 챌린지 참가 버튼 클릭 시
  void challengeJoinButtonPressed() async {
    Get.back(); Get.back();

    await Future.delayed(const Duration(milliseconds: 500));

    codeCont.clear();
    codeHintText = null;

    showFDialog(
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