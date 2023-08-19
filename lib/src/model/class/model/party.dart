import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitween/global/date.dart';
import 'package:fitween/src/model/class/local/challenge.dart';
import 'package:fitween/src/model/class/model.dart';
import 'package:fitween/src/model/enum/ftype.dart';

enum Difficulty {
  easy, normal, hard;
  String get kr => ['쉬움', '보통', '어려움'][index];
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
  List<FUser> members = [];

  String get leaderUid => _leaderUid;
  List<String> get memberUids => _memberUids;
  DateTime? get startDate => _startDate?.toDate();
  DateTime? get endDate => _endDate?.toDate();
  set startDate(DateTime? date) => _startDate = date?.toTimestamp;
  set endDate(DateTime? date) => _endDate = date?.toTimestamp;

  Challenge? get challenge => ChallengeLocal().get(_challengeId);
  FType get type => challenge!.type;

  bool get memberLoaded {
    return members.where((u) => u.party != null).length == memberUids.length;
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
    json['difficulty'] = _difficulty;
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