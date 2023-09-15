import 'dart:math';

import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/model/enum/enum.dart';

class FPointCalculator {
  late num goal;
  late num does;
  late FType type;

  FPointCalculator({
    required this.goal,
    required this.does,
    required this.type,
  });

  static const num _disAdj = 1500;
  static const num _heiAdj = 2;
  static const num _weiAdj = 8;

  static num get _disDefault => GoalSettingPageCont.defaultDis.step;
  static num get _heiDefault => GoalSettingPageCont.defaultHei.floor;
  static num get _weiDefault => GoalSettingPageCont.defaultWei.cnt;

  static const num _dailyWeight = 1;
  static const num _weeklyWeight = 3;
  static const num _monthlyWeight = 10;

  num get _adjustedValue {
    assert(type != FType.calorie);
    return [_disAdj, _heiAdj, _weiAdj][type.index - 1];
  }

  num get _default {
    assert(type != FType.calorie);
    return [_disDefault, _heiDefault, _weiDefault][type.index - 1];
  }

  num getWeight(Period period) => [_dailyWeight, _weeklyWeight, _monthlyWeight][period.index];

  int get estimatedFPoint {
    bool completed = goal <= does;
    num doingPoint = min(5 * does / _adjustedValue, 100);
    num goalPoint = completed ? (goal - _default) * 5 : .0;
    num metPoint = completed ? 50.0 : .0;
    return (doingPoint + goalPoint + metPoint).ceil();
  }

  int getPeriodlyRankedFPoint(Period period, int rank) {
    return (getWeight(period) * estimatedFPoint * max(4 - rank, 1)).ceil();
  }
}