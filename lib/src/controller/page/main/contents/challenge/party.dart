import 'dart:async';
import 'dart:math';

import 'package:fitween/global/global.dart';
import 'package:fitween/route.dart';
import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/model/class/dao.dart';
import 'package:fitween/src/model/class/date_range.dart';
import 'package:fitween/src/model/class/model.dart';
import 'package:fitween/src/model/enum/enum.dart';
import 'package:fitween/src/view/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

enum MemberProgressTextMode { amount, percent }

class ChartData {
  final DateTime x;
  final num y;

  ChartData(this.x, this.y);
}

class PartyPageCont extends PageCont {
  static PartyPageCont get to => Get.find<PartyPageCont>();

  String get appBarTitle => LangCont.tr('appbar.party');
  String get progressCardTitle => LangCont.tr('party.progress');
  String get entireProgressText => LangCont.tr('party.entire');

  final _party = Rx<Party?>(null);
  Party? get party => _party.value;
  void setParty(Party party) => _party.value = party;

  final _applicantCount = 0.obs;
  int get applicantCount => _applicantCount.value;
  void setApplicantCount() => _applicantCount(party!.applicantCount);

  void partyApplicantButtonPressed() async {
    party!.checkAllApplicants();
    await PartyDAO().saveOne(party!);
    FRoute.toPartyApplicants(party: party);
  }

  final _partyTitleEditMode = false.obs;
  bool get partyTitleEditMode => _partyTitleEditMode.value;

  final partyTitleCont = TextEditingController();
  void onTitleFieldChanged(String text) {
    if (partyTitleCont.text.trim().isNotEmpty) return;
    partyTitleCont.clear();
  }
  void toggleTitleMode() {
    String toSave = partyTitleCont.text.trim();
    if (toSave.trim().isEmpty) { toSave = party!.title; }

    _partyTitleEditMode(!partyTitleEditMode);
    if (partyTitleEditMode) { partyTitleCont.text = party!.title; }
    else { party!.updateTitle(toSave); }

    PartyDAO().saveOne(party!);
  }

  final _percent = .0.obs;
  double get percent => min(_percent.value, 1.0);

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

  double getMemberPercent(String uid) => party!.getAmounts(uid) / party!.goal;

  String getMemberProgressText(String uid, MemberProgressTextMode m) {
    switch (m) {
      case MemberProgressTextMode.amount:
        return party!.type.withAltUnit(party!.getAmounts(uid), txs: true);
      case MemberProgressTextMode.percent:
        return '@{${(100 * getMemberPercent(uid)).round()}} %';
    }
  }

  String get shareText => LangCont.tr('party.share');
  String get leaderTagText => LangCont.tr('word.leader').capitalize!;

  @override
  Future load() async {
    _party.value = Get.arguments as Party;
    await PartyDAO().loadOne(party!.key);
    await party!.loadMembers();
    await party!.loadApplicants();
    setApplicantCount();
    _percent(party!.percent);
    _members.assignAll(party!.members.values);
    sortMembers();
    _partyTitleEditMode(false);
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
  String get _dialogTr => 'party.dialog';
  String get reallyGiveUpTitle => LangCont.tr('$_dialogTr.give-up.really-title');
  String get reallyGiveUpOnlyText => LangCont.tr('$_dialogTr.give-up.really-only-text');
  String get reallyGiveUpLeaderText => LangCont.tr('$_dialogTr.give-up.really-leader-text');
  String get reallyGiveUpMemberText => LangCont.tr('$_dialogTr.give-up.really-member-text');
  String get givenUpTitle => LangCont.tr('$_dialogTr.give-up.given-up-title');
  String get givenUpText => LangCont.tr('$_dialogTr.give-up.given-up-text');
  String get removedTitle => LangCont.tr('$_dialogTr.give-up.removed-title');
  String get removedText => LangCont.tr('$_dialogTr.give-up.removed-text');

  bool get isLeader => party?.leaderUid == _logged.key;
  bool get isOnly => party?.memberUids.length == 1;

  void giveUpButtonPressed() {
    String text = reallyGiveUpMemberText;
    if (isLeader) text = reallyGiveUpLeaderText;
    if (isOnly) text = reallyGiveUpOnlyText;

    showFDialog(
      title: reallyGiveUpTitle,
      content: FTexts(
        text,
        style: FTheme.titleSmall,
        highlightStyle: FTheme.bodyLarge
            ?.copyWith(color: FTheme.comment),
        wordWrap: true,
      ),
      type: DialogType.bi,
      rightText: giveUpText,
      rightTextColor: FTheme.achro95,
      rightBackgroundColor: FTheme.error,
      rightPressed: _giveUpParty,
    );
  }

  void _giveUpParty() async {
    String title = givenUpTitle;
    String text = givenUpText;

    if (isOnly) {
      title = removedTitle;
      text = removedText;
    }

    await showFDialog(
      title: title,
      content: FText(text, maxLines: 0),
      type: DialogType.mono,
    );

    _logged.party!.removeParty(party!.key);

    if (isOnly) {
      for (FUser applicant in party!.applicants.values) {
        applicant.party!.removeFromAppliedParties(party!.key);
        await FUserPartyDAO().saveOne(applicant.party!);
      }
      await PartyDAO().removeOne(party!);
    }
    else {
      if (isLeader) { party!.delegateLeaderToBestMember(); }
      await party!.removeMember(_logged.key);
    }

    await PartyDAO().saveOne(party!);
    await FUserPartyDAO().saveOne(_logged.party!);

    FRoute.toContents();
    FRoute.toChallenge();
  }

  String get applyButtonText => LangCont.tr('button.apply');
  String get cancelButtonText => LangCont.tr('button.cancel');
  String get reallyApplyTitle => LangCont.tr('$_dialogTr.apply.really-title');
  String get reallyApplyText => LangCont.tr(
    '$_dialogTr.apply.really-text',
    namedArgs: {'party-title': party!.title},
  );
  String get appliedTitle => LangCont.tr('$_dialogTr.apply.applied-title');
  String get appliedText => LangCont.tr('$_dialogTr.apply.applied-text');

  String get canceledTitle => LangCont.tr('$_dialogTr.apply.canceled-title');
  String get canceledText => LangCont.tr('$_dialogTr.apply.canceled-text');

  String get disabledTitle => LangCont.tr('$_dialogTr.apply.disabled-title');
  String get disabledText => LangCont.tr('$_dialogTr.apply.disabled-text');

  bool get hasSameTypeOfAppliedParty {
    return _logged.party!.hasAppliedPartyOf(party!.type);
  }

  void applyButtonPressed() {
    showFDialog(
      title: reallyApplyTitle,
      content: FTexts(
        reallyApplyText,
        style: FTheme.titleSmall,
        highlightStyle: FTheme.titleSmall
            ?.copyWith(color: partyColor),
        wordWrap: true,
      ),
      type: DialogType.bi,
      rightPressed: _apply,
    );
  }

  void _apply() async {
    await showFDialog(
      title: appliedTitle,
      content: FText(appliedText, maxLines: 0),
      type: DialogType.mono,
      rightPressed: Get.back,
    );

    party!.apply(_logged);
    await PartyDAO().saveOne(party!);

    _logged.party!.addToAppliedParties(party!);
    await FUserPartyDAO().saveOne(_logged.party!);

    await onRefresh();
  }

  void cancelButtonPressed() => cancel();

  void cancel() async {
    await showFDialog(
      title: canceledTitle,
      content: FText(canceledText, maxLines: 0),
      type: DialogType.mono,
    );

    party!.cancel(_logged);
    PartyDAO().saveOne(party!);

    _logged.party!.removeFromAppliedParties(party!.key);
    FUserPartyDAO().saveOne(_logged.party!);

    await onRefresh();
  }

  void disabledButtonPressed() {
    showFDialog(
      title: disabledTitle,
      content: FText(disabledText, maxLines: 0),
      type: DialogType.mono,
    );
  }

  void memberTilePressed(FUser member) {
    showMemberChart(member);
  }

  final _chartDataOfMembers = <String, List<ChartData>>{}.obs;
  Map<String, List<ChartData>> get chartDataOfMembers => _chartDataOfMembers;

  List<ChartData> _getChartData(FUser member) {
    List<ChartData>? data = chartDataOfMembers[member.key];
    if (data != null) return data;

    List<ChartData> list = [];

    DateTime startDate = party!.startDate!;
    DateTime endDate = party!.endDate!;

    DateRange range = DateRange(startDate, endDate);

    for (DateTime date in range.dates) {
      num amount = member.getOneDayRecord(date)[party!.type]!;
      list.add(ChartData(date, amount));
    }

    _chartDataOfMembers[member.key] = [...list];

    return list;
  }

  String get pokeButtonText => LangCont.tr('button.poke');

  void showMemberChart(FUser member) async {
    String format = '{value}';
    num Function(num) mapper = (num value) => value;
    if (party!.type == FType.distance) {
      format = '{value}K';
      mapper = (num value) => value / 1000;
    }

    DialogType dialogType = DialogType.mono;
    String? leftText;

    bool canDelegate = isLeader && member.key != _logged.key;

    if (canDelegate) {
      dialogType = DialogType.bi;
      leftText = pokeButtonText;
    }

    showFDialog(
      title: member.nickname,
      content: SizedBox(
        height: PageCont.size.height * .2,
        child: SfCartesianChart(
          primaryXAxis: CategoryAxis(
            majorGridLines: const MajorGridLines(width: 0),
            labelStyle: FTheme.bodyMedium?.copyWith(color: FTheme.comment),
            interval: 2,
          ),
          primaryYAxis: NumericAxis(
            labelStyle: FTheme.bodyMedium?.copyWith(color: FTheme.comment),
            labelFormat: format,
          ),
          series: <ChartSeries>[
            BarSeries<ChartData, String>(
              dataSource: _getChartData(member),
              animationDuration: 500,
              xValueMapper: (data, _) => '${data.x.day}',
              yValueMapper: (data, _) => mapper(data.y),
              color: party!.type.color,
            ),
          ],
          isTransposed: true,
        ),
      ),
      type: dialogType,
      leftText: leftText,
      leftPressed: () => pokeButtonPressed(member),
    );
  }

  void pokeButtonPressed(FUser member) {}

  int get point {
    return (getMemberPercent(_logged.key) * party!.point).round();
  }

  void memberSettingButtonPressed() {
    FRoute.toPartyMemberSetting(party: party);
  }

  FUser get _logged => AuthCont.logged!;

  @override
  String get loadKey => 'party';

}