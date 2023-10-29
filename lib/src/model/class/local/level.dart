import 'dart:math';

import 'package:fitween/src/model/class/amount/amount.dart';
import 'package:fitween/src/model/class/local.dart';
import 'package:fitween/src/model/class/model.dart';
import 'package:fitween/src/model/enum/enum.dart';

abstract class LevelLocal extends LocalModel<Level> {
  static LevelLocal? byType(FType type) {
    switch (type) {
      case FType.distance: return DistanceLevelLocal();
      case FType.height: return HeightLevelLocal();
      case FType.weight: return WeightLevelLocal();
      default: return null;
    }
  }

  @override
  String get assetPath => 'assets/json/data/level/';

  List<Level> get activeList => list.where((l) => l.activate).toList();
  List<Level> get reversedList => activeList.reversed.toList();

  @override
  Level fromJson(Map<String, dynamic> json) {
    return Level.fromJson(json);
  }

  List<Level> getAchievedList(Amount amount) {
    return activeList
        .sublist(0, getCurrent(amount) + 2)
        .reversed.toList();
  }

  int getBefore(Amount amount) {
    return max(getCurrent(amount) - 1, 0);
  }

  int getCurrent(Amount amount) {
    for (int i = 0; i < activeList.length - 1; i++) {
      if (activeList[i].amount.main > amount.main) continue;
      if (activeList[i + 1].amount.main <= amount.main) continue;
      return i;
    }
    return -1;
  }

  int getNext(Amount amount) {
    return min(getCurrent(amount) + 1, activeList.length - 1);
  }

  Level getBeforeLevel(Amount amount) => activeList[getBefore(amount)];
  Level getCurrentLevel(Amount amount) => activeList[getCurrent(amount)];
  Level getNextLevel(Amount amount) => activeList[getNext(amount)];
}

class DistanceLevelLocal extends LevelLocal {
  static final DistanceLevelLocal _instance = DistanceLevelLocal._privateConstructor();
  DistanceLevelLocal._privateConstructor();

  factory DistanceLevelLocal() => _instance;

  @override
  String get assetPath => '${super.assetPath}distance.json';
}

class HeightLevelLocal extends LevelLocal {
  static final HeightLevelLocal _instance = HeightLevelLocal._privateConstructor();
  HeightLevelLocal._privateConstructor();

  factory HeightLevelLocal() => _instance;

  @override
  String get assetPath => '${super.assetPath}height.json';
}

class WeightLevelLocal extends LevelLocal {
  static final WeightLevelLocal _instance = WeightLevelLocal._privateConstructor();
  WeightLevelLocal._privateConstructor();

  factory WeightLevelLocal() => _instance;

  @override
  String get assetPath => '${super.assetPath}weight.json';
}