import 'package:intl/intl.dart';

var f = NumberFormat('###,###,###,###');
String toLocalString(dynamic number) => NumberFormat('###,###,###,###').format(number);

double? stringToNum(String string) {
  try { return double.parse(string); }
  catch(_) { return null; }
}

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