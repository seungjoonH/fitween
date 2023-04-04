/* 사용자 모델 구조 */

import 'package:fitween/model/class/database/user/collection.dart';
import 'package:fitween/model/class/database/user/info.dart';
import 'package:fitween/model/class/database/user/record.dart';

class TimeAttack {
  int win = 0;
  int lose = 0;
  int draw = 0;

  TimeAttack();
  TimeAttack.fromJson(Map<String, dynamic> json) {
    fromJson(json);
  }

  void fromJson(Map<String, dynamic> json) {
    win = json['win'] ?? 0;
    lose = json['lose'] ?? 0;
    draw = json['draw'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['win'] = win;
    json['lose'] = lose;
    json['draw'] = draw;
    return json;
  }
}

class FriendData {
  bool rival = false;
  TimeAttack? timeAttack;

  FriendData();
  FriendData.fromJson(Map<String, dynamic> json) {
    fromJson(json);
  }

  void fromJson(Map<String, dynamic> json) {
    rival = json['rival'] ?? false;
    timeAttack = TimeAttack.fromJson(json['timeAttack'] ?? {});
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['rival'] = rival;
    json['timeAttack'] = timeAttack?.toJson() ?? TimeAttack().toJson();
    return json;
  }
}

class FUserFriend {
  /// attributes
  // 일반 변수
  String? uid;

  // 복합 변수
  Map<String, FriendData> friendsData = {};

  // 의존 변수
  List<FUserCollection> friendCollections = [];
  List<FUserInfo> friendInfos = [];
  List<FUserRecord> friendRecords = [];

  /// accessors & mutators
  List<String> get friendUids => friendsData.keys.toList();
  List<String> get rivalUids => rivalInfos.map((user) => user.uid!).toList();

  List<FUserInfo> get rivalInfos => friendInfos.where((friend) {
    return friendsData[friend.uid]?.rival ?? false;
  }).toList();
  List<FUserCollection> get rivalCollections => friendCollections.where((friend) {
    return friendsData[friend.uid]?.rival ?? false;
  }).toList();
  List<FUserRecord> get rivalRecords => friendRecords.where((friend) {
    return friendsData[friend.uid]?.rival ?? false;
  }).toList();

  /// constructors
  FUserFriend();

  FUserFriend.fromJson(Map<String, dynamic> json) {
    fromJson(json);
  }

  /// methods
  void fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    friendsData = json['friendsData']?.map<String, FriendData>((uid, json) {
      return MapEntry<String, FriendData>(uid, FriendData.fromJson(json));
    }) ?? {};
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['uid'] = uid;
    json['friendsData'] = friendsData
        .map((uid, friendData) => MapEntry(uid, friendData.toJson()));
    return json;
  }

  /// methods
  void toggleRival(String uid) {
    friendsData[uid]!.rival = !friendsData[uid]!.rival;
  }

  void addFriend(String uid) {
    friendsData[uid] = FriendData();
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

  int getWinCount(String uid) => friendsData[uid]!.timeAttack!.win;
  int getLoseCount(String uid) => friendsData[uid]!.timeAttack!.lose;
  int getDrawCount(String uid) => friendsData[uid]!.timeAttack!.draw;

  void win(String uid) => friendsData[uid]!.timeAttack!.win++;
  void lose(String uid) => friendsData[uid]!.timeAttack!.lose++;
  void draw(String uid) => friendsData[uid]!.timeAttack!.draw++;
}
