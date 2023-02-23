class FUserNotification {
  /// attributes
  // 일반 변수
  String? uid;
  Map<String, dynamic> friendData = {};
  Map<String, dynamic> rivalData = {};

  /// constructors
  FUserNotification();

  FUserNotification.fromJson(Map<String, dynamic> json) {
    fromJson(json);
  }

  /// methods
  void fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    friendData = json['friendData'] ?? {};
    rivalData = json['rivalData'] ?? {};
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['uid'] = uid;
    json['friendData'] = friendData;
    json['rivalData'] = rivalData;
    return json;
  }

  void addNotification(
    String uid, String nickname,
    String? badgeId, [
      bool isRival = false,
  ]) => isRival ? rivalData[uid] = {
    'uid': uid,
    'nickname': nickname,
    'badgeId': badgeId,
    'checked': false,
  } : friendData[uid] = {
    'uid': uid,
    'nickname': nickname,
    'badgeId': badgeId,
    'checked': false,
  };

  void deleteNotification(String uid, [bool isRival = false]) {
    isRival ? rivalData.removeWhere((key, value) => key == uid)
        : friendData.removeWhere((key, value) => key == uid);
  }

  void checkAllNotifications([bool isRival = false]) {
    (isRival ? rivalData : friendData).forEach((uid, data) {
      data['checked'] = true;
    });
  }
}