import 'package:fitween/global/theme.dart';
import 'package:fitween/model/class/database/user/friend.dart';
import 'package:fitween/model/class/database/user/info.dart';
import 'package:fitween/model/enum/dialog.dart';
import 'package:fitween/presenter/inspection/inspection.dart';
import 'package:fitween/presenter/lang/language.dart';
import 'package:fitween/presenter/model/user/friend.dart';
import 'package:fitween/presenter/model/user/info.dart';
import 'package:fitween/presenter/model/user/notification.dart';
import 'package:fitween/presenter/widget/loading.dart';
import 'package:fitween/view/widget/function/dialog.dart';
import 'package:fitween/view/widget/widget/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class FriendP extends GetxController {
  static void toFriend([bool initialize = false]) async {
    Get.offAllNamed('/friend');
    if (initialize) await init();
  }

  static Future init() async {
    if (await Inspection.load()) return;

    final friendP = Get.find<FriendP>();
    final loadingP = Get.find<LoadingP>();

    friendP.editMode = false;

    if (loadingP.loading) return;
    loadingP.loadStart();
    await friendP.loadAll();
    loadingP.loadEnd();
  }

  Future loadAll() async {
    final userFriendP = Get.find<UserFriendP>();
    final userNotificationP = Get.find<UserNotificationP>();

    await userFriendP.load();
    await userFriendP.loadFriends();
    userNotificationP.checkAllNotifications();

    update();
  }

  static final refreshConts = [RefreshController(), RefreshController()];
  static final nicknameCont = TextEditingController();

  int tabIndex = 0;
  bool nicknameExist = true;
  String? nicknameHintText;

  bool editMode = false;

  void friendInteractButtonPressed(String uid) {
    (editMode ? deleteFriendButtonPressed : toggleRivalButtonPressed)(uid);
  }

  // 별명 입력 필드 유효성 검사
  Future<bool> validate() async {
    final userP = Get.find<UserInfoP>();
    String text = nicknameCont.text;

    String v(String text) => 'input.validate.$text';

    Map<String, bool> conditions = {
      Lang.tr(v('not-exist'), args: [nicknameCont.text]): !await UserInfoP.duplicatedNickname(text),
      Lang.tr(v('aldy-frnd'), args: [nicknameCont.text]): UserFriendP.doesFriendExist(text),
      Lang.tr(v('me')): text == userP.loggedUser.nickname,
      Lang.tr('input.hint.nickname', args: [' friend\'s']): text == '',
    };

    conditions.forEach((message, condition) {
      if (condition) nicknameHintText = message;
    });

    if (conditions.values.any((condition) => condition)) {
      nicknameCont.clear();
      nicknameExist = false; update();
      await Future.delayed(const Duration(milliseconds: 500), () {
        nicknameExist = true; update();
      });
      await Future.delayed(const Duration(milliseconds: 500), () {
        nicknameCont.text = text; update();
        nicknameHintText = null;
      });
      return false;
    }
    return true;
  }

  void noticeToFriend(String uid, [bool isRival = false]) async {
    final userP = Get.find<UserNotificationP>();
    await userP.addNotification(userP.loggedUser.uid!, uid, isRival);
    Get.back();

    String? nickname = (await UserInfoP.loadUser(uid))?.nickname;

    if (nickname == null) return;

    showFDialog(
      title: Lang.tr('${isRival ? 'rvl' : 'frnd'}.req'),
      content: FText(
        Lang.tr(
          '${isRival ? 'rvl' : 'frnd'}.requested',
          args: [nickname],
        ),
        maxLines: 2,
      ),
      type: DialogType.mono,
      onPressed: Get.back,
    );
  }

  void friendInfoSubmitted() async {
    if (!await validate()) return;

    String? uid = await UserInfoP.loadUidByNickname(nicknameCont.text);
    if (uid == null) return;

    noticeToFriend(uid);
  }

  void addFriendButtonPressed() {
    nicknameCont.clear();
    nicknameHintText = null;

    showFDialog(
      title: Lang.tr('add-friend'),
      content: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 5.0.r, vertical: 10.0.r,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GetBuilder<FriendP>(
              builder: (friendP) {
                return FInputField(
                  controller: nicknameCont,
                  invalid: !friendP.nicknameExist,
                  hintText: friendP.nicknameHintText ?? Lang.tr(
                    'input.hint.nickname', args: [' friend\'s'],
                  ),
                  hintColor: friendP.nicknameHintText == null
                      ? FTheme.lightGrey : FTheme.colorB,
                  style: textTheme(Get.context!).bodyMedium,
                );
              },
            ),
          ],
        ),
      ),
      type: DialogType.bi,
      leftPressed: Get.back,
      rightText: Lang.tr('btn.add'),
      rightPressed: friendInfoSubmitted,
    );
  }

  void toggleMode() {
    editMode = !editMode; update();
  }

  void breakOffWith(String uid) async {
    final userP = Get.find<UserFriendP>();
    userP.deleteFriend(uid);

    FUserFriend? friend = await UserFriendP.loadUser(uid);
    if (friend == null) return;
    friend.deleteFriend(userP.loggedUser.uid!);
    UserFriendP.saveUser(friend);

    init();
    Get.back();
  }

  void deleteFriendButtonPressed(String uid) async {
    FUserInfo? user = await UserInfoP.loadUser(uid);
    if (user == null) return;
    
    showFDialog(
      title: Lang.tr('frnd.del'),
      content: FText(
        Lang.tr('frnd.del-really', args: [user.nickname!]),
        maxLines: 2,
      ),
      type: DialogType.bi,
      leftPressed: Get.back,
      rightText: Lang.tr('btn.delete'),
      rightPressed: () => breakOffWith(uid),
      rightBackgroundColor: FTheme.error,
    );
  }

  void addRivalButtonPressed(String uid) async {
    FUserInfo? user = await UserInfoP.loadUser(uid);
    if (user == null) return;

    showFDialog(
      title: Lang.tr('rvl.req'),
      content: FText(
        Lang.tr('rvl.req-really', args: [user.nickname!]),
        maxLines: 2,
      ),
      type: DialogType.bi,
      leftPressed: Get.back,
      rightText: Lang.tr('btn.request'),
      rightPressed: () => noticeToFriend(uid, true),
    );
  }

  void releaseRival(String uid) async {
    final userP = Get.find<UserFriendP>();
    userP.toggleRival(uid);

    FUserFriend? user = await UserFriendP.loadUser(uid);
    if (user == null) return;

    user.toggleRival(userP.loggedUser.uid!);
    UserFriendP.saveUser(user);

    init(); update();
  }

  void releaseRivalButtonPressed(String uid) async {
    FUserInfo? user = await UserInfoP.loadUser(uid);
    if (user == null) return;

    showFDialog(
      title: Lang.tr('rvl.del'),
      content: FText(
        Lang.tr('rvl.del-really', args: [user.nickname!]),
        maxLines: 2,
      ),
      type: DialogType.bi,
      leftPressed: Get.back,
      rightText: Lang.tr('btn.exclude'),
      rightBackgroundColor: FTheme.error,
      rightPressed: () {
        releaseRival(uid);
        Get.back();
      },
    );
  }

  void toggleRivalButtonPressed(String uid) {
    (isRival(uid)
        ? releaseRivalButtonPressed
        : addRivalButtonPressed
    )(uid);
  }

  bool isRival(uid) {
    final userP = Get.find<UserFriendP>();
    return userP.loggedUser.rivalUids.contains(uid);
  }

  void rejectButtonPressed(String uid, [bool isRival = false]) async {
    final userP = Get.find<UserNotificationP>();
    userP.deleteNotification(uid, userP.loggedUser.uid!, isRival);
    init();
  }

  void acceptButtonPressed(String uid, [bool isRival = false]) async {
    final userNotificationP = Get.find<UserNotificationP>();
    final userFriendP = Get.find<UserFriendP>();
    String myUid = userNotificationP.loggedUser.uid!;

    userNotificationP.deleteNotification(uid, myUid, isRival);

    FUserFriend? friend = await UserFriendP.loadUser(uid);
    if (friend == null) return;

    if (isRival) {
      userFriendP.toggleRival(uid);
      friend.toggleRival(myUid);
    }
    else {
      userFriendP.addFriend(uid);
      friend.addFriend(myUid);
    }

    UserFriendP.saveUser(friend);
    init();
  }
}