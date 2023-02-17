import 'dart:collection';
import 'package:table_calendar/table_calendar.dart';

class Event {
  String title;
  int goal;
  int amount;
  bool clear;

  Event(this.title, this.goal, this.amount, this.clear);

  @override
  String toString() => title;
}

final kEvents = LinkedHashMap<DateTime, List<Event>>(
  equals: isSameDay,
  hashCode: getHashCode,
)..addAll(_kEventSource);

final _kEventSource = {
  for (var item in List.generate(3680, (index) => index))
    DateTime.utc(kFirstDay.year, kFirstDay.month, item):
        List.generate(3, (index) => Event('a', 20, 10, false))
};

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

List<DateTime> daysInRange(DateTime first, DateTime last) {
  final dayCount = last.difference(first).inDays + 1;
  return List.generate(
    dayCount,
    (index) => DateTime.utc(first.year, first.month, first.day + index),
  );
}

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year - 5, kToday.month, kToday.day);
final kLastDay = DateTime(kToday.year + 5, kToday.month, kToday.day);
