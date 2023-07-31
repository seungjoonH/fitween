import 'package:get/get.dart';
import 'package:intl/intl.dart';

var f = NumberFormat('###,###,###,###');
String toLocalString(dynamic number) => f.format(number);

double? stringToNum(String string) {
  try { return double.parse(string); }
  catch(_) { return null; }
}

bool similar(num n1, num n2) => (n1 - n2).abs() < .001;

num sum(List<num> list) {
  List<num> temp = [...list];
  return temp.reduce((a, b) => a + b);
}

num average(List<num> list) {
  return sum(toDoubleList(list)) / list.length;
}

List<double> toDoubleList(List<num> list) {
  return list.map((e) => e.toDouble()).toList();
}

String sign(num n) => n < 0 ? '-' : '+';
String withSign(num n) => '${sign(n)}${(n).abs()}';

extension DoubleExtension on double {
  String? get round1 {
    String string = toStringAsFixed(1);
    Iterable<String> split = string.split('.');
    if (split.last == '0') return split.first;
    return string;
  }

  String? get short {
    double amount = this;
    if (Get.locale!.languageCode == 'ko') {
      if (amount >= 100000000) { return '${((amount / 10000000).toDouble() / 10).round1}억'; }
      if (amount >= 10000) { return '${((amount / 1000).toDouble() / 10).round1}만'; }
    }
    else {
      if (amount >= 1000000000) { return '${((amount / 100000000).toDouble() / 10).round1}B'; }
      else if (amount >= 1000000) { return '${((amount / 100000).toDouble() / 10).round1}M'; }
      else if (amount >= 1000) { return '${((amount / 100).toDouble() / 10).round1}K'; }
    }
    return toLocalString(amount.toInt());
  }
}