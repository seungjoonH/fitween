import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitween/global/date.dart';
import 'package:fitween/global/number.dart';
import 'package:fitween/model/class/database/user/collection.dart';
import 'package:fitween/model/class/database/user/info.dart';

class Battle {
  String? id;
  Timestamp? _genDate;
  Map<String, dynamic> data = {};
  bool? applied;

  Map<String, FUserInfo> memberInfos = {};
  Map<String, FUserCollection> memberCollections = {};

  DateTime? get genDate => _genDate?.toDate();
  set genDate(DateTime? date) => _genDate = toTimestamp(date);

  bool get expired => nextDay(genDate!).isBefore(now);
  bool get finished => sum(chances) == 0 || expired;

  FUserInfo? get winnerInfo {
    List<String> uids = memberInfos.keys.toList();
    String? winnerUid;
    if (getMaxCount(uids[0]) < getMaxCount(uids[1])) { winnerUid = uids[1]; }
    if (getMaxCount(uids[0]) > getMaxCount(uids[1])) { winnerUid = uids[0]; }
    return memberInfos[winnerUid];
  }

  FUserInfo? get loserInfo {
    if (winnerInfo == null) return null;
    return memberInfos.values.firstWhere((info) => info.uid != winnerInfo!.uid);
  }

  bool won(String uid) => winnerInfo?.uid! == uid;
  bool defeated(String uid) => loserInfo?.uid! == uid;
  bool get tied => winnerInfo == null;

  Battle();

  Battle.fromJson(Map<String, dynamic> json) {
    fromJson(json);
  }

  void fromJson(Map<String, dynamic> json) {
    id = json['id'];
    _genDate = json['genDate'];
    data = json['data'] ?? {};
    applied = json['applied'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = id;
    json['genDate'] = _genDate;
    json['data'] = data;
    json['applied'] = applied;
    return json;
  }

  void complete(String uid, int count) {
    List<int> counts = (data[uid]['attempts'] ?? [0]).cast<int>();
    counts.add(count);
    data[uid]['attempts'] = counts;
  }

  int getRemainChance(String uid) => data[uid]['chance'];
  List<int> getAttempts(String uid) {
    return (data[uid]['attempts'] ?? [0]).cast<int>();
  }

  int getMaxCount(String uid) {
    List<int> list = (data[uid]['attempts'] ?? [0]).cast<int>();
    if (list.isEmpty) return 0;
    if (list.length == 1) return list.first;
    return max(list.first, list.last);
  }

  List<int> get chances => [
    for (var datum in data.values) datum['chance']
  ];

  void reduceChance(String uid) => data[uid]['chance']--;

  void apply() => applied = true;
}