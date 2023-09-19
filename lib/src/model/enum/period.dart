import 'package:fitween/global/global.dart';
import 'package:fitween/src/controller/controller.dart';
import 'package:get/get.dart';

enum Period {
  daily, weekly, monthly;
  String get locale => LangCont.tr('period.$name');

  static Period? toEnum(String? string) =>
      values.firstWhereOrNull((period) => period.name == string);

  int get days => [1, 7, 30][index];

  DateTime getCurrentDate(DateTime date) => [
    date, date.firstDayOfWeek, date.firstDayOfMonth
  ][index].ignoreTime;

  DateTime getBeforeDate(DateTime date, [int offset = 0]) {
    DateTime d = getCurrentDate(date);
    for (int i = 0; i < offset; i++) {
      d = [
        d.subtract(1.d),
        d.firstDayOfLastWeek,
        d.firstDayOfLastMonth,
      ][index].ignoreTime;
    }
    return d;
  }
}