import 'package:fitween/presenter/model/user.dart';
import 'package:get/get.dart';

class FriendP extends GetxController {
  static void toFriend() async {
    final userP = Get.find<UserP>();
    await userP.loadFriends();
    Get.offAllNamed('/friend');
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
}