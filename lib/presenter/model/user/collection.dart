import 'package:fitween/global/date.dart';
import 'package:fitween/model/class/database/collection.dart';
import 'package:fitween/model/class/database/user/collection.dart';
import 'package:fitween/model/class/json/badge.dart';
import 'package:fitween/presenter/firebase/firebase.dart';
import 'package:fitween/presenter/global.dart';
import 'package:get/get.dart';

class UserCollectionP extends GetxController {
  static get collection => f.collection('userCollections');

  /// static methods
  static Future<FUserCollection?> loadUser(String uid) async {
    var json = (await collection.doc(uid).get()).data();
    if (json == null) return null;
    return FUserCollection.fromJson(json);
  }

  static void saveUser(FUserCollection user) async {
    collection.doc(user.uid).set(user.toJson());
  }

  static List<Collection> toCollections(List<Map<String, dynamic>> jsonList) {
    List<Collection> collections = [];
    for (var json in jsonList) { collections.add(Collection.fromJson(json)); }
    return collections;
  }

  static List<Map<String, dynamic>> collectionsToJsonList(List<Collection> collections) {
    List<Map<String, dynamic>> jsonList = [];
    for (Collection collection in collections) { jsonList.add(collection.toJson()); }
    return jsonList;
  }

  /// attributes
  /* 로그인 관련 */
  // User Credential 정보
  Map<String, dynamic> data = {};

  // 현재 로그인된 사용자
  FUserCollection loggedUser = FUserCollection();

  /// methods
  /* 로그인 관련 */
  // 로그인
  // 매개변수로 받은 사용자 정보와 User Credential 정보를 병합하여 현재 로그인된 사용자자 최신화
  Future login(FUserCollection user) async {
    Map<String, dynamic> json = user.toJson();
    data.forEach((key, value) => json[key] = value);
    loggedUser = FUserCollection.fromJson(json);
    save();
  }

  // 로그아웃
  // 현재 로그인된 사용자 정보 초기화
  void logout() => loggedUser = FUserCollection();

  /* 파이어베이스 관련 */
  // 파이어베이스에서 로드
  Future load() async {
    var json = (await collection
        .doc(loggedUser.uid).get()).data();
    if (json == null) return;
    loggedUser = FUserCollection.fromJson(json);
  }

  // 파이어베이스에 최신화
  void save() => collection
      .doc(loggedUser.uid)
      .set(loggedUser.toJson());

  // 파이어베이스에서 삭제
  void delete() => collection
        .doc(loggedUser.uid).delete();

  void setMainBadge(String badgeId, [bool showDialog = true]) {
    loggedUser.badgeId = badgeId;
    if (!showDialog) return;
    GlobalPresenter.showCollectionSettingDialog(badgeId);
    save(); update();
  }

  // 로그인된 사용자에게 뱃지 수여
  void awardBadge(FBadge badge, [
    bool once = false,
    bool aDay = false,
  ]) async {
    assert(once || !aDay);

    for (Collection collection in loggedUser.collections) {
      if (collection.badgeId != badge.id) continue;

      bool awarded = collection.dates.isNotEmpty;
      bool awardedToday = collection.dates
          .map((date) => ignoreTime(date!)).contains(today);

      if (once) {
        if (aDay && awardedToday) return;
        if (!aDay && awarded) return;
      }

      GlobalPresenter.showAwardedBadgeDialog(badge);
      collection.addDate(now);
      return;
    }

    GlobalPresenter.showAwardedBadgeDialog(badge, true);
    if (badge.id == '1000000') setMainBadge(badge.id!, false);
    if (badge.id == '1999999') setMainBadge(badge.id!, false);

    loggedUser.collections.add(Collection.fromJson({
      'badgeId': badge.id,
      'dates': [toTimestamp(now)],
    }));

    save();
    update();
  }
}