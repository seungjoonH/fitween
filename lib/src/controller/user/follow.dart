import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/model/class/model.dart';
import 'package:get/get.dart';

class FollowCont extends GetxController {
  static FollowCont get to => Get.find<FollowCont>();

  FUser get _logged => AuthCont.logged!;

  final _friendUids = <String>[].obs;

  void init() => _friendUids.assignAll(_logged.friends.keys);

  bool hasSameMembers(List<String> uids) {
    if (uids.length != _friendUids.length) return false;
    return _friendUids.every((uid) => uids.contains(uid));
  }

  bool getFollowed(String uid) => _friendUids.contains(uid);

  String getButtonText(String uid) {
    return LangCont.tr('word.${getFollowed(uid) ? 'un' : ''}follow');
  }

  void followButtonPressed(String uid) {
    getFollowed(uid)
        ? _friendUids.remove(uid)
        : _friendUids.add(uid);
  }

  void saveFollowingState() async {
    for (String uid in _friendUids) {
      if (getFollowed(uid)) await _logged.friend!.follow(uid);
    }

    List<String> loggedFriends = [..._logged.friends.keys];
    for (String uid in loggedFriends) {
      if (!getFollowed(uid)) await _logged.friend!.unfollow(uid);
    }
  }
}