import 'package:fitween/route.dart';
import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/model/class/model.dart';
import 'package:get/get.dart';

class FriendPageCont extends MainPageCont {
  static FriendPageCont get to => Get.find<FriendPageCont>();

  FollowCont get followCont => FollowCont.to;
  FriendCont get friendCont => FriendCont.to;

  String get appBarTitle => LangCont.tr('appbar.friend');
  String get friendsCountText => LangCont.plural('friend.count', _followersData.length);
  String get noFriendsText => LangCont.tr('friend.no-friends');

  final _changed = false.obs;
  bool get changed => _changed.value;

  final _followersData = <String, bool>{}.obs;
  List<FUser> get friends => friendCont
      .friends.values.toList()
      .where((user) => _followersData.keys.contains(user.key)).toList();

  Future _syncDataFrom() async {
    await followCont.init();
    _followersData.clear();

    for (String uid in followCont.followersData.keys) {
      if (!followCont.followersData[uid]!) continue;
      _followersData[uid] = followCont.followersData[uid]!;
    }
  }

  Future _syncDataTo() async {
    followCont.syncDataFrom(_followersData);

    for (String uid in followCont.followersData.keys) {
      if (!_followersData[uid]!) _followersData.remove(uid);
    }

    await followCont.save();
  }

  void follow(String uid) { _followersData[uid] = true; _setChanged(); }
  void unfollow(String uid) { _followersData[uid] = false; _setChanged(); }

  void _setChanged() {
    if (!editMode) return;
    bool exist = !followCont.hasSameData(_followersData);
    _changed(exist);
  }

  @override
  String get loadKey => 'friend';

  @override
  Future load() async {
    _changed(false);
    _editMode(false);
    await friendCont.init();
    await followCont.init();
    await _syncDataFrom();
  }

  Future save() async => await _syncDataTo();

  final _editMode = false.obs;
  bool get editMode => _editMode.value;

  void toggleButtonPressed() async {
    if (editMode && changed) await save();
    _editMode(!_editMode.value);
  }

  void friendSearchButtonPressed() => FRoute.toFriendSearch();

  void profileWidgetPressed(FUser user) {
    friendCont.showFriendInfoDialog(user);
  }

  bool getFollowed(String uid) => _followersData[uid] ?? false;

  void followButtonPressed(FUser user) {
    if (_followersData[user.key]!) { unfollow(user.key); }
    else { follow(user.key); }
  }
}