import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitween/global/global.dart';
import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/model/class/amount/amount.dart';
import 'package:fitween/src/model/class/dao.dart';
import 'package:fitween/src/model/class/local/challenge.dart';
import 'package:fitween/src/model/class/model.dart';
import 'package:fitween/src/model/enum/ftype.dart';
import 'package:flutter/material.dart';

enum Difficulty {
  easy, normal, hard;
  String get locale => LangCont.tr('difficulty.$name');
  Color get color => [ThemeCont.bronze, ThemeCont.silver, ThemeCont.gold][index];
  bool get active => activeValues.contains(this);

  static Difficulty toEnum(String string) =>
      Difficulty.values.firstWhere((diff) => diff.name == string);

  static List<Difficulty> get activeValues => [easy, normal, hard];
}

class ApplicantData extends Model {
  late Timestamp _date;
  late bool _checked;

  DateTime get date => _date.toDate();
  set date(DateTime d) => _date = d.toTimestamp!;

  void check() => _checked = true;

  ApplicantData() { date = now; _checked = false; }
  ApplicantData.fromJson(super.json) : super.fromJson();

  @override
  void fromJson(Map<String, dynamic> json) {
    _date = json['date'];
    _checked = json['checked'];
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['date'] = _date;
    json['checked'] = _checked;
    return json;
  }

  @override
  String get key => throw UnimplementedError();
}

class Party extends Model {
  late String _id;
  late String _title;
  late String _challengeId;
  Difficulty _difficulty = Difficulty.easy;
  List<String> _memberUids = [];
  late String _leaderUid;
  String? _leaderNickname;
  bool _finished = false;
  Timestamp? _startDate;
  Timestamp? _endDate;
  Map<String, ApplicantData> _applicantsData = {};
  int? _views;

  late FUser leader;
  Map<String, FUser> members = {};
  Map<String, FUser> applicants = {};

  Difficulty get difficulty => _difficulty;

  String get title => _title;
  String get leaderUid => _leaderUid;
  List<String> get memberUids => _memberUids;
  DateTime? get startDate => _startDate?.toDate();
  DateTime? get endDate => _endDate?.toDate();
  set startDate(DateTime? date) => _startDate = date?.toTimestamp;
  set endDate(DateTime? date) => _endDate = date?.toTimestamp;
  int get views => _views ?? 0;

  void updateTitle(String title) => _title = title;

  Challenge? get challenge => ChallengeLocal().get(_challengeId);
  FType get type => challenge!.type;

  String get leaderNickname => _leaderNickname ?? '';

  String get detailDescription => challenge!
      .getDetailDescription(difficulty: _difficulty);
  String get completeDescription => challenge!
      .getCompleteDescription(difficulty: _difficulty);

  int get leftDays => now.difference(endDate!).inDays;
  String get deadline => 'D${withSign(leftDays)}';
  bool get completed => allAmounts >= goal;
  bool get over => endDate!.isBefore(now);
  bool get finished => completed || over;

  String get finishState => completed ? 'PASS' : 'FAIL';

  int get memberCount => members.length;
  int get maxMemberCount => challenge!.getMaxMemberCount(_difficulty);
  int get applicantCount => applicants.length;
  int get notCheckedApplicantCount {
    return _applicantsData.values.where((data) => !data._checked).length;
  }

  int get point => challenge!.getPoint(_difficulty);

  bool get isFull => memberUids.length == maxMemberCount;
  bool isMember(String uid) => memberUids.contains(uid);
  bool isApplied(String uid) => applicants.keys.contains(uid);

  Future loadMembers() async {
    FUserLoadCont cont = FUserLoadCont(
      record: true,
      collection: true,
      notification: true,
    );
    for (String uid in memberUids) {
      if (uid == AuthCont.uid) { members[uid] = AuthCont.logged!; continue; }
      FUser? loaded = await FUserDAO().loadOne(uid, cont: cont);
      if (loaded == null) throw Exception('[ERROR] User($uid) load failed');
      members[uid] = FUser.combine(members[uid], loaded);
    }
    leader = members[leaderUid]!;
    _leaderNickname = leader.nickname;
  }

  Future addMember(FUser user) async {
    memberUids.add(user.key);
    members[user.key] = user;
  }

  Future removeMember(String uid) async {
    memberUids.remove(uid);
    members.remove(uid);
  }

  num getAmounts(String uid) {
    FUser? member = members[uid];
    if (member == null) return .0;
    if (member.record == null) return .0;
    num value = member.getRecord(startDate!, endDate!)[type]!;
    if (type != FType.weight) return value;
    return (WeightAmount()..cnt = value).kg;
  }
  num get allAmounts => sum(members.keys.map((uid) => getAmounts(uid)));
  num get goal => challenge!.getGoal(_difficulty);
  double get percent => allAmounts / goal;

  static String get _randomCode {
    int length = 7;
    const String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890';
    return String.fromCharCodes(
      Iterable.generate(length, (_) => chars.codeUnitAt(
        Random().nextInt(chars.length),
      )),
    );
  }

  FUser? get bestMember {
    Map<String, num> amounts = { for (String uid in memberUids) uid : getAmounts(uid) };
    num maxValue = maxOfList(amounts.values);
    for (String uid in memberUids) { if (amounts[uid] == maxValue) return members[uid]!; }
    return null;
  }

  FUser? get bestMemberWithoutLeader {
    List<String> uids = [...memberUids]..remove(leaderUid);
    Map<String, num> amounts = { for (String uid in uids) uid : getAmounts(uid) };
    num maxValue = maxOfList(amounts.values);
    for (String uid in uids) { if (amounts[uid] == maxValue) return members[uid]!; }
    return null;
  }

  void delegateLeaderTo(String uid) {
    _leaderUid = uid;
    leader = members[uid]!;
    _leaderNickname = leader.nickname;
  }

  void delegateLeaderToBestMember() => delegateLeaderTo(bestMemberWithoutLeader!.key);


  bool get notCheckedApplicantsExist {
    return _applicantsData.values.where((data) => data._checked).isNotEmpty;
  }

  void checkAllApplicants() {
    for (var uid in _applicantsData.keys) { _applicantsData[uid]!.check(); }
  }

  void apply(FUser applicant) {
    _applicantsData[applicant.key] = ApplicantData();
    applicants[applicant.key] = applicant;
  }

  void cancel(FUser applicant) {
    _applicantsData.remove(applicant.key);
    applicants.remove(applicant.key);
  }

  void view(String uid) async {
    if (isMember(uid)) return;
    int value = _views ?? 0; _views = ++value;
    await PartyDAO().saveOne(this);
  }

  Future loadApplicants() async {
    FUserLoadCont cont = FUserLoadCont(
      party: true,
      collection: true,
      notification: true,
    );
    for (var uid in _applicantsData.keys) {
      FUser? loaded = await FUserDAO().loadOne(uid, cont: cont);
      if (loaded == null) throw Exception('[ERROR] User($uid) load failed');
      applicants[uid] = loaded;
    }
  }

  void removeApplicant(String uid) async {
    _applicantsData.remove(uid);
    applicants.remove(uid);
  }

  Future finish() async {
    _finished = true;
    if (members.isEmpty) await loadMembers();
    for (FUser member in members.values) {
      member.party = await FUserPartyDAO().loadOne(member.key);
      member.party!.finishParty(this);
      await FUserPartyDAO().saveOne(member.party!);
    }
  }

  Party({
    required String title,
    required String challengeId,
    required Difficulty difficulty,
    required this.leader,
  }) {
    _id = _randomCode;
    _title = title;
    _challengeId = challengeId;
    _difficulty = difficulty;
    _leaderUid = leader.key;
    _leaderNickname = leader.nickname;
    _memberUids.add(leaderUid);
    members[leader.key] = leader;
    startDate = today;
    endDate = today.add(challenge!.period.d);
  }

  Party.fromJson(super.json) : super.fromJson();

  @override
  void fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _challengeId = json['challengeId'];
    _title = json['title'] ?? challenge!.title;
    _difficulty = Difficulty.toEnum(json['difficulty']);
    _memberUids = json['memberUids'].cast<String>();
    _leaderUid = json['leaderUid'];
    _leaderNickname = json['leaderNickname'];
    _finished = json['finished'] ?? false;
    _startDate = json['startDate'];
    _endDate = json['endDate'];
    _applicantsData = Map.fromIterables(
      json['applicantsData']?.keys ?? [],
      json['applicantsData']?.values.map<ApplicantData>((data) => ApplicantData.fromJson(data)).toList() ?? [],
    );
    _views = json['views'];
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = _id;
    json['challengeId'] = _challengeId;
    json['title'] = _title;
    json['difficulty'] = _difficulty.name;
    json['memberUids'] = _memberUids;
    json['leaderUid'] = _leaderUid;
    json['leaderNickname'] = _leaderNickname;
    json['finished'] = _finished;
    json['startDate'] = _startDate;
    json['endDate'] = _endDate;
    json['applicantsData'] = Map.fromIterables(
      _applicantsData.keys,
      _applicantsData.values.map((data) => data.toJson()),
    );
    json['views'] = _views;
    return json;
  }

  @override
  String get key => _id;
}