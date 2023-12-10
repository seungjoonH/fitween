import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitween/global/date.dart';
import 'package:fitween/src/model/class/model.dart';
import 'package:get/get.dart';

class FUserFriend extends FUser {
  @override
  FUserFriend? get friend => this;

  Map<String, FriendData> _friendsData = {};
  Map<String, FriendData> get friendsData => _friendsData;

  void syncFriendDataFrom(Map<String, FriendData> data) {
    _friendsData.assignAll({...data});
  }

  // Future deleteFriend(String uid) async {
  //   if (friends[uid] == null) return;
  //
  //   _friendsData.remove(uid);
  //   friends.remove(uid);
  //   rivals.remove(uid);
  //
  //   await FUserFriendDAO().saveOne(this);
  //   FUserFriend friend = (await FUserFriendDAO().loadOne(uid))!;
  //
  //   await friend.loadFriends(cont: FUserLoadCont.onlyFriend());
  //   await friend.deleteFriend(key);
  //   await FUserFriendDAO().saveOne(friend);
  // }

  FUserFriend(super.key) : super();
  FUserFriend.fromJson(super.json) : super.fromJson();

  @override
  void fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    _friendsData = json['friendsData']?.map<String, FriendData>((uid, json) {
      return MapEntry<String, FriendData>(uid, FriendData.fromJson(json));
    }) ?? {};
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['uid'] = uid;
    json['friendsData'] = _friendsData
        .map((uid, friendData) => MapEntry(uid, friendData.toJson()));
    return json;
  }
}

// class _TimeAttack extends Model {
//   int _win = 0;
//   int _lose = 0;
//   int _draw = 0;
//
//   _TimeAttack();
//   _TimeAttack.fromJson(super.json) : super.fromJson();
//
//   @override
//   void fromJson(Map<String, dynamic> json) {
//     _win = json['win'] ?? 0;
//     _lose = json['lose'] ?? 0;
//     _draw = json['draw'] ?? 0;
//   }
//
//   @override
//   Map<String, dynamic> toJson() {
//     Map<String, dynamic> json = {};
//     json['win'] = _win;
//     json['lose'] = _lose;
//     json['draw'] = _draw;
//     return json;
//   }
//
//   @override
//   String get key => '';
// }

class FriendData extends Model {
  late Timestamp _time;
  bool _followed = true;
  // _TimeAttack? _timeAttack;

  FriendData() : _time = now.toTimestamp!, _followed = true;
  FriendData.fromJson(super.json) : super.fromJson();

  DateTime get time => _time.toDate();
  set date(DateTime time) => _time = time.toTimestamp!;

  bool get followed => _followed;

  void follow() {
    _time = now.toTimestamp!;
    _followed = true;
  }
  void unfollow() => _followed = false;

  @override
  void fromJson(Map<String, dynamic> json) {
    _time = json['time'] ?? now.toTimestamp;
    _followed = json['followed'] ?? false;
    // _timeAttack = _TimeAttack.fromJson(json['timeAttack'] ?? {});
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['time'] = _time;
    json['followed'] = _followed;
    // json['timeAttack'] = _timeAttack?.toJson() ?? _TimeAttack().toJson();
    return json;
  }

  @override
  String get key => '';
}
