/* 사용자 모델 프리젠터 */
import 'package:fitween/model/class/database/user/notification.dart';
import 'package:fitween/presenter/model/user/collection.dart';
import 'package:fitween/presenter/model/user/info.dart';
import 'package:get/get.dart';
import 'package:fitween/presenter/firebase/firebase.dart';

/// class
// 사용자 객체 관련
class UserNotificationP extends GetxController {
  /// static variables
  static get collection => f.collection('userNotifications');
  static get doc {
    final userP = Get.find<UserNotificationP>();
    return collection.doc(userP.loggedUser.uid);
  }

  /// static methods
  static Future<FUserNotification?> loadUser(String uid) async {
    var json = (await collection.doc(uid).get()).data();
    if (json == null) return null;
    return FUserNotification.fromJson(json);
  }

  static void saveUser(FUserNotification user) async {
    collection.doc(user.uid).set(user.toJson());
  }

  /// attributes
  /* 로그인 관련 */
  // 현재 로그인된 사용자
  FUserNotification loggedUser = FUserNotification();

  // 로그인 여부
  bool get isLogged => loggedUser.uid != null;

  /// methods
  /* 로그인 관련 */
  // 로그인
  // 매개변수로 받은 사용자 정보와 User Credential 정보를 병합하여 현재 로그인된 사용자자 최신화
  Future login(FUserNotification user) async {
    Map<String, dynamic> json = user.toJson();
    loggedUser = FUserNotification.fromJson(json);
    save();
  }

  // 로그아웃
  // 현재 로그인된 사용자 정보 초기화
  void logout() => loggedUser = FUserNotification();

  /* 파이어베이스 관련 */
  // 파이어베이스에서 로드
  Future load() async {
    var json = (await collection
        .doc(loggedUser.uid).get()).data();
    if (json == null) return;
    loggedUser = FUserNotification.fromJson(json);
  }

  // 파이어베이스에 최신화
  void save() => collection
      .doc(loggedUser.uid)
      .set(loggedUser.toJson());

  // 파이어베이스에서 삭제
  void delete() => collection
      .doc(loggedUser.uid).delete();

  Future addNotification(
    String notifyingUid,
    String notifiedUid, [
      bool isRival = false,
  ]) async {
    FUserNotification? user = await UserNotificationP.loadUser(notifiedUid);
    String? nickname = Get.find<UserInfoP>().loggedUser.nickname;
    String? badgeId = Get.find<UserCollectionP>().loggedUser.badgeId;

    if (user == null || nickname == null) return;
    user.addNotification(notifyingUid, nickname, badgeId, isRival);
    UserNotificationP.saveUser(user);
  }

  void deleteNotification(
    String notifyingUid,
    String notifiedUid, [
      bool isRival = false,
  ]) async {
    FUserNotification? user = await UserNotificationP.loadUser(notifiedUid);
    if (user == null) return;
    user.deleteNotification(notifyingUid, isRival);
    UserNotificationP.saveUser(user);

    if (notifiedUid != loggedUser.uid) return;
    loggedUser.deleteNotification(notifyingUid, isRival);
  }

  void checkAllNotifications([bool isRival = false]) async {
    await load();
    loggedUser.checkAllNotifications(isRival);
    save();
  }
}
