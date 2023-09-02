import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/model/class/model.dart';
import 'package:get/get.dart';

class FriendPageCont extends MainPageCont {
  static FriendPageCont get to => Get.find<FriendPageCont>();

  String get appBarTitle => LangCont.tr('appbar.friend');
  String get friendsCountText => LangCont.plural('friend.count', friends.length);
  String get noFriendsText => LangCont.tr('friend.no-friends');

  FUser get _logged => AuthCont.logged!;

  final _friends = <FUser>[].obs;
  List<FUser> get friends => _friends;

  void _syncFriends() {
    _friends.clear();
    _friends.addAll(_logged.friends.values);
  }

  @override
  Future init() async {
    if (LoadingCont.start('friend', 60)) {
      FUserLoadCont cont = FUserLoadCont.onlyCollection();
      await _logged.friend!.loadFriends(cont: cont);
      _syncFriends();
      LoadingCont.end();
    }
  }

  final _editMode = false.obs;
  bool get editMode => _editMode.value;

  void toggleMode() => _editMode(!_editMode.value);

  void profileWidgetPressed(FUser user) {

  }

  void friendDeleteButtonPressed(FUser friend) async {
    await _logged.friend!.deleteFriend(friend.key);
    _syncFriends();
  }
}