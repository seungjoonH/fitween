import 'dart:math';

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

class Range {
  final double start;
  final double end;
  Range(this.start, this.end);

  bool overlaps(Range other) {
    if (other.start > start && other.start < end) return true;
    if (other.end > end && other.end < end) return true;
    return false;
  }

  static bool between(int number, int floor, int ciel) {
    return number > floor && number <= ciel;
  }
}

class ProbabilityGenerator {
  final Random _rand = Random();

  ProbabilityGenerator();

  bool generateWithProbability(double percent) {
    var randomInt = _rand.nextInt(100) + 1; // generate a number 1-100 inclusive
    return randomInt <= percent;
  }
}