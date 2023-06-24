import 'package:fitween/global/theme.dart';
import 'package:fitween/model/class/database/user/friend.dart';
import 'package:fitween/model/class/database/user/info.dart';
import 'package:fitween/model/enum/dialog.dart';
import 'package:fitween/presenter/model/user/friend.dart';
import 'package:fitween/presenter/model/user/info.dart';
import 'package:fitween/presenter/model/user/notification.dart';
import 'package:fitween/presenter/widget/loading.dart';
import 'package:fitween/view/widget/function/dialog.dart';
import 'package:fitween/view/widget/widget/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class FriendP extends GetxController {
  static void toFriend([bool initialize = false]) async {
    Get.offAllNamed('/friend');
    if (initialize) await init();
  }

  static Future init() async {
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

  void noticeToFriend(String uid, [bool isRival = false]) async {
    final userP = Get.find<UserNotificationP>();
    await userP.addNotification(userP.loggedUser.uid!, uid, isRival);
    Get.back();

    String title = isRival ? '라이벌' : '친구';
    String? nickname = (await UserInfoP.loadUser(uid))?.nickname;

    if (nickname == null) return;

    Get.dialog(
      FAlertDialog(
        title: '$title 신청',
        content: FText(
          '\'$nickname\'님께\n$title 신청 하였습니다',
          maxLines: 2,
        ),
        type: DialogType.mono,
        onPressed: Get.back,
      ),
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

    Get.dialog(
      FAlertDialog(
        title: '친구 추가',
        content: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10.0, vertical: 20.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GetBuilder<FriendP>(
                builder: (friendP) {
                  return FInputField(
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
        rightText: '추가하기',
        rightPressed: friendInfoSubmitted,
      ),
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
    
    Get.dialog(
      FAlertDialog(
        title: '${user.nickname}',
        content: FText(
          '님을 친구목록에서\n삭제하시겠습니까?',
          maxLines: 2,
        ),
        type: DialogType.bi,
        leftPressed: Get.back,
        rightText: '삭제',
        rightPressed: () => breakOffWith(uid),
        rightBackgroundColor: FTheme.error,
      ),
    );
  }

  void addRivalButtonPressed(String uid) async {
    FUserInfo? user = await UserInfoP.loadUser(uid);
    if (user == null) return;

    Get.dialog(
      FAlertDialog(
        title: '라이벌 신청',
        content: FText(
          '\'${user.nickname}\'님에게\n라이벌 신청을 하시겠습니까?',
          maxLines: 2,
        ),
        type: DialogType.bi,
        leftPressed: Get.back,
        rightText: '신청하기',
        rightPressed: () => noticeToFriend(uid, true),
      ),
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

    Get.dialog(
      FAlertDialog(
        title: '${user.nickname}',
        content: FText(
          '님을 라이벌에서\n제외하시겠습니까?',
          maxLines: 2,
        ),
        type: DialogType.bi,
        leftPressed: Get.back,
        rightText: '제외하기',
        rightBackgroundColor: FTheme.error,
        rightPressed: () {
          releaseRival(uid);
          Get.back();
        },
      ),
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