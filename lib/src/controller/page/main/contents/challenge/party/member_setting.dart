import 'package:fitween/global/global.dart';
import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/model/class/dao.dart';
import 'package:fitween/src/model/class/model.dart';
import 'package:fitween/src/view/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PartyMemberSettingPageCont extends PageCont {
  static PartyMemberSettingPageCont get to => Get.find<PartyMemberSettingPageCont>();
  static PartyPageCont get partyCont => PartyPageCont.to;

  String get appBarTitle => LangCont.tr('appbar.member-setting');

  final _party = Rx<Party?>(null);
  Party? get party => _party.value;

  List<FUser> get members => party!.members.values.toList();
  List<FUser> get membersWithoutMe => [...members]..removeWhere((m) => m.key == myUid);

  String get delegateButtonText => LangCont.tr('button.delegate-leader');
  String get pokeButtonText => LangCont.tr('button.poke');
  String get banishButtonText => LangCont.tr('button.banish');

  String get _dialogTr => 'member-setting.dialog';

  String get delegateReallyTitle => LangCont.tr('$_dialogTr.delegate.really-title');
  String getDelegateReallyText(String nickname) {
    return LangCont.tr('$_dialogTr.delegate.really-text', namedArgs: {'nickname': nickname});
  }
  String get delegateCompleteTitle => LangCont.tr('$_dialogTr.delegate.complete-title');
  String getDelegateCompleteText(String nickname) {
    return LangCont.tr('$_dialogTr.delegate.complete-text', namedArgs: {'nickname': nickname});
  }

  void delegateButtonPressed(FUser member) async {
    await showFDialog(
      title: delegateReallyTitle,
      content: FTexts(
        getDelegateReallyText(member.nickname),
        highlightStyle: FTheme.titleSmall?.copyWith(
          color: party!.type.color,
          fontWeight: FontWeight.bold,
        ),
        wordWrap: true,
      ),
      type: DialogType.bi,
      rightText: delegateButtonText,
      rightPressed: () => delegateLeader(member),
    );
  }

  void delegateLeader(FUser member) async {
    await showFDialog(
      title: delegateCompleteTitle,
      content: FTexts(
        getDelegateCompleteText(member.nickname),
        highlightStyle: FTheme.titleSmall?.copyWith(
          color: party!.type.color,
          fontWeight: FontWeight.bold,
        ),
        wordWrap: true,
      ),
      type: DialogType.mono,
    );

    party!.delegateLeaderTo(member.key);
    await PartyDAO().saveOne(party!);

    Get.back();
  }

  String get banishReallyTitle => LangCont.tr('$_dialogTr.banish.really-title');
  String getBanishReallyText(String nickname) {
    return LangCont.tr('$_dialogTr.banish.really-text', namedArgs: {'nickname': nickname});
  }
  String get banishCompleteTitle => LangCont.tr('$_dialogTr.banish.complete-title');
  String getBanishCompleteText(String nickname) {
    return LangCont.tr('$_dialogTr.banish.complete-text', namedArgs: {'nickname': nickname});
  }

  void banishButtonPressed(FUser member) async {
    await showFDialog(
    title: banishReallyTitle,
    content: FTexts(
      getBanishReallyText(member.nickname),
      highlightStyle: FTheme.titleSmall?.copyWith(
        color: party!.type.color,
        fontWeight: FontWeight.bold,
      ),
      wordWrap: true,
    ),
    type: DialogType.bi,
    rightText: banishButtonText,
    rightBackgroundColor: FTheme.error,
    rightPressed: () => banishMember(member),
    );
  }

  void banishMember(FUser member) async {
    member.party = await FUserPartyDAO().loadOne(member.key);

    await showFDialog(
    title: banishCompleteTitle,
    content: FTexts(
      getBanishCompleteText(member.nickname),
      highlightStyle: FTheme.titleSmall?.copyWith(
        color: party!.type.color,
        fontWeight: FontWeight.bold,
      ),
      wordWrap: true,
    ),
    type: DialogType.mono,
    );

    member.party!.removeParty(party!.key);
    await FUserPartyDAO().saveOne(member.party!);

    party!.removeMember(member.key);
    partyCont.setParty(party!);

    Get.back();
    partyCont.onRefresh();
  }

  bool get isLeader => party!.leaderUid == myUid;

  String get myUid => _logged.key;

  FUser get _logged => AuthCont.logged!;

  @override
  Future load() async {
    _party.value = Get.arguments as Party;
  }

  @override
  String get loadKey => 'member-setting';

}