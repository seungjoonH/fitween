import 'dart:math';

import 'package:fitween/src/controller/controller.dart';
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
  static int getLv(FType type, num value) {
    LevelLocal local = byType(type)!;
    switch (type) {
      case FType.distance:
        return local.getCurrent(DistanceAmount()..step = value);
      case FType.height:
        return local.getCurrent(HeightAmount()..floor = value);
      case FType.weight:
        return local.getCurrent(WeightAmount()..cnt = value);
      default: return 0;
    }
  }

  FType get type;

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

  int getBefore([Amount? amount]) {
    return max(getCurrent(amount) - 1, 0);
  }

  int getCurrent([Amount? amount]) {
    var cont = RecordCont.logged()..syncFromUser();
    num value = cont.getAllValue(type);

    switch (type) {
      case FType.distance:
        amount ??= DistanceAmount()..step = value; break;
      case FType.height:
        amount ??= HeightAmount()..floor = value; break;
      case FType.weight:
        amount ??= WeightAmount()..kg = value; break;
      default: break;
    }

    for (int i = 0; i < activeList.length - 1; i++) {
      if (activeList[i].amount.main > amount!.main) continue;
      if (activeList[i + 1].amount.main <= amount.main) continue;
      return i;
    }
    return -1;
  }

  int getNext([Amount? amount]) {
    return min(getCurrent(amount) + 1, activeList.length - 1);
  }

  Level getBeforeLevel([Amount? amount]) => activeList[getBefore(amount)];
  Level getCurrentLevel([Amount? amount]) => activeList[getCurrent(amount)];
  Level getNextLevel([Amount? amount]) => activeList[getNext(amount)];
}

class DistanceLevelLocal extends LevelLocal {
  static final DistanceLevelLocal _instance = DistanceLevelLocal._privateConstructor();
  DistanceLevelLocal._privateConstructor();

  factory DistanceLevelLocal() => _instance;

  @override
  FType get type => FType.distance;

  @override
  String get assetPath => '${super.assetPath}distance.json';
}

class HeightLevelLocal extends LevelLocal {
  static final HeightLevelLocal _instance = HeightLevelLocal._privateConstructor();
  HeightLevelLocal._privateConstructor();

  factory HeightLevelLocal() => _instance;

  @override
  FType get type => FType.height;

  @override
  String get assetPath => '${super.assetPath}height.json';
}

class WeightLevelLocal extends LevelLocal {
  static final WeightLevelLocal _instance = WeightLevelLocal._privateConstructor();
  WeightLevelLocal._privateConstructor();

  factory WeightLevelLocal() => _instance;

  @override
  FType get type => FType.weight;

  @override
  String get assetPath => '${super.assetPath}weight.json';
}