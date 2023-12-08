import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/model/class/dao.dart';
import 'package:fitween/src/model/class/model.dart';
import 'package:get/get.dart';

class FollowCont extends GetxController {
  static FollowCont get to => Get.find<FollowCont>();

  FriendCont get friendCont => FriendCont.to;

  FUser get logged => AuthCont.logged!;
  final _followersData = <String, bool>{}.obs;

  Map<String, bool> get followersData => _followersData;
  void syncDataFrom(Map<String, bool> data) => _followersData.assignAll({...data});

  Future init() async => await _syncFollowingsFrom();
  Future save() async => await _syncFollowingsTo();

  Future _syncFollowingsFrom() async {
    await friendCont.syncFriendsFrom();
    Map<String, bool> map = {};
    for (String uid in friendCont.friends.keys) {
      map[uid] = friendCont.followers.keys.contains(uid);
    }
    _followersData.assignAll(map);
  }

  Future _syncFollowingsTo() async {
    friendCont.syncFollowersFrom(_followersData);
    await friendCont.syncFriendsTo();
  }

  bool hasSameData(Map<String, bool> data) {
    return data.keys.every((uid) => data[uid] == _followersData[uid]);
  }

  bool getFollowed(String uid) => _followersData[uid] ?? false;

  String getButtonText(bool followed) {
    return LangCont.tr('word.${followed ? 'un' : ''}follow');
  }

  void follow(String uid) => _followersData[uid] = true;
  void unfollow(String uid) => _followersData[uid] = false;

  void followButtonPressed(String uid) async {
    bool followed = getFollowed(uid);
    _followersData[uid] = !followed;
    await _syncFollowingsTo();
  }

  Future followAndNotifyFollowing(String uid) async {
    follow(uid);
    await _syncFollowingsTo();
    FUserLoadCont cont = FUserLoadCont.onlyNotification();
    FUser? loaded = await FUserDAO().loadOne(uid, cont: cont);
    if (loaded == null) throw Exception('User ($loaded) load failed');

    loaded.notification!.follow(logged);
    await FUserNotificationDAO().saveOne(loaded.notification!);
  }
}