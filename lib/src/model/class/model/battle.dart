import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitween/global/date.dart';
import 'package:fitween/global/number.dart';
import 'package:fitween/src/model/class/model.dart';
import 'package:get/get.dart';

class Battle extends Model {
  late String _id;
  late Timestamp _genDate;
  Map<String, _BattleData> _data = {};
  bool? _applied;

  List<String> get memberUids => _data.keys.toList();
  List<FUser> members = [];

  DateTime get genDate => _genDate.toDate();
  set genDate(DateTime date) => _genDate = date.toTimestamp!;

  List<num> getAttempts(String uid) => _data[uid]!._attempts;
  num getMaxAttempt(String uid) => _data[uid]!._maxAttempts;

  int get _compareAttempts {
    num first = _data.values.first._maxAttempts;
    num second = _data.values.last._maxAttempts;
    return (first - second).sign.toInt();
  }

  String? get _winnerUid {
    if (isDraw) return null;
    return _data.keys.elementAt(_compareAttempts > 0 ? 1 : 0);
  }
  String? get _loserUid {
    if (isDraw) return null;
    return _data.keys.elementAt(_compareAttempts < 0 ? 1 : 0);
  }
  FUser? get winner => members.firstWhereOrNull((user) => user.key == _winnerUid);
  FUser? get loser => members.firstWhereOrNull((user) => user.key == _loserUid);
  bool get isDraw => _compareAttempts == 0;

  bool get memberLoaded {
    return members.where((u) => u.battle != null).length == memberUids.length;
  }

  Battle.fromJson(super.json) : super.fromJson();

  @override
  void fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _genDate = json['genDate'];
    _data = json['data']?.map<String, _BattleData>((id, json) {
      return MapEntry<String, _BattleData>(id, _BattleData.fromJson(json));
    }) ?? {};
    _applied = json['applied'];
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = _id;
    json['genDate'] = _genDate;
    json['data'] = _data
        .map((uid, battleData) => MapEntry(uid, battleData.toJson()));
    json['applied'] = _applied;
    return json;
  }

  @override
  String get key => _id;
}

class _BattleData extends Model {
  late List<num> _attempts = [];
  late num _chance;

  num get _maxAttempts => maxOfList(_attempts);

  _BattleData.fromJson(super.json) : super.fromJson();
  @override
  void fromJson(Map<String, dynamic> json) {
    _attempts = json['attempts'].cast<num>();
    _chance = json['chance'];
  }
  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['attempts'] = _attempts;
    json['chance'] = _chance;
    return json;
  }

  @override
  String get key => '';
}