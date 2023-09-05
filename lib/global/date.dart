/* 날짜, 시간 관련 */

import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitween/global/global.dart';
import 'package:fitween/src/controller/lang.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ntp/ntp.dart';

/// enums
// 날짜 형식 { 시작일, 종료일 }
enum DateType { start, end }

/// global variables
late Duration timeError;

// 시간 오차 설정
void setTimeError() async {
  timeError = (await NTP.now()).difference(DateTime.now());
}

// 현재 시각
// DateTime get now => DateTime.now().add(timeError);
DateTime get now => DateTime.now();

// 오늘 날짜 (시간 미포함)
DateTime get today => now.ignoreTime;

// 어제 날짜`
DateTime get yesterday => today.subtract(const Duration(days: 1));

// 내일 날짜
final tomorrow = today.add(const Duration(days: 1));

String? dateToString(String format, DateTime? date) => date == null
    ? null : DateFormat(format).format(date);

DateTime? stringToDate(String string) {
  if (DateTime.tryParse(string) == null) return null;
  DateTime? date = DateTime.parse(string);

  bool available = date.year == int.parse(string.substring(0, 4));
  available &= date.month == int.parse(string.substring(4, 6));
  available &= date.day == int.parse(string.substring(6));

  return available ? DateTime.parse(string) : null;
}

String timeToString(int timeInSecs) {
  late int days, hours, minutes, seconds;
  seconds = timeInSecs;

  days = seconds ~/ (60 * 60 * 24);
  seconds -= days * (60 * 60 * 24);
  hours = seconds ~/ (60 * 60);
  seconds -= hours * (60 * 60);
  minutes = seconds ~/ 60;
  seconds -= minutes * 60;

  List<String> output = [];

  if (days > 0) output.add('$days일');
  if (hours > 0) output.add('$hours시간');
  if (minutes > 0) output.add('$minutes분');
  if (seconds > 0 || (days + hours + minutes == 0)) output.add('$seconds초');

  return output.join(' ');
}

List<DateTime> daysInRange(DateTime first, DateTime last) {
  final dayCount = last.difference(first).inDays + 1;
  return List.generate(
    dayCount, (index) => DateTime.utc(first.year, first.month, first.day + index).ignoreTime,
  );
}

Future delay(Duration d, [VoidCallback? f]) async => await Future.delayed(d, f);

DateTime earlier(DateTime a, DateTime b) => a.isBefore(b) ? a : b;
DateTime later(DateTime a, DateTime b) => a.isAfter(b) ? a : b;

extension DateTimeExtension on DateTime {
  Timestamp? get toTimestamp => nullOrB(this, Timestamp.fromDate(this));

  bool sameDay(DateTime other) => year == other.year && month == other.month && day == other.day;

  DateTime get ignoreTime => nullOrB(this, DateTime(year, month, day));
  DateTime get oneSecBefore => subtract(1.s);
  DateTime get lastTimeOfDay => add(1.d).oneSecBefore;

  DateTime get firstDayOfMonth => DateTime(year, month, 1);
  DateTime get lastDayOfMonth => DateTime(year, month + 1, 1).subtract(1.d);
  DateTime get firstDayOfWeek => subtract(wd.index.d).ignoreTime;
  DateTime get lastDayOfWeek => firstDayOfWeek.add(6.d);

  int get age => now.difference(this).inDays ~/ 365.25;
  int get generation => age ~/ 10 * 10;

  Weekday get wd => Weekday.values[weekday - 1];
}

extension DurationExtension on Duration {
  int get inFormatDays => inDays;
  int get inFormatHours => inHours - inDays * 24;
  int get inFormatMinutes => inMinutes - inHours * 60;
  int get inFormatSeconds => inSeconds - inMinutes * 60;

  String get inDaysUnit => LangCont.plural('unit.d', inDays);
  String get inHoursUnit => LangCont.plural('unit.h', inHours);
  String get inMinutesUnit => LangCont.plural('unit.m', inMinutes);
  String get inSecondsUnit => LangCont.plural('unit.s', inSeconds);

  String get inFormatDaysUnit => LangCont.plural('unit.d', inFormatDays);
  String get inFormatHoursUnit => LangCont.plural('unit.h', inFormatHours);
  String get inFormatMinutesUnit => LangCont.plural('unit.m', inFormatMinutes);
  String get inFormatSecondsUnit => LangCont.plural('unit.s', inFormatSeconds);

  String get format {
    String str = '';
    if (inFormatDays > 0) str += '$inFormatDaysUnit ';
    if (inFormatHours > 0) str += '$inFormatHoursUnit ';
    if (inFormatMinutes > 0) str += '$inFormatMinutesUnit ';
    if (inFormatSeconds > 0) str += '$inFormatSecondsUnit ';
    return str;
  }

  String get withUnit {
    if (inDays > 0) { return inDaysUnit; }
    else if (inHours > 0) { return inHoursUnit; }
    else if (inMinutes > 0) { return inMinutesUnit; }
    return inSecondsUnit;
  }

  String get left => '$format${LangCont.tr('time.left')}';
  String get ago => '$withUnit ${LangCont.tr('time.ago')}';
}

enum Weekday {
  mon, tue, wed, thu, fri, sat, sun;
  String get _tr => 'weekdays.$name';
  String get long => LangCont.tr('$_tr.l');
  String get mid => LangCont.tr('$_tr.m');
  String get short => LangCont.tr('$_tr.s');
}