import 'dart:async';

import 'package:fitween/global/global.dart';
import 'package:fitween/route.dart';
import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/model/class/dao.dart';
import 'package:fitween/src/model/class/model.dart';
import 'package:fitween/src/view/widget/function/dialog.dart';
import 'package:fitween/src/view/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum MemberProgressTextMode { amount, percent }

class PartyPageCont extends PageCont {
  static PartyPageCont get to => Get.find<PartyPageCont>();

  String get appBarTitle => LangCont.tr('appbar.party');
  String get progressCardTitle => LangCont.tr('party.progress');
  String get entireProgressText => LangCont.tr('party.entire');

  final _party = Rx<Party?>(null);
  Party? get party => _party.value;

  final _percent = .0.obs;
  double get percent => _percent.value;

  String get _amountText => party!.allAmounts.round().thouSep;
  String get _goalText => party!.type.withAltUnit(party!.goal, scaling: false);
  String get progressText => '$_amountText/$_goalText';

  Color get partyColor => party!.type.color;

  String get _memberCountText => '${party!.memberCount}/${party!.maxMemberCount}';
  String get memberCountText => '${LangCont.tr('word.member').capitalize} $_memberCountText';

  final _members = <FUser>[].obs;
  List<FUser> get members => _members;
  FUser getMember(String uid) => party!.members[uid]!;
  List<num> get _amountList => members.map((m) => party!.getAmounts(m.key)).toList();
  int getRank(String uid) => 1 + _amountList.indexWhere((a) => party!.getAmounts(uid) == a);

  Timer? _timer;
  final _mode = MemberProgressTextMode.amount.obs;
  MemberProgressTextMode get mode => _mode.value;

  String getMemberProgressText(String uid, MemberProgressTextMode m) {
    switch (m) {
      case MemberProgressTextMode.amount:
        return party!.type.withAltUnit(party!.getAmounts(uid));
      case MemberProgressTextMode.percent:
        return '${(100 * party!.getAmounts(uid) / party!.goal).round()} %';
    }
  }

  String get shareText => LangCont.tr('party.share');

  @override
  Future load() async {
    _party.value = Get.arguments as Party;
    await party!.loadMembers();
    _percent(party!.percent);
    _members.assignAll(party!.members.values);
    sortMembers();
    _startToggleMemberProgressTextMode();
  }

  void sortMembers() {
    int compare(FUser a, FUser b) => (
      party!.getAmounts(b.uid) - party!.getAmounts(a.uid)
    ).toInt();
    _members.sort(compare);
  }

  void _startToggleMemberProgressTextMode() {
    List<MemberProgressTextMode> values = MemberProgressTextMode.values.toList();
    _timer?.cancel();
    _timer = Timer.periodic(3.s, (_) {
      _mode(values[(mode.index + 1) % values.length]);
    });
  }

  String get giveUpText => LangCont.tr('button.give-up');
  String get dialogTr => 'party.dialog';
  String get reallyGiveUpTitle => LangCont.tr('$dialogTr.really-title');
  String get reallyGiveUpText => LangCont.tr('$dialogTr.really-text');
  String get givenUpTitle => LangCont.tr('$dialogTr.given-up-title');
  String get givenUpText => LangCont.tr('$dialogTr.given-up-text');

  bool get isLeader => party!.leaderUid == _logged.key;

  void giveUpButtonPressed() {
    showFDialog(
      title: reallyGiveUpTitle,
      content: FText(reallyGiveUpText),
      type: DialogType.bi,
      rightText: giveUpText,
      rightBackgroundColor: FTheme.error,
      rightPressed: giveUpParty,
    );
  }

  void giveUpParty() async {
    await showFDialog(
      title: givenUpTitle,
      content: FText(givenUpText),
      type: DialogType.mono,
    );

    _logged.party!.removeParty(party!.key);
    await PartyDAO().removeOne(party!);
    await FUserPartyDAO().saveOne(_logged.party!);

    FRoute.toContents();
    FRoute.toChallenge();
  }

  FUser get _logged => AuthCont.logged!;

  @override
  String get loadKey => 'party';

}