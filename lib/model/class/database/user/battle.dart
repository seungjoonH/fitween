import 'package:fitween/model/class/database/battle.dart';

class BattleData {
  bool hide = false;
  BattleData();
  BattleData.fromJson(Map<String, dynamic> json) { fromJson(json); }
  void fromJson(Map<String, dynamic> json) => hide = json['hide'];
  Map<String, dynamic> toJson() => {'hide': hide};
}

class FUserBattle {
  /// attributes
  // 일반 변수
  String? uid;
  Map<String, BattleData> battlesData = {};

  Map<String, Battle> battles = {};

  Map<String, Battle> get finishedBattles {
    Map<String, Battle> battleList = {};
    battles.forEach((id, battle) {
      if (!battle.finished) return;
      battleList[id] = battle;
    });
    return battleList;
  }

  Map<String, Battle> get visibleBattles {
    Map<String, Battle> battleList = {};
    battles.forEach((id, battle) {
      if (battlesData[id]!.hide) return;
      battleList[id] = battle;
    });
    return battleList;
  }

  /// constructors
  FUserBattle();

  FUserBattle.fromJson(Map<String, dynamic> json) {
    fromJson(json);
  }

  /// methods
  void fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    battlesData = json['battlesData']?.map<String, BattleData>((id, json) {
      return MapEntry<String, BattleData>(id, BattleData.fromJson(json));
    }) ?? {};
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['uid'] = uid;
    json['battlesData'] = battlesData
        .map((uid, battleData) => MapEntry(uid, battleData.toJson()));
    return json;
  }

  void hideBattle(String id) => battlesData[id]!.hide = true;
}