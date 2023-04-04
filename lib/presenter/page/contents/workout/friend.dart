import 'package:fitween/model/class/database/user/collection.dart';
import 'package:fitween/model/class/database/user/info.dart';
import 'package:fitween/presenter/model/user/collection.dart';
import 'package:fitween/presenter/model/user/friend.dart';
import 'package:fitween/presenter/model/user/info.dart';
import 'package:get/get.dart';

class WorkoutFriendP extends GetxController {
  static void toWorkoutFriend() {
    Get.toNamed('/contents/workout/friend');
  }

  static void init() {
    final battleFriendP = Get.find<WorkoutFriendP>();
    battleFriendP.loadAll();
  }

  int selectedIndex = 0;
  FUserInfo get selectedRival => infos[selectedIndex];

  List<FUserInfo> get infos {
    final userInfoP = Get.find<UserInfoP>();
    final userFriendP = Get.find<UserFriendP>();
    return [userInfoP.loggedUser, ...userFriendP.loggedUser.rivalInfos];
  }

  List<FUserCollection> get collections {
    final userCollectionP = Get.find<UserCollectionP>();
    final userFriendP = Get.find<UserFriendP>();
    return [userCollectionP.loggedUser, ...userFriendP.loggedUser.rivalCollections];
  }

  void loadAll() {
    selectedIndex = 0;
    update();
  }

  void select(int index) { selectedIndex = index; update(); }
}
