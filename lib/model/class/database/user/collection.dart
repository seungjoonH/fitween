/* 사용자 모델 구조 */

import 'package:fitween/presenter/model/user/collection.dart';
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
  // 대표 컬렉션
  Collection? get collection => collections
      .firstWhereOrNull((collection) => collection.badgeId == badgeId);

  List<Collection> get orderedCollections {
    List<Collection> cols = [...collections];
    cols.sort((a, b) {
      DateTime aDate = a.dates.last!;
      DateTime bDate = b.dates.last!;
      if (aDate.isAtSameMomentAs(bDate)) return 0;
      return aDate.isBefore(bDate) ? 1 : -1;
    });
    return cols;
  }

  List<Collection> get recentCollections {
    List<Collection> cols = collections.where(
            (element)=>element.dates.last!.compareTo(now.subtract(const Duration(days: 7))) > 0).toList();

    cols.sort((a, b) {
      DateTime aDate = a.dates.last!;
      DateTime bDate = b.dates.last!;
      if (aDate.isAtSameMomentAs(bDate)) return 0;
      return aDate.isBefore(bDate) ? 1 : -1;
    });
    return cols;
  }

  List<Collection> get dailyCollections {
    List<Collection> cols = collections.where(
            (element)=>element.badgeId!.compareTo('1050000') < 0).toList();

    cols.sort((a, b) {
      String? aId = a.badgeId;
      String? bId = b.badgeId;
      return aId!.compareTo(bId!);
    });
    return cols;
  }

  List<Collection> get challengeCollections {
    List<Collection> cols = collections.where(
            (element)=>element.badgeId!.compareTo('1050000') >= 0).toList();

    cols.sort((a, b) {
      String? aId = a.badgeId;
      String? bId = b.badgeId;
      return aId!.compareTo(bId!);
    });
    return cols;
  }

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
