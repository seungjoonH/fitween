/* 사용자 모델 프리젠터 */
import 'package:fitween/model/class/database/user/info.dart';
import 'package:get/get.dart';
import 'package:fitween/presenter/firebase/firebase.dart';

/// class
// 사용자 객체 관련
class UserInfoP extends GetxController {
  /// static variables
  static get collection => f.collection('userInfos');

  /// static methods
  static Future<String?> loadUidByNickname(String nickname) async {
    var jsonList = await collection.get();
    for (var json in jsonList.docs) {
      var data = json.data();
      if (data['nickname'] == nickname) return data['uid'];
    }
    return null;
  }

  static Future<FUserInfo?> loadUser(String uid) async {
    var json = (await collection.doc(uid).get()).data();
    if (json == null) return null;
    return FUserInfo.fromJson(json);
  }

  static void saveUser(FUserInfo user) async {
    collection.doc(user.uid).set(user.toJson());
  }

  static Future<bool> duplicatedNickname(String nickname) async {
    var jsonList = await collection.get();

    for (var json in jsonList.docs) {
      var data = json.data();
      if (data['nickname'] == nickname) return true;
    }

    return false;
  }

  /// attributes
  /* 로그인 관련 */
  // User Credential 정보
  Map<String, dynamic> data = {};

  // 현재 로그인된 사용자
  FUserInfo loggedUser = FUserInfo();

  /// methods
  /* 로그인 관련 */
  // 로그인
  // 매개변수로 받은 사용자 정보와 User Credential 정보를 병합하여 현재 로그인된 사용자자 최신화
  Future login(FUserInfo user) async {
    Map<String, dynamic> json = user.toJson();
    data.forEach((key, value) => json[key] = value);
    loggedUser = FUserInfo.fromJson(json);
    save();
  }

  // 로그아웃
  // 현재 로그인된 사용자 정보 초기화
  void logout() => loggedUser = FUserInfo();

  /* 파이어베이스 관련 */
  // 파이어베이스에서 로드
  Future load() async {
    var json = (await collection
        .doc(loggedUser.uid).get()).data();
    if (json == null) return;
    loggedUser = FUserInfo.fromJson(json);
  }

  // 파이어베이스에 최신화
  void save() => collection
      .doc(loggedUser.uid)
      .set(loggedUser.toJson());

  // 파이어베이스에서 삭제
  void delete() => collection
      .doc(loggedUser.uid).delete();

}
