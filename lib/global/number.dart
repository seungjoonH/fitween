import 'dart:math' as math;
import 'package:fitween/global/global.dart';
import 'package:fitween/src/controller/lang.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

bool similar(num n1, num n2) => (n1 - n2).abs() < .001;

num maxOfList(Iterable<num> list) {
  if (list.isEmpty) return 0;
  num m = list.first;
  for (num n in list) { m = math.max(n, m); }
  return m;
}

num minOfList(Iterable<num> list) {
  if (list.isEmpty) return 0;
  num m = list.first;
  for (num n in list) { m = math.min(n, m); }
  return m;
}

num sum(Iterable<num> list) {
  if (list.isEmpty) return 0;
  List<num> temp = [...list];
  return temp.reduce((a, b) => a + b);
}

num average(Iterable<num> list) {
  return list.isEmpty ? 0 : sum(list) / list.length;
}

List<double> toDoubleList(List<num> list) {
  return list.map((e) => e.toDouble()).toList();
}

String sign(num n) => n < 0 ? '-' : '+';
String withSign(num n) => '${sign(n)}${(n).abs()}';

extension NumExtension on num {
  // num get sign => this == 0 ? 0 : this > 0 ? 1 : -1;
  String get thouSep => NumberFormat('###,###,###,###').format(this);
  String get round1 => ((this * 10).round() / 10).toStringAsFixed(1);
  String get round2 => ((this * 100).round() / 100).toStringAsFixed(2);

  String localizing({bool thouSep = true, bool scaling = true, bool txs = false}) {
    num number = this;
    String scale = '';
    String? numberString;

    if (scaling) {
      if (LangCont.isKorean) {
        if (number >= 100000000) { number /= 100000000; scale = '억'; }
        else if (number >= 10000) { number /= 10000; scale = '만'; }
      }
      else {
        if (number >= 1000000000) { number /= 1000000000; scale = 'B'; }
        else if (number >= 1000000) { number /= 1000000; scale = 'M'; }
        else if (number >= 1000) { number /= 1000; scale = 'K'; }
      }
    }

    if (scale != '') {
      if (number < 10) { numberString = number.round2.removeLastZeroOfDecimal; }
      else if (number < 100) { numberString = number.round1.removeLastZeroOfDecimal; }
    }

    numberString ??= thouSep
        ? number.round().thouSep
        : '${number.round()}';

    numberString += scale;

    return txs ? '@{$numberString}' : numberString;
  }
}

extension IntExtension on int {
  Duration get ms => Duration(milliseconds: this);
  Duration get s => Duration(seconds: this);
  Duration get m => Duration(minutes: this);
  Duration get h => Duration(hours: this);
  Duration get d => Duration(days: this);
  Duration get w => Duration(days: this * 7);

  String get year {
    if (Get.locale!.languageCode == 'ko') return '$this년';
    return '${this}y';
  }
  String get month {
    if (Get.locale!.languageCode == 'ko') return '$this개월';
    return '${this}mo';
  }
  String get day {
    if (Get.locale!.languageCode == 'ko') return '$this일';
    return '${this}d';
  }
  String get hour {
    if (Get.locale!.languageCode == 'ko') return '$this시간';
    return '${this}h';
  }
  String get minute {
    if (Get.locale!.languageCode == 'ko') return '$this분';
    return '${this}m';
  }
  String get second {
    if (Get.locale!.languageCode == 'ko') return '$this초';
    return '${this}s';
  }

  String get zPad2 => '$this'.padLeft(2, '0');
  String get zPad3 => '$this'.padLeft(3, '0');
}