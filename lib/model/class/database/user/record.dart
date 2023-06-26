/* 사용자 모델 구조 */

import 'dart:collection';

import 'package:fitween/global/date.dart';
import 'package:fitween/model/enum/activity_type.dart';
import 'package:fitween/model/enum/unit.dart';
import 'package:fitween/presenter/model/record.dart';
import 'package:fitween/presenter/model/user/info.dart';
import 'package:fitween/presenter/page/home/calendar.dart';
import 'package:get/get.dart';

class FUserRecord {
  /// attributes
  // 일반 변수
  String? uid;

  // 복합 변수
  Map<String, dynamic> goals = {};
  Map<String, dynamic> inputRecords = {};
  Map<String, dynamic> records = {};

  /// constructors
  FUserRecord() {
    for (var type in ActivityType.activeValues) {
      goals[type.name] = [];
      inputRecords[type.name] = [];
      records[type.name] = [];
    }
  }

  FUserRecord.fromJson(Map<String, dynamic> json) {
    fromJson(json);
  }

  /// methods
  void fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    goals = json['goals'] ?? {};
    inputRecords = json['inputRecords'] ?? {};
    records = json['records'] ?? {};
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['uid'] = uid;
    json['goals'] = goals;
    json['inputRecords'] = inputRecords;
    json['records'] = records;
    return json;
  }

  /// methods
  List<DateTime> get accessHistory {
    List<DateTime> dates = [];
    for (var rec in records[ActivityType.calorie] ?? []) {
      dates.add(rec['date'].toDate());
    }
    return dates;
  }

  // 기록 추가
  void addRecord(
    ActivityType type,
    DateTime date,
    Record record, [
      bool input = false,
  ]) {
    double amount = type == ActivityType.distance
        ? (record as DistanceRecord).step : record.amount;

    late bool alreadyExist;

    alreadyExist = (inputRecords[type.name] ?? [])
        .map((rec) => rec['date']).contains(toTimestamp(date));

    if (input) {
      if (alreadyExist) {
        for (var rec in inputRecords[type.name] ?? []) {
          if (rec['date'] == toTimestamp(date)) {
            rec['amount'] += amount;
            break;
          }
        }
      }
      else {
        inputRecords[type.name] ??= [];
        inputRecords[type.name].add({
          'date': toTimestamp(date),
          'amount': amount,
        });
      }
    }
  }

  // 기록 설정
  void setRecord(
      ActivityType type,
      DateTime date,
      Record record,
      [ExerciseUnit? unit]
      ) {
    for (var rec in records[type.name] ?? []) {
      if (rec['date'] == toTimestamp(date)) {
        if (unit != null) record.convert(unit);
        rec['amount'] = record.amount;
        return;
      }
    }

    records[type.name] ??= [];
    records[type.name].add({
      'date': toTimestamp(date),
      'amount': record.amount,
    });
  }

  void duplicateInputRecords() {
    for (ActivityType type in ActivityType.values) {
      for (var rec in records[type.name] ?? []) {
        for (var inputRec in inputRecords[type.name] ?? []) {
          if (rec['date'] == inputRec['date']) {
            rec['amount'] += inputRec['amount'];
          }
        }
      }
    }
  }

  // 금일 기록 반환
  double getTodayAmounts(ActivityType type) {
    return getAmounts(type, today, oneSecondBefore(tomorrow));
  }

  // 금월 기록 반환
  double getThisMonthAmounts(ActivityType type) {
    DateTime firstDate = DateTime((today).year, (today).month, 1);
    DateTime lastDate = DateTime((today).year, (today).month + 1, 1)
        .subtract(const Duration(days: 1));

    return getAmounts(type, firstDate, lastDate);
  }

  // 기록 반환
  double getAmounts(
      ActivityType activityType, [
        DateTime? startDate,
        DateTime? endDate,
      ]) {
    double result = .0;

    startDate ??= ignoreTime(Get.find<UserInfoP>().loggedUser.regDate!);
    endDate ??= nextDay(today);

    inputRecords.forEach((type, recordList) {
      if (activityType.name == type) {
        for (var record in recordList) {
          if (startDate != null && record['date'].toDate().isBefore(startDate)) continue;
          if (endDate != null && record['date'].toDate().isAfter(endDate)) continue;
          result += record['amount'].toDouble();
        }
      }
    });
    records.forEach((type, recordList) {
      if (activityType.name == type) {
        for (var record in recordList) {
          if (startDate != null && record['date'].toDate().isBefore(startDate)) continue;
          if (endDate != null && record['date'].toDate().isAfter(endDate)) continue;
          result += record['amount'].toDouble();
        }
      }
    });

    return result;
  }

  // 입력된 금일 기록 반환
  // double getTodayInputAmounts(ActivityType activityType) {
  //   double result = 0;
  //   DateTime startDate = today;
  //   DateTime endDate = oneSecondBefore(tomorrow);
  //
  //   inputRecords.forEach((type, recordList) {
  //     if (activityType.name == type) {
  //       for (var record in recordList) {
  //         if (record['date'].toDate().isBefore(startDate)) continue;
  //         if (record['date'].toDate().isAfter(endDate)) continue;
  //         result += record['amount'].toDouble();
  //       }
  //     }
  //   });
  //   return result;
  // }

  LinkedHashMap<DateTime, List<CalendarEvent>> getEvents(
    DateTime startDate, DateTime endDate,
  ) {
    List<CalendarEvent> eventValues = [
      for (ActivityType type in ActivityType.activeValues)
      CalendarEvent(getGoal(type, today)?.amount ?? 1.0, .0),
    ];

    LinkedHashMap<DateTime, List<CalendarEvent>> events = LinkedHashMap.from({
      for (DateTime date in daysInRange(startDate, endDate))
      ignoreTime(date) : eventValues,
    });

    for (DateTime date in daysInRange(startDate, endDate)) {
      date = ignoreTime(date)!;
      events[date] = ActivityType.activeValues.map((type) {
        double goal = getGoal(type, date)?.amount ?? 1.0;
        double amount = getAmounts(type, date, nextDay(date));
        return CalendarEvent(goal, amount);
      }).toList();
    }

    return events;
  }

  Record? getGoal(ActivityType type, DateTime date) {
    ExerciseUnit? unit = {
      ActivityType.distance: ExerciseUnit.step,
      ActivityType.weight: ExerciseUnit.count,
    }[type];

    double amount = 1.0;

    for (var goal in goals[type.name].reversed) {
      if (!ignoreTime(goal['date'].toDate())!.isAfter(date)) {
        amount = goal['amount'].toDouble();
        break;
      }
    }

    return Record.init(type, amount, unit);
  }

  void setGoal(
    ActivityType type,
    DateTime date,
    Record record, [
      ExerciseUnit? unit
  ]) {
    if (unit != null) record.convert(unit);

    double dateGoal = getGoal(type, date)!.amount;
    double tomorrowGoal = getGoal(type, tomorrow)!.amount;

    if (dateGoal.round() == record.amount.round()) {
      if (tomorrowGoal.round() == record.amount.round()) return;
      List<dynamic> newGoal = [];

      for (var goal in goals[type.name]) {
        if (goal['date'].toDate().isAfter(today)) break;
        newGoal.add(goal);
      }

      goals[type.name] = newGoal;
      return;
    }

    DateTime nextDay = ignoreTime(date.add(const Duration(days: 1)))!;

    for (var goal in goals[type.name] ?? []) {
      if (goal['date'] == toTimestamp(nextDay)) {
        goal['amount'] = record.amount.round();
        return;
      }
    }

    goals[type.name] ??= [];
    goals[type.name].add({
      'date': toTimestamp(nextDay),
      'amount': record.amount.round(),
    });
  }

  List<ActivityType> completedActivities([DateTime? date]) {
    date ??= today;
    List<ActivityType> types = [];
    for (ActivityType type in ActivityType.activeValues) {
      if (completed(type, date)) types.add(type);
    }
    return types;
  }

  // 해당 활동형식의 완료 여부 반환
  bool completed(ActivityType type, [DateTime? date]) {
    date ??= today;
    double goal = getGoal(type, date)?.amount ?? .0;
    double value = getAmounts(type, date, nextDay(date));
    return goal <= value;
  }
}
