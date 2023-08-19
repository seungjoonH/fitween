import 'package:fitween/src/model/class/amount/amount.dart';
import 'package:fitween/src/model/class/local.dart';
import 'package:fitween/src/model/class/model.dart';

abstract class LevelLocal extends LocalModel<Level> {
  @override
  String get assetPath => 'assets/json/data/level/';

  List<Level> get _activeList => list.where((l) => l.activate).toList();

  @override
  Level fromJson(Map<String, dynamic> json) {
    return Level.fromJson(json);
  }

  int _getCurrent(Amount amount) {
    return _activeList.lastIndexWhere((l) {
      return l.activate && amount.value >= l.amount.value;
    });
  }

  Level getCurrentLevel(Amount amount) {
    return _activeList[_getCurrent(amount)];
  }

  Level getNextLevel(Amount amount) {
    int curIndex = _getCurrent(amount);
    if (_activeList.length == curIndex) return _activeList[curIndex];
    return _activeList[curIndex + 1];
  }

  double getPercent(Amount amount) {
    Level cur = getCurrentLevel(amount);
    Level nex = getNextLevel(amount);
    num range = nex.amount.value - cur.amount.value;
    return amount.value / range;
  }
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