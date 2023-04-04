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