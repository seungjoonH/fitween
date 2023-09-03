import 'package:fitween/route.dart';
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

  List<String> get _friendUids => _friends.map((f) => f.key).toList();

  final _changed = false.obs;
  bool get changed => _changed.value;

  FollowCont get _followCont => FollowCont.to;

  void _setChanged() {
    _changed(!_followCont.hasSameMembers(_friendUids));
  }

  void _syncFriends() {
    _followCont.saveFollowingState();
    _friends.assignAll(_logged.friends.values);
  }

  @override
  String get loadKey => 'friend';

  @override
  Future load() async {
    _changed(false);
    _editMode(false);
    FUserLoadCont cont = FUserLoadCont.onlyCollection();
    await _logged.friend!.loadFriends(cont: cont);
    FollowCont.to.init();
    _syncFriends();
  }

  final _editMode = false.obs;
  bool get editMode => _editMode.value;

  void toggleMode() {
    if (editMode && changed) _syncFriends();
    _editMode(!_editMode.value);
  }

  void friendSearchButtonPressed() => FRoute.toFriendSearch();

  void profileWidgetPressed(FUser user) {

  }

  void followButtonPressed(FUser friend) {
    _setChanged();
  }
}