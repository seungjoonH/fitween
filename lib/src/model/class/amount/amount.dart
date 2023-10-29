import 'package:fitween/global/number.dart';
import 'package:fitween/src/controller/lang.dart';
import 'package:fitween/src/controller/page.dart';
import 'package:fitween/src/controller/user/auth.dart';
import 'package:fitween/src/model/enum/ftype.dart';

abstract class Amount {
  num get main;
  num value = 0;

  String _p(String key, num value) {
    return LangCont.plural('unit.$key', value.round());
  }
}

class LengthAmount extends Amount {
  @override
  num get main => m;

  num get mm => m * 1000;
  num get cm => m * 100;
  num get m => value;
  num get km => m / 1000;
  num get inch => m * 39.3700787402;
  num get ft => inch / 12;
  num get yd => ft / 3;
  num get mi => yd / 1760;

  String get mmUnit => '${mm.round1} mm';
  String get cmUnit => '${cm.round1} cm';
  String get meterUnit => '${m.round1} m';
  String get kmUnit => '${km.round1} km';
  String get inchUnit => '${inch.round1} inch';
  String get ftUnit => '${ft.round1} ft';
  String get ydUnit => '${yd.round1} yd';
  String get miUnit => '${mi.round1} mi';
  String get ftinUnit {
    num feet = ft.floor();
    num rem = ft - feet;
    num inches = (LengthAmount()..ft = rem).inch.round();
    if (inches ~/ 12 > 0) { feet++; inches -= 12; }
    return '$feet\' $inches"';
  }

  set mm(num v) => m = v / 1000;
  set cm(num v) => m = v / 100;
  set m(num v) => value = v;
  set km(num v) => m = v * 1000;
  set inch(num v) => m = v / 39.3700787402;
  set ft(num v) => inch = v * 12;
  set yd(num v) => ft = v * 3;
  set mi(num v) => yd = v * 1760;
}

class DistanceAmount extends LengthAmount {
  @override
  num get main => step;

  static const num stride = .74; // [m/step]
  static const num vel = 82.288; // [m/minute]

  num get step => value / stride;
  num get min => value / vel;
  num get hr => min / 60;
  num get sec => min * 60;
  num get msec => sec * 1000;

  String get stepUnit => FType.distance.withUnit(step, scaling: false);
  String get hourUnit => _p('hour', hr);
  String get hrUnit => _p('hr', hr);
  String get hUnit => _p('h', hr);
  String get minuteUnit => _p('minute', min);
  String get minUnit => _p('min', min);
  String get mUnit => _p('m', min);
  String get secondUnit => _p('second', sec);
  String get secUnit => _p('sec', sec);
  String get sUnit => _p('s', sec);

  set step(num v) => value = v * stride;
  set hr(num v) => min = v * 60;
  set min(num v) => value = v * vel;
  set sec(num v) => min = v / 60;
  set msec(num v) => sec = v / 1000;
}

class HeightAmount extends LengthAmount {
  @override
  num get main => floor;

  num get floor => m / 3;
  num get lTime => floor * 100;

  String get floorUnit => FType.height.withUnit(floor, scaling: false);
  String get lTimeUnit {
    num t = lTime;
    int h = t ~/ 3600; t %= 3600;
    int m = t ~/ 60; t %= 60;
    int s = t.round();

    String string = '';

    if (h > 0) string += '${_p('h', h)} ';
    if (m > 0) string += '${_p('m', m)} ';
    if (s > 0) string += _p('s', s);
    if (string.isEmpty) string = '0s';

    return string;
  }

  set floor(num v) => m = v * 3;
  set lTime(num v) => floor = v / 100;

}

class WeightAmount extends Amount {
  static num get w => AuthCont.logged?.weight
      ?? RegisterPageCont.to.weight;

  @override
  num get main => cnt;

  num get mg => g * 1000;
  num get g => value;
  num get kg => g / 1000;
  num get t => kg / 1000;
  num get lb => g / 453.59237;
  num get cnt => kg / w;

  String get mgUnit => '${mg.round1} mg';
  String get gUnit => '${g.round1} g';
  String get kgUnit => '${kg.round1} kg';
  String get tUnit => '${t.round1} t';
  String get lbUnit => '${lb.round1} lb';
  String get cntUnit => FType.weight.withUnit(cnt, scaling: false);

  set mg(num v) => g = v / 1000;
  set g(num v) => value = v;
  set kg(num v) => g = v * 1000;
  set t(num v) => kg = v * 1000;
  set lb(num v) => g = v * 453.59237;
  set cnt(num v) => kg = v * w;
}