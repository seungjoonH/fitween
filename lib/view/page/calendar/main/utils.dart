// import 'dart:collection';
// import 'package:table_calendar/table_calendar.dart';
//
// class Event {
//   String title;
//   int goal;
//   int amount;
//
//   Event(this.title, this.goal, this.amount);
//
//   @override
//   String toString() => title;
// }
//
// class Records {
//   List<Exercise> distance;
//   List<Exercise> height;
//   List<Exercise> weight;
//
//   Records(this.distance, this.height, this.weight);
// }
//
// class Exercise {
//   int amount;
//   DateTime date;
//
//   Exercise(this.amount, this.date);
// }
//
// final kEvents = LinkedHashMap<DateTime, List<Event>>(
//   equals: isSameDay,
//   hashCode: getHashCode,
// )..addAll(_kEventSource);
//
// final userData = insetData(kEvents, example);
//
// final _kEventSource = {
//   for (var item in List.generate(3680, (index) => index))
//     DateTime.utc(kFirstDay.year, kFirstDay.month, item):
//         List.generate(3, (index) => Event('', 40, 0))
// };
//
// int getHashCode(DateTime key) {
//   return key.day * 1000000 + key.month * 10000 + key.year;
// }
//
// List<DateTime> daysInRange(DateTime first, DateTime last) {
//   final dayCount = last.difference(first).inDays + 1;
//   return List.generate(
//     dayCount,
//     (index) => DateTime.utc(first.year, first.month, first.day + index),
//   );
// }
//
// LinkedHashMap<DateTime, List<Event>> insetData(
//     LinkedHashMap<DateTime, List<Event>> kEvents, Records example) {
//   for (int i = 0; i < example.distance.length; i++) {
//     kEvents[example.distance.elementAt(i).date]?.elementAt(0).amount =
//         example.distance.elementAt(i).amount;
//   }
//   for (int i = 0; i < example.height.length; i++) {
//     kEvents[example.height.elementAt(i).date]?.elementAt(1).amount =
//         example.height.elementAt(i).amount;
//   }
//   for (int i = 0; i < example.weight.length; i++) {
//     kEvents[example.weight.elementAt(i).date]?.elementAt(2).amount =
//         example.weight.elementAt(i).amount;
//   }
//   return kEvents;
// }
//
// final kToday = DateTime.now();
// final kFirstDay = DateTime(kToday.year - 5, kToday.month, kToday.day);
// final kLastDay = DateTime(kToday.year + 5, kToday.month, kToday.day);
// final example = Records(
//   [
//     Exercise(
//       20,
//       DateTime.utc(
//         DateTime.now().year,
//         DateTime.now().month,
//         DateTime.now().day - 1,
//       ),
//     ),
//     Exercise(
//       20,
//       DateTime.utc(
//         DateTime.now().year,
//         DateTime.now().month,
//         DateTime.now().day,
//       ),
//     ),
//     Exercise(
//       20,
//       DateTime.utc(
//         DateTime.now().year,
//         DateTime.now().month,
//         DateTime.now().day + 1,
//       ),
//     ),
//   ],
//   [
//     Exercise(
//       20,
//       DateTime.utc(
//         DateTime.now().year,
//         DateTime.now().month,
//         DateTime.now().day - 1,
//       ),
//     ),
//     Exercise(
//       20,
//       DateTime.utc(
//         DateTime.now().year,
//         DateTime.now().month,
//         DateTime.now().day,
//       ),
//     ),
//   ],
//   [
//     Exercise(
//       20,
//       DateTime.utc(
//         DateTime.now().year,
//         DateTime.now().month,
//         DateTime.now().day - 1,
//       ),
//     ),
//     Exercise(
//       20,
//       DateTime.utc(
//         DateTime.now().year,
//         DateTime.now().month,
//         DateTime.now().day,
//       ),
//     ),
//   ],
// );
