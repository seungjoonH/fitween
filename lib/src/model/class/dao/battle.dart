
import 'package:fitween/src/model/class/dao.dart';
import 'package:fitween/src/model/class/model/battle.dart';
import 'package:fitween/src/model/class/model/user.dart';

class BattleDAO extends DAO<Battle> {
  static final BattleDAO _instance = BattleDAO._();
  BattleDAO._();

  factory BattleDAO() => _instance;

  @override
  String get collectionPath => 'battles';

  @override
  Battle fromJson(Map<String, dynamic> json) {
    return Battle.fromJson(json);
  }

  @override
  String get keyName => 'id';

  Future<List<FUser>> _loadMembers(Battle battle, {bool lightMode = true}) async {
    List<FUser> members = [];
    for (String uid in battle.memberUids) {
      FUser user = (lightMode
          ? await FUserDAO().loadOne(uid)
          : await FUserDAO().loadOneAll(uid))!;
      members.add(user);
    }
    return members;
  }

  @override
  Future<Battle> afterLoad(Battle obj, {bool lightMode = true}) async {
    obj.members = await _loadMembers(obj, lightMode: lightMode);
    return obj;
  }

  @override
  Future beforeRemove(Battle obj) async {
    if (!obj.memberLoaded) obj.members = await _loadMembers(obj, lightMode: false);
    for (FUser user in obj.members) {
      await FUserBattleDAO().removeParty(user.battle!, obj.key);
    }
  }
}