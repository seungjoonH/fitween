import 'package:fitween/global/theme.dart';
import 'package:fitween/model/class/database/user.dart';
import 'package:fitween/model/class/database/user/friend.dart';
import 'package:fitween/model/class/database/user/info.dart';
import 'package:fitween/model/class/database/user/notification.dart';
import 'package:fitween/model/enum/dialog.dart';
import 'package:fitween/presenter/model/user.dart';
import 'package:fitween/presenter/model/user/friend.dart';
import 'package:fitween/presenter/model/user/info.dart';
import 'package:fitween/presenter/model/user/notification.dart';
import 'package:fitween/view/widget/function/dialog.dart';
import 'package:fitween/view/widget/widget/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class FriendP extends GetxController {
  static void toFriend() async {
    final friendP = Get.find<FriendP>();
    Get.offAllNamed('/friend');
    friendP.init();
  }

  static final nicknameCont = TextEditingController();
  bool nicknameExist = true;
  String? nicknameHintText;

  bool editMode = false;

  Future init() async {
    final userFriendP = Get.find<UserFriendP>();
    final userNotificationP = Get.find<UserNotificationP>();
    editMode = false;
    await userFriendP.load();
    await userFriendP.loadFriends();
    userNotificationP.checkAllNotifications();
    update();
  }

  void friendInteractButtonPressed(String uid) {
    (editMode ? deleteFriendButtonPressed : toggleRival)(uid);
  }

  void toggleRival(String uid) async {
    final userP = Get.find<UserFriendP>();
    userP.loggedUser.toggleRival(uid);
    userP.save();
    userP.update();
    update();
  }

  bool isRival(uid) {
    final userP = Get.find<UserFriendP>();
    return userP.loggedUser.rivalUids.contains(uid);
  }

  // 별명 입력 필드 유효성 검사
  Future<bool> validate() async {
    final userP = Get.find<UserInfoP>();
    String text = nicknameCont.text;

    Map<String, bool> conditions = {
      '\'${nicknameCont.text}\'님이 없습니다': !await UserInfoP.duplicatedNickname(text),
      '이미 등록된 친구입니다': UserFriendP.doesFriendExist(text),
      '본인과 친구가 될 수 없습니다': text == userP.loggedUser.nickname,
      '별명을 입력하세요': text == '',
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

  Future friendInfoSubmitted() async {
    final userP = Get.find<UserNotificationP>();
    if (!await validate()) return;

    String? uid = await UserInfoP.loadUidByNickname(nicknameCont.text);
    if (uid == null) return;

    await userP.addNotification(userP.loggedUser.uid!, uid);

    Get.back();
  }

  void addFriendButtonPressed() {
    nicknameCont.clear();
    nicknameHintText = null;

    Get.dialog(
      PAlertDialog(
        title: '친구 별명 입력',
        content: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10.0, vertical: 20.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GetBuilder<FriendP>(
                builder: (friendP) {
                  return PInputField(
                    controller: nicknameCont,
                    invalid: !friendP.nicknameExist,
                    hintText: friendP.nicknameHintText ?? '별명을 입력하세요',
                    hintColor: friendP.nicknameHintText == null
                        ? FTheme.darkGrey : FTheme.colorB,
                  );
                },
              ),
            ],
          ),
        ),
        type: DialogType.bi,
        leftPressed: Get.back,
        rightPressed: friendInfoSubmitted,
      ),
    );
  }

  void toggleMode() {
    editMode = !editMode; update();
  }

  void deleteFriendButtonPressed(String uid) async {
    final userP = Get.find<UserFriendP>();
    userP.deleteFriend(uid);

    FUserFriend? friend = await UserFriendP.loadUser(uid);
    if (friend == null) return;
    friend.deleteFriend(userP.loggedUser.uid!);
    UserFriendP.saveUser(friend);

    init();
  }

  void rejectButtonPressed(String uid, [bool isRival = false]) async {
    final userP = Get.find<UserNotificationP>();
    userP.deleteNotification(uid, userP.loggedUser.uid!, isRival);
    init();
  }

  void acceptButtonPressed(String uid, [bool isRival = false]) async {
    final userNotificationP = Get.find<UserNotificationP>();
    final userFriendP = Get.find<UserFriendP>();
    userNotificationP.deleteNotification(
      uid, userNotificationP.loggedUser.uid!, isRival,
    );
    userFriendP.addFriend(uid);

    FUserFriend? friend = await UserFriendP.loadUser(uid);
    if (friend == null) return;

    friend.addFriend(userNotificationP.loggedUser.uid!);
    UserFriendP.saveUser(friend);
    init();
  }
}