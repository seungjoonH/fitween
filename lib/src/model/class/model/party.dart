import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitween/global/global.dart';
import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/model/class/amount/amount.dart';
import 'package:fitween/src/model/class/dao.dart';
import 'package:fitween/src/model/class/local/challenge.dart';
import 'package:fitween/src/model/class/model.dart';
import 'package:fitween/src/model/enum/ftype.dart';

enum Difficulty {
  easy, normal, hard;
  String get locale => LangCont.tr('difficulty.$name');
  bool get active => activeValues.contains(this);

  static Difficulty toEnum(String string) =>
      Difficulty.values.firstWhere((diff) => diff.name == string);

  static List<Difficulty> get activeValues => [easy, normal, hard];
}

class Party extends Model {
  late String _id;
  late String _challengeId;
  Difficulty _difficulty = Difficulty.easy;
  List<String> _memberUids = [];
  late String _leaderUid;
  bool _complete = false;
  Timestamp? _startDate;
  Timestamp? _endDate;

  late FUser leader;
  Map<String, FUser> members = {};

  Difficulty get difficulty => _difficulty;

  String get leaderUid => _leaderUid;
  List<String> get memberUids => _memberUids;
  DateTime? get startDate => _startDate?.toDate();
  DateTime? get endDate => _endDate?.toDate();
  set startDate(DateTime? date) => _startDate = date?.toTimestamp;
  set endDate(DateTime? date) => _endDate = date?.toTimestamp;

  Challenge? get challenge => ChallengeLocal().get(_challengeId);
  FType get type => challenge!.type;

  String get detailDescription => challenge!
      .getDetailDescription(difficulty: _difficulty);
  String get completeDescription => challenge!
      .getCompleteDescription(difficulty: _difficulty);

  int get leftDays => now.difference(endDate!).inDays;
  String get deadline => 'D${withSign(leftDays)}';
  bool get completed => allAmounts >= goal;
  bool get over => endDate!.isBefore(now);

  int get memberCount => members.length;
  int get maxMemberCount => challenge!.getMaxMemberCount(_difficulty);

  Future loadMembers() async {
    FUserLoadCont cont = FUserLoadCont(collection: true, record: true);
    for (String uid in memberUids) {
      if (uid == AuthCont.uid) { members[uid] = AuthCont.logged!; continue; }
      FUser? loaded = await FUserDAO().loadOne(uid, cont: cont);
      if (loaded == null) throw Exception('[ERROR] User($uid) load failed');
      members[uid] = FUser.combine(members[uid], loaded);
    }
  }

  num getAmounts(String uid) {
    FUser? member = members[uid];
    if (member == null) return .0;
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

  Party({
    required String challengeId,
    required Difficulty difficulty,
    required this.leader,
  }) {
    _id = _randomCode;
    _challengeId = challengeId;
    _difficulty = difficulty;
    _leaderUid = leader.key;
    _memberUids.add(leaderUid);
    members[leader.key] = leader;
    startDate = today;
    endDate = today.add(challenge!.period.d);
  }

  Party.fromJson(Map<String, dynamic> json) {
    fromJson(json);
  }

  @override
  void fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _challengeId = json['challengeId'];
    _difficulty = Difficulty.toEnum(json['difficulty']);
    _memberUids = json['memberUids'].cast<String>();
    _leaderUid = json['leaderUid'];
    _complete = json['complete'];
    _startDate = json['startDate'];
    _endDate = json['endDate'];
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = _id;
    json['challengeId'] = _challengeId;
    json['difficulty'] = _difficulty.name;
    json['memberUids'] = _memberUids;
    json['leaderUid'] = _leaderUid;
    json['complete'] = _complete;
    json['startDate'] = _startDate;
    json['endDate'] = _endDate;
    return json;
  }

  @override
  String get key => _id;
}