import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitween/global/date.dart';
import 'package:fitween/model/class/json/badge.dart';
import 'package:fitween/presenter/model/badge.dart';

class Collection {
  /// attributes
  // 일반 변수
  List<Timestamp> dateList = [];
  String? badgeId;

  // 의존 변수
  FBadge? badge; // badgeId 에 의존

  set dates(List<DateTime?> dates) => dates.map((date) => toTimestamp(date)).toList();
  List<DateTime?> get dates => dateList.map((date) => date.toDate()).toList();

  void addDate(DateTime date) => dateList.add(toTimestamp(date)!);

  Collection();

  Collection.fromJson(Map<String, dynamic> json) {
   fromJson(json);
  }

  void fromJson(Map<String, dynamic> json) {
    dateList = json['dates'].cast<Timestamp>();
    badgeId = json['badgeId'];
    badge = BadgePresenter.getBadge(badgeId!);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['dates'] = dateList;
    json['badgeId'] = badgeId;
    return json;
  }
}