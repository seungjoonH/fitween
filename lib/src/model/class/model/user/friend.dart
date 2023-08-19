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

  Future loadFriends() async {
    for (String uid in _friendsData.keys) {
      FUser? loaded = await FUserDAO().loadOne(uid, loadRecord: true);

      if (loaded == null) {
        print('[ERROR] User($uid) load failed');
        return;
      }

      friends[uid] = loaded;
      if (_friendsData[uid]!._rival) rivals[uid] = loaded;
    }
  }

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
  bool _rival = false;
  _TimeAttack? _timeAttack;

  FriendData.fromJson(super.json) : super.fromJson();

  @override
  void fromJson(Map<String, dynamic> json) {
    _rival = json['rival'] ?? false;
    _timeAttack = _TimeAttack.fromJson(json['timeAttack'] ?? {});
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['rival'] = _rival;
    json['timeAttack'] = _timeAttack?.toJson() ?? _TimeAttack().toJson();
    return json;
  }

  @override
  String get key => '';
}
