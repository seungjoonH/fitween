import 'package:fitween/src/model/class/model/user.dart';

class FUserNotification extends FUser {
  @override
  FUserNotification? get notification => this;

  Map<String, dynamic> _friendData = {};
  Map<String, dynamic> _rivalData = {};

  FUserNotification(super.key) : super();
  FUserNotification.fromJson(super.json) : super.fromJson();

  @override
  void fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    _friendData = json['friendData'] ?? {};
    _rivalData = json['rivalData'] ?? {};
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['uid'] = uid;
    json['friendData'] = _friendData;
    json['rivalData'] = _rivalData;
    return json;
  }

  void addNotification(
      String uid, String nickname,
      String? badgeId, [
        bool isRival = false,
      ]) => isRival ? _rivalData[uid] = {
    'uid': uid,
    'nickname': nickname,
    'badgeId': badgeId,
    'checked': false,
  } : _friendData[uid] = {
    'uid': uid,
    'nickname': nickname,
    'badgeId': badgeId,
    'checked': false,
  };

  void deleteNotification(String uid, [bool isRival = false]) {
    isRival ? _rivalData.removeWhere((key, value) => key == uid)
        : _friendData.removeWhere((key, value) => key == uid);
  }

  void checkAllNotifications([bool isRival = false]) {
    (isRival ? _rivalData : _friendData).forEach((uid, data) {
      data['checked'] = true;
    });
  }
}