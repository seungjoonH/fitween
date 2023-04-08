/* 사용자 모델 구조 */

import 'package:fitween/model/enum/activity_type.dart';
import 'package:fitween/presenter/model/user/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fitween/global/date.dart';
import 'package:fitween/model/class/database/collection.dart';

class FUserCollection {
  /// attributes
  // 일반 변수
  String? uid;
  String? badgeId;

  // 복합 변수
  List<Collection> collections = [];

  /// accessors & mutators
  Color get badgeColor => ActivityType.values[uid!.codeUnitAt(1) % 4].color;

  Collection? get collection => collections
      .firstWhereOrNull((collection) => collection.badgeId == badgeId);

  List<Collection> get orderedCollections {
    List<Collection> cols = [...collections];
    cols.sort((a, b) => a.dates.last!.isBefore(b.dates.last!) ? 1 : -1);
    return cols;
  }

  List<Collection> get normalCollections => orderedCollections
        .where((collection) => collection.badgeId!.substring(0, 2) == '100').toList();

  List<Collection> get distanceCollections => orderedCollections
      .where((collection) => collection.badgeId!.substring(0, 2) == '101').toList();

  List<Collection> get heightCollections => orderedCollections
      .where((collection) => collection.badgeId!.substring(0, 2) == '102').toList();

  List<Collection> get weightCollections => orderedCollections
      .where((collection) => collection.badgeId!.substring(0, 2) == '103').toList();


  Collection? getCollectionsById(String id) {
    return collections.firstWhereOrNull((col) => col.badgeId == id);
  }


  bool hasCollection(String id) => getCollectionsById(id) != null;

  int countCompletedDaysInARow(int days) {
    const String code = '1000001';
    List<DateTime?>? dates = getCollectionsById(code)?.dates;
    dates = dates?.map((date) => ignoreTime(date!)).toList();

    DateTime? before = dates?.last;
    dates = dates?.reversed.toList().sublist(1);
    int continuous = 1, count = 0;

    for (DateTime? date in dates ?? []) {
      if (before!.difference(date!) != const Duration(days: 1)) break;
      before = date; continuous++;
      if (continuous < days) continue;
      continuous = 0; count++;
    }

    return count;
  }

  /// constructors
  FUserCollection();

  FUserCollection.fromJson(Map<String, dynamic> json) {
    fromJson(json);
  }

  /// methods
  void fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    badgeId = json['badgeId'];
    collections = UserCollectionP
        .toCollections((json['collections'] ?? [])
        .cast<Map<String, dynamic>>());
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['uid'] = uid;
    json['badgeId'] = badgeId;
    json['collections'] = UserCollectionP
        .collectionsToJsonList(collections);
    return json;
  }
}
