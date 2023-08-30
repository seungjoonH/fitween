
import 'package:fitween/src/model/class/dao.dart';
import 'package:fitween/src/model/class/model/battle.dart';

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
}