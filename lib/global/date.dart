/* 날짜, 시간 관련 */

import 'package:cloud_firestore/cloud_firestore.dart';
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
DateTime get now => DateTime.now().add(timeError);

// 오늘 날짜 (시간 미포함)
DateTime get today => ignoreTime(now);

// 어제 날짜
DateTime get yesterday => today.subtract(const Duration(days: 1));

// 내일 날짜
final tomorrow = today.add(const Duration(days: 1));

/// global functions
DateTime oneSecondBefore(DateTime date) => date.subtract(const Duration(seconds: 1));

bool isSameDay(DateTime date1, DateTime date2) {
  return date1.year == date2.year
      && date1.month == date2.month
      && date1.day == date2.day;
}

// 날짜에서 시간을 제외하여 반환
DateTime ignoreTime(DateTime date) => DateTime(date.year, date.month, date.day);

// DateTime 형식을 Timestamp 형식으로 변환
Timestamp? toTimestamp(DateTime? date) => date == null
    ? null : Timestamp.fromDate(date);

// 날짜를 문자열 형태로 변환
String? dateToString(String format, DateTime? date) => date == null
    ? null : DateFormat(format).format(date);

// 문자열을 날짜 형태로 변환
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