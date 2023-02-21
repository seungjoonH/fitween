/* 사용자 모델 구조 */

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:fitween/global/date.dart';
import 'package:fitween/model/class/database/collection.dart';
import 'package:fitween/model/class/database/party.dart';
import 'package:fitween/model/enum/activity_type.dart';
import 'package:fitween/model/enum/unit.dart';
import 'package:fitween/model/enum/sex.dart';
import 'package:fitween/presenter/model/record.dart';

class FUserRecord {
  /// attributes
  // 일반 변수
  String? uid;

  // 복합 변수
  Map<String, dynamic> goals = {};
  Map<String, dynamic> inputRecords = {};
  Map<String, dynamic> records = {};

  /// accessors & mutators
  List<ActivityType> get completedActivities {
    List<ActivityType> types = [];
    for (ActivityType type in ActivityType.activeValues.sublist(0, 3)) {
      if (completed(type)) types.add(type);
    }
    return types;
  }

  /// constructors
  FUserRecord() {
    for (var type in ActivityType.activeValues) {
      goals[type.name] = 0;
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

    alreadyExist = (records[type.name] ?? [])
        .map((rec) => rec['date']).contains(toTimestamp(date));

    if (alreadyExist) {
      for (var rec in records[type.name] ?? []) {
        if (rec['date'] == toTimestamp(date)) {
          rec['amount'] += amount;
          break;
        }
      }
    }
    else {
      records[type.name] ??= [];
      records[type.name].add({
        'date': toTimestamp(date),
        'amount': amount,
      });
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
    double result = 0;

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
  double getTodayInputAmounts(ActivityType activityType) {
    double result = 0;
    DateTime startDate = today;
    DateTime endDate = oneSecondBefore(tomorrow);

    inputRecords.forEach((type, recordList) {
      if (activityType.name == type) {
        for (var record in recordList) {
          if (record['date'].toDate().isBefore(startDate)) continue;
          if (record['date'].toDate().isAfter(endDate)) continue;
          result += record['amount'].toDouble();
        }
      }
    });
    return result;
  }

  Record? getGoal(ActivityType type) {
    ExerciseUnit? unit = {
      ActivityType.distance: ExerciseUnit.step,
      ActivityType.weight: ExerciseUnit.count,
    }[type];
    return Record.init(
      type, goals[type.name]?.toDouble() ?? .0,
      unit,
    );
  }

  void setGoal(ActivityType type, Record record) {
    if (type == ActivityType.distance) record.convert(ExerciseUnit.step);
    if (type == ActivityType.weight) record.convert(ExerciseUnit.count);
    goals[type.name] = record.amount;
  }

  // 해당 활동형식의 완료 여부 반환
  bool completed(ActivityType type) {
    double goal = goals[type.name]?.toDouble() ?? .0;
    double value = getTodayAmounts(type);
    return goal <= value;
  }
}
