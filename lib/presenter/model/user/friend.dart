/* 사용자 모델 프리젠터 */
import 'package:fitween/model/class/database/user/collection.dart';
import 'package:fitween/model/class/database/user/friend.dart';
import 'package:fitween/model/class/database/user/info.dart';
import 'package:fitween/presenter/model/user/collection.dart';
import 'package:fitween/presenter/model/user/info.dart';
import 'package:get/get.dart';
import 'package:fitween/presenter/firebase/firebase.dart';

/// class
// 사용자 객체 관련
class UserFriendP extends GetxController {
  /// static variables
  static get collection => f.collection('userFriends');

  /// static methods
  static Future<FUserFriend?> loadUser(String uid) async {
    var json = (await collection.doc(uid).get()).data();
    if (json == null) return null;
    return FUserFriend.fromJson(json);
  }

  static void saveUser(FUserFriend user) async {
    collection.doc(user.uid).set(user.toJson());
  }

  static bool doesFriendExist(String nickname) {
    final userFriendP = Get.find<UserFriendP>();
    return userFriendP.loggedUser.doesFriendExist(nickname);
  }

  /// attributes
  /* 로그인 관련 */
  // User Credential 정보
  Map<String, dynamic> data = {};

  // 현재 로그인된 사용자
  FUserFriend loggedUser = FUserFriend();

  // 로그인 여부
  bool get isLogged => loggedUser.uid != null;

  /// methods
  /* 로그인 관련 */
  // 로그인
  // 매개변수로 받은 사용자 정보와 User Credential 정보를 병합하여 현재 로그인된 사용자자 최신화
  Future login(FUserFriend user) async {
    Map<String, dynamic> json = user.toJson();
    data.forEach((key, value) => json[key] = value);
    loggedUser = FUserFriend.fromJson(json);
    save();
  }

  // 로그아웃
  // 현재 로그인된 사용자 정보 초기화
  void logout() => loggedUser = FUserFriend();

  /* 파이어베이스 관련 */
  // 파이어베이스에서 로드
  Future load() async {
    var json = (await collection
        .doc(loggedUser.uid).get()).data();
    if (json == null) return;
    loggedUser = FUserFriend.fromJson(json);
  }

  // 파이어베이스에 최신화
  void save() => collection
      .doc(loggedUser.uid)
      .set(loggedUser.toJson());

  // 파이어베이스에서 삭제
  void delete() => collection
      .doc(loggedUser.uid).delete();


  void addFriend(String uid) {
    loggedUser.addFriend(uid);
    save(); update();
  }

  void deleteFriend(String uid) {
    loggedUser.deleteFriend(uid);
    save(); update();
  }

  Future loadFriends() async {
    loggedUser.friendInfos = [];
    loggedUser.friendCollections = [];
    for (String uid in loggedUser.friendUids) {
      FUserInfo? userInfo = await UserInfoP.loadUser(uid);
      FUserCollection? userCollection = await UserCollectionP.loadUser(uid);
      if (userInfo == null) return;
      if (userCollection == null) return;
      loggedUser.friendInfos.add(userInfo);
      loggedUser.friendCollections.add(userCollection);
    }
    update();
  }
}
