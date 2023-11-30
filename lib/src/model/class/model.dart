export './model/badge.dart';
export './model/battle.dart';
export './model/challenge.dart';
export './model/collection.dart';
export './model/item.dart';
export './model/party.dart';
export './model/level.dart';
export './model/notice.dart';
export './model/report.dart';
export './model/user.dart';
export './model/user/battle.dart';
export './model/user/collection.dart';
export './model/user/friend.dart';
export './model/user/info.dart';
export './model/user/notification.dart';
export './model/user/party.dart';
export './model/user/point.dart';
export './model/user/record.dart';

abstract class Model {
  String get key;
  Model();
  Model.fromJson(Map<String, dynamic> json) { fromJson(json); }
  void fromJson(Map<String, dynamic> json);
  Map<String, dynamic> toJson();
}