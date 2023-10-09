import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/model/enum/enum.dart';
import 'package:get/get.dart';

class FPointCalculator {
  late num goal;
  late num does;
  late FType type;
  late Period period;

  FPointCalculator({
    required this.goal,
    required this.does,
    required this.type,
    required this.period,
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

  num getWeight(Period period) => [
    _dailyWeight, _weeklyWeight, _monthlyWeight
  ][period.index];

  num get _periodicalGoal => goal * period.days;
  bool get _met => _periodicalGoal <= does;
  num get _progressPoint => (5 * does / _adjustedValue).round();
  num get _goalPoint => (_met ? (goal - _default) * 5 : .0).round();
  num get _metPoint => (_met ? 50.0 : .0).round();
  late int rank, entire;
  num get _rankPoint => 2 - (rank + 1) / entire;

  int get estimatedFPoint {
    return (_progressPoint + _goalPoint + _metPoint).round();
  }

  int getRankedFPoint(int rank, int entire) {
    this.rank = rank;
    this.entire = entire;
    return (getWeight(period) * estimatedFPoint * _rankPoint).round();
  }

  String get _tr => 'fpoint';
  String get _progressText => LangCont.tr('$_tr.progression');
  String get _goalText => LangCont.tr('$_tr.goal');
  String get _metText => LangCont.tr('$_tr.achievement');
  String get _rankText => LangCont.tr('$_tr.top');
  String get _periodText => LangCont.tr('$_tr.period');
  String get _successText => LangCont.tr('$_tr.success');
  String get _failText => LangCont.tr('$_tr.fail');

  String get pointText {
    String text = '';
    text += '+ $_progressPoint ($_progressText ${type.withUnit(does.round())})\n';
    text += '+ $_goalPoint ($_goalText ${type.withUnit(_periodicalGoal.round())})\n';
    text += '+ $_metPoint ($_metText ${_met ? _successText : _failText})\n';
    text += 'x ${(_rankPoint * 100).round() / 100} ($_rankText ${(100 * (rank + 1) / entire).round()}%)\n';
    text += 'x ${getWeight(period)} ($_periodText ${period.locale.capitalize})';
    return text;
  }
}