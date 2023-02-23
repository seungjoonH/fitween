/* 사용자 모델 구조 */

import 'package:fitween/model/class/database/user/collection.dart';
import 'package:fitween/model/class/database/user/info.dart';

class FUserFriend {
  /// attributes
  // 일반 변수
  String? uid;

  // 복합 변수
  Map<String, dynamic> friendsData = {};

  // 의존 변수
  List<FUserInfo> friendInfos = [];
  List<FUserCollection> friendCollections = [];

  /// accessors & mutators
  List<String> get friendUids => friendsData.keys.toList();
  List<String> get rivalUids => rivalInfos.map((user) => user.uid!).toList();

  List<FUserInfo> get rivalInfos => friendInfos.where((friend) {
    return friendsData[friend.uid]?['rival'] ?? false;
  }).toList();
  List<FUserCollection> get rivalCollections => friendCollections.where((friend) {
    return friendsData[friend.uid]?['rival'] ?? false;
  }).toList();


  /// constructors
  FUserFriend();

  FUserFriend.fromJson(Map<String, dynamic> json) {
    fromJson(json);
  }

  /// methods
  void fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    friendsData = json['friendsData'] ?? {};
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['uid'] = uid;
    json['friendsData'] = friendsData;
    return json;
  }

  /// methods
  void toggleRival(String uid) {
    friendsData[uid]['rival'] = !friendsData[uid]['rival'];
  }

  void addFriend(String uid) {
    friendsData[uid] = {'rival': false};
  }

  void deleteFriend(String uid) {
    friendsData.remove(uid);
  }

  bool doesFriendExist(String nickname) {
    for (FUserInfo user in friendInfos) {
      if (user.nickname == nickname) return true;
    }
    return false;
  }
}
