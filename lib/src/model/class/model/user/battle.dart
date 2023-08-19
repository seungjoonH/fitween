import 'package:fitween/src/model/class/model.dart';

class FUserBattle extends FUser {
  @override
  FUserBattle? get battle => this;

  Map<String, _BattleData> _battlesData = {};

  @override
  Map<String, Battle> battles = {};

  void removeBattle(String battleId) {
    _battlesData.remove(battleId);
    battles.remove(battleId);
  }

  FUserBattle(super.key) : super();
  FUserBattle.fromJson(super.json) : super.fromJson();

  @override
  void fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    _battlesData = json['battlesData']?.map<String, _BattleData>((id, json) {
      return MapEntry<String, _BattleData>(id, _BattleData.fromJson(json));
    }) ?? {};
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['uid'] = uid;
    json['battlesData'] = _battlesData
        .map((uid, battleData) => MapEntry(uid, battleData.toJson()));
    return json;
  }
}

class _BattleData extends Model {
  bool _hide = false;
  _BattleData.fromJson(super.json) : super.fromJson();
  @override
  void fromJson(Map<String, dynamic> json) => _hide = json['hide'];
  @override
  Map<String, dynamic> toJson() => {'hide': _hide};

  @override
  String get key => '';
}