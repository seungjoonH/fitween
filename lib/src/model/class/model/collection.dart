import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitween/global/date.dart';
import 'package:fitween/src/model/class/local.dart';
import 'package:fitween/src/model/class/local/badge.dart';
import 'package:fitween/src/model/class/model.dart';

class Collection extends Model {
  List<Timestamp> _dateList = [];
  late String _badgeId;

  late FBadge _badge;

  Collection.fromJson(super.json) : super.fromJson();

  set dates(List<DateTime?> dates)  => dates.map((date) => date?.toTimestamp).toList();
  List<DateTime?> get dates => _dateList.map((date) => date.toDate()).toList();

  @override
  void fromJson(Map<String, dynamic> json) {
    _dateList = json['dates'].cast<Timestamp>();
    _badgeId = json['badgeId'];
    _badge = FBadgeLocal().get(_badgeId)!;
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['dates'] = _dateList;
    json['badgeId'] = _badgeId;
    return json;
  }

  @override
  String get key => _badgeId;


}