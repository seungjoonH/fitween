import 'package:fitween/global/theme.dart';
import 'package:fitween/model/enum/dialog.dart';
import 'package:fitween/presenter/model/user.dart';
import 'package:fitween/view/widget/function/dialog.dart';
import 'package:fitween/view/widget/widget/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

  Future init() async {
    final userP = Get.find<UserP>();
    await userP.load();
    await userP.loadFriends();
    update();
  }

  void toggleRival(String uid) async {
    final userP = Get.find<UserP>();
    userP.loggedUser.toggleRival(uid);
    userP.save();
    await userP.loadFriends();
    update();
  }

  bool isRival(uid) {
    final userP = Get.find<UserP>();
    return userP.loggedUser.rivalUids.contains(uid);
  }

  // 별명 입력 필드 유효성 검사
  Future<bool> validate() async {
    String text = nicknameCont.text;

    Map<String, bool> conditions = {
      '\'${nicknameCont.text}\'님이 없습니다': !await UserP.duplicatedNickname(text),
      '이미 등록된 친구입니다': UserP.doesFriendExist(text),
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

  Future addFriend() async {
    final userP = Get.find<UserP>();
    if (!await validate()) return;

    String? uid = await UserP.loadUidByNickname(nicknameCont.text);
    if (uid == null) return;

    userP.addFriend(uid);
    init();
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
              FText('친구로 등록할 별명을 입력하세요'),
              SizedBox(height: 10.0.h),
              GetBuilder<FriendP>(
                builder: (friendP) {
                  return PInputField(
                    controller: nicknameCont,
                    invalid: !friendP.nicknameExist,
                    hintText: friendP.nicknameHintText ?? '별명을 입력하세요',
                    hintColor: friendP.nicknameHintText == null
                        ? FTheme.grey : FTheme.colorB,
                  );
                },
              ),
            ],
          ),
        ),
        type: DialogType.bi,
        leftPressed: Get.back,
        rightPressed: addFriend,
      ),
    );
  }
}