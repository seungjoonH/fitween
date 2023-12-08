import 'package:fitween/global/global.dart';
import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/model/class/dao.dart';
import 'package:fitween/src/model/class/model.dart';
import 'package:fitween/src/model/enum/enum.dart';
import 'package:fitween/src/view/widget/function/dialog.dart';
import 'package:fitween/src/view/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/basic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class FriendCont extends GetxController {
  static FriendCont get to => Get.find<FriendCont>();

  final _data = <String, FriendData>{}.obs;
  final _friends = <String, FUser>{}.obs;

  Map<String, FUser> get friends => _friends;
  Map<String, FUser> get followers {
    Map<String, FUser> list = {};
    for (String uid in _data.keys) {
      if (_data[uid]!.followed) list[uid] = _friends[uid]!;
    }
    return list;
  }

  Future init() async {
    await syncFriendsFrom();
    await loadAllFriends(cont: FUserLoadCont(collection: true, record: true));
  }

  Future syncFriendsFrom() async {
    await AuthCont.load(FUserLoadCont(friend: true));
    _data.assignAll({...logged.friend!.friendsData});
  }

  Future syncFriendsTo() async {
    logged.friend!.syncFriendDataFrom(_data);
    await FUserFriendDAO().saveOne(logged.friend!);
  }

  void syncFollowersFrom(Map<String, bool> data) {
    for (String uid in data.keys) {
      if (data[uid]!) { _data[uid]!.follow(); }
      else { _data[uid]!.unfollow(); }
    }
  }

  void _updateFriend(FUser friend) {
    FUser? user = _friends[friend.key];
    _friends[friend.key] = FUser.combine(user, friend);
  }

  Future _loadFriend(String uid, {FUserLoadCont? cont}) async {
    FUser? loaded = await FUserDAO().loadOne(uid, cont: cont);
    if (loaded == null) throw Exception('User ($loaded) load failed');
    _updateFriend(loaded);
  }

  Future loadAllFriends({FUserLoadCont? cont}) async {
    for (String uid in _data.keys) { await _loadFriend(uid, cont: cont); }
  }

  FUser get logged => AuthCont.logged!;

  bool isFollowing(String uid) => _data.keys.any((e) => e == uid);
  bool isFollowingOrMe(String uid) => logged.key == uid || isFollowing(uid);

  Future follow(String uid) async {
    if (_data[uid] == null) _data[uid] = FriendData();

    _data[uid]!.follow();
    await _loadFriend(uid, cont: FUserLoadCont(collection: true, record: true));
    await syncFriendsTo();
  }

  Future unfollow(String uid) async {
    if (_data[uid] == null) return;

    _data[uid]!.unfollow();
    await syncFriendsTo();
  }

  DateTime followedDate(String uid) => _data[uid]!.time;

  void showFriendInfoDialog(FUser user) {
    Map<FType, num> friendRecord = user.allRecord;
    Map<FType, num> myRecord = logged.allRecord;

    showFDialog(
      title: user.nickname,
      content: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: FType.activeValues.map((type) {
            num friendValue = friendRecord[type]!;
            num myValue = myRecord[type]!;
            num difference = friendValue - myValue;
            num sign = difference.sign;

            IconData icon = Icons.flutter_dash;
            Color color = ThemeCont.to.outline;
            if (sign > 0) { icon = Icons.arrow_drop_up;  color = ThemeCont.colorB; }
            else if (sign < 0) { icon = Icons.arrow_drop_down; color = ThemeCont.colorC; }

            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                FText(
                  '${type.locale}: ',
                  color: ThemeCont.to.comment,
                  style: ThemeCont.to.commentStyle,
                ),
                SizedBox(width: 10.0.w),
                FTexts(
                  type.withUnit(friendValue, txs: true),
                  style: ThemeCont.to.bodyMedium,
                  highlightStyle: ThemeCont.to.titleMedium,
                ),
                SizedBox(width: 5.0.w),
                Row(
                  children: [
                    Icon(icon, color: color),
                    FText(
                      '(${type.withUnit(difference.abs())})',
                      style: ThemeCont.to.bodyMedium,
                      color: color,
                    ),
                  ],
                ),
              ],
            );
          }).separateH(height: 10.0.h),
        ),
      ),
    );
  }
}