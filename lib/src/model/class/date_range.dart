import 'package:fitween/global/global.dart';

class DateRange {
  late DateTime start;
  late DateTime end;

  DateRange(this.start, [DateTime? end]) {
    this.end = start;
    if (end != null) this.end = end;
  }

  int get days => end.difference(start).inDays + 1;
  bool inRange(DateTime date) {
    bool same = date.isAtSameMomentAs(start) || date.isAtSameMomentAs(end);
    return same || date.isAfter(start) && date.isBefore(end);
  }
  List<DateTime> get dates {
    DateTime getDate(int i) => DateTime.utc(start.year, start.month, start.day + i).ignoreTime;
    return List.generate(days + 1, getDate);
  }

  List<DateTime> get times {
    DateTime getTime(int i) => start.ignoreTime.add(i.h);
    return List.generate(24, getTime);
  }
}