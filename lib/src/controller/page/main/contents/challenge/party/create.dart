import 'package:fitween/global/global.dart';
import 'package:fitween/route.dart';
import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/model/class/dao.dart';
import 'package:fitween/src/model/class/model.dart';
import 'package:fitween/src/view/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PartyCreatePageCont extends PageCont {
  static PartyCreatePageCont get to => Get.find<PartyCreatePageCont>();

  String get difficultyHeaderText => LangCont.tr('word.difficulty').capitalize!;
  String get descriptionHeaderText => LangCont.tr('word.description').capitalize!;
  String get infoHeaderText => LangCont.tr('word.info').capitalize!;

  final _difficulty = Difficulty.easy.obs;
  Difficulty get difficulty => _difficulty.value;

  void setDifficulty(Difficulty d) { _difficulty(d); }

  final _challenge = Rx<Challenge?>(null);
  Challenge? get challenge => _challenge.value;

  String get goalTitle => LangCont.tr('word.goal');
  String get goalValueText => challenge!.type.withAltUnit(challenge!.getGoal(difficulty));

  String get maxMemberTitle => LangCont.tr('word.max-member');
  String get maxMemberValueText => '${challenge!.getMaxMemberCount(difficulty)}';

  String get periodTitle => LangCont.tr('word.period');
  String get periodValueText => LangCont.plural('unit.day', challenge!.period);

  String get pointTitle => 'FPoint';
  String get pointValueText => '${challenge!.getPoint(difficulty).thouSep} FPs';

  String get createPartyText => LangCont.tr('party-create.create-party');

  String get _dialogTr => 'party-create.dialog';
  String get reallyDialogTitle => LangCont.tr('$_dialogTr.really-title');
  String get reallyDialogText => LangCont.tr('$_dialogTr.really-text');
  String get createdDialogTitle => LangCont.tr('$_dialogTr.created-title');
  String get createdDialogText => LangCont.tr('$_dialogTr.created-text');

  void createPartyButtonPressed() {
    showFDialog(
      title: reallyDialogTitle,
      content: FText(reallyDialogText),
      type: DialogType.bi,
      rightPressed: createParty,
    );
  }

  void createParty() async {
    Party newParty = Party(
      challengeId: challenge!.key,
      difficulty: difficulty,
      leader: AuthCont.logged!,
    );

    await showFDialog(
      title: createdDialogTitle,
      content: Column(
        children: [
          FText(createdDialogText),
          SizedBox(height: 10.0.h),
          FCopyButton(text: newParty.key),
        ],
      ),
      type: DialogType.mono,
      onPressed: Get.back,
    );
    _logged.party!.addParty(newParty);

    await PartyDAO().saveOne(newParty);
    await FUserPartyDAO().saveOne(_logged.party!);

    FRoute.toContents();
    FRoute.toChallenge();
  }

  FUser get _logged => AuthCont.logged!;

  @override
  Future load() async {
    _challenge.value = await Get.arguments as Challenge;
  }

  @override
  String get loadKey => 'party-create';
}