import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitween/global/date.dart';
import 'package:fitween/src/model/class/dao.dart';
import 'package:fitween/src/model/class/model.dart';

class FUserFriend extends FUser {
  @override
  FUserFriend? get friend => this;

  Map<String, FriendData> _friendsData = {};

  @override
  Map<String, FUser> friends = {};
  @override
  Map<String, FUser> rivals = {};

  @override
  DateTime followedDate(String uid) => _friendsData[uid]!.time;

  Future loadFriends({FUserLoadCont? cont}) async {
    for (String uid in _friendsData.keys) {
      FUser? loaded = await FUserDAO().loadOne(uid, cont: cont);

      if (loaded == null) throw Exception('[ERROR] User($uid) load failed');

      friends[uid] = FUser.combine(friends[uid], loaded);
      if (_friendsData[uid]!._rival) rivals[uid] = FUser.combine(rivals[uid], loaded);
    }
  }

  Future follow(String uid) async {
    if (friends[uid] != null) return;

    _friendsData[uid] = FriendData();
    friends[uid] = (await FUserDAO().loadOne(uid))!;

    await FUserFriendDAO().saveOne(this);
  }

  Future unfollow(String uid) async {
    if (friends[uid] == null) return;

    _friendsData.remove(uid);
    friends.remove(uid);
    rivals.remove(uid);

    await FUserFriendDAO().saveOne(this);
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

class _TimeAttack extends Model {
  int _win = 0;
  int _lose = 0;
  int _draw = 0;

  _TimeAttack();
  _TimeAttack.fromJson(super.json) : super.fromJson();

  @override
  void fromJson(Map<String, dynamic> json) {
    _win = json['win'] ?? 0;
    _lose = json['lose'] ?? 0;
    _draw = json['draw'] ?? 0;
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['win'] = _win;
    json['lose'] = _lose;
    json['draw'] = _draw;
    return json;
  }

  @override
  String get key => '';
}

class FriendData extends Model {
  late Timestamp _time;
  bool _rival = false;
  _TimeAttack? _timeAttack;

  FriendData() : _time = now.toTimestamp!, _rival = false;
  FriendData.fromJson(super.json) : super.fromJson();

  DateTime get time => _time.toDate();
  set date(DateTime time) => _time = time.toTimestamp!;

  @override
  void fromJson(Map<String, dynamic> json) {
    _time = json['time'] ?? now.toTimestamp;
    _rival = json['rival'] ?? false;
    _timeAttack = _TimeAttack.fromJson(json['timeAttack'] ?? {});
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['time'] = _time;
    json['rival'] = _rival;
    json['timeAttack'] = _timeAttack?.toJson() ?? _TimeAttack().toJson();
    return json;
  }

  @override
  String get key => '';
}
