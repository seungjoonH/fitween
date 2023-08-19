import 'package:fitween/src/model/class/dao.dart';
import 'package:fitween/src/model/class/model.dart';

class FUserBattleDAO extends DAO<FUserBattle> {
  static final FUserBattleDAO _instance = FUserBattleDAO._();
  FUserBattleDAO._();

  factory FUserBattleDAO() => _instance;

  @override
  String get collectionPath => 'userBattles';

  @override
  FUserBattle fromJson(Map<String, dynamic> json) {
    return FUserBattle.fromJson(json);
  }

  @override
  String get keyName => 'uid';

  Future removeParty(FUserBattle user, String battleId) async {
    user.removeBattle(battleId);
    await saveOne(user);
    set(user);
  }
}