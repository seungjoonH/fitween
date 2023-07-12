import 'dart:io';

import 'package:fitween/presenter/model/user/record.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:fitween/global/date.dart';
import 'package:fitween/model/enum/activity_type.dart';
import 'package:fitween/model/enum/unit.dart';
import 'package:fitween/presenter/model/record.dart';
import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';

class HealthP {
  /// static variables
  static HealthFactory health = HealthFactory();

  // 헬스 자료형
  static const stepType = [HealthDataType.STEPS];
  static const flightType = [HealthDataType.FLIGHTS_CLIMBED];
  static get types {
    if (Platform.isAndroid) return stepType;
    return stepType + flightType;
  }

  // 헬스 데이터 접근 방법
  static get read =>
      List.generate(types.length, (_) => HealthDataAccess.READ);
  static get write =>
      List.generate(types.length, (_) => HealthDataAccess.WRITE);
  static get readWrite =>
      List.generate(types.length, (_) => HealthDataAccess.READ_WRITE);

  // 데이터 접근 승인 여부
  static bool approved = false;

  /// static methods
  // 데이터 허가 요청
  static Future requestAuth() async {
    bool hasPermission = false;

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        final permissionStatus = await Permission.activityRecognition.request();
        hasPermission = !(
          permissionStatus.isDenied ||
          permissionStatus.isPermanentlyDenied
        );
        // await HealthFactory.revokePermissions();
        break;
      case TargetPlatform.iOS:
        hasPermission = await health.hasPermissions(
          types, permissions: read,
        ) ?? false;
        break;
      default: break;
    }

    if (hasPermission) {
      approved = true;
      return;
    }
    approved = await health.requestAuthorization(
      types, permissions: read,
    );
  }

  static Future<bool> fetchStepData([DateTime? startTime, DateTime? endTime]) async {
    endTime ??= startTime;
    startTime ??= now;
    endTime ??= now;
    
    DateTime startDate = ignoreTime(startTime)!;
    DateTime endDate = nextDay(ignoreTime(endTime)!);

    int steps = 0;

    // 승인 시 헬스 데이터 가져와서 로컬에 저장
    if (!approved) return false;

    final userP = Get.find<UserRecordP>();

    for (DateTime date in daysInRange(startDate, endDate)) {
      int? fetchedSteps = await health.getTotalStepsInInterval(date, nextDay(date));
      if (fetchedSteps == null || fetchedSteps == 0) return false;
      steps = fetchedSteps;

      DistanceRecord distance = DistanceRecord(
        amount: steps.toDouble(),
        state: ExerciseUnit.step,
      );

      userP.setRecord(ActivityType.distance, distance, date);
    }

    userP.save();

    return true;
  }

  // 걸음 데이터 가져오기
  static Future<bool> fetchTodayStepData() async {
    return await fetchStepData(now);
  }

  // 높이 데이터 가져오기
  static Future fetchFlightsData([DateTime? startTime, DateTime? endTime]) async {
    endTime ??= startTime;
    startTime ??= now;
    endTime ??= now;

    DateTime startDate = ignoreTime(startTime)!;
    DateTime endDate = nextDay(ignoreTime(endTime)!);

    List<HealthDataPoint> flightsData = [];

    if (!approved) return false;

    // 승인 시 헬스 데이터 가져와서 로컬에 저장
    final userP = Get.find<UserRecordP>();

    flightsData = await health.getHealthDataFromTypes(startDate, endDate, flightType);
    if (flightsData.isEmpty) return false;

    flightsData = HealthFactory.removeDuplicates(flightsData);

    Map<DateTime, double> amounts = {};

    for (var flight in flightsData) {
      double value = amounts[ignoreTime(flight.dateFrom)] ?? .0;
      value += double.parse(flight.value.toString());
      amounts[ignoreTime(flight.dateFrom)!] = value;
    }

    for (DateTime date in daysInRange(startDate, endDate)) {
      HeightRecord height = HeightRecord(amount: amounts[date] ?? .0);
      userP.setRecord(ActivityType.height, height, date);
    }

    userP.save();

    return true;
  }

  static Future fetchTodayFlightsData() async {
    return await fetchFlightsData(now);
  }

  // 걸음 데이터 저장
  static Future addStepsData(Record distance) async {
    DateTime startTime = now;
    DateTime endTime = now;
    distance.convert(ExerciseUnit.step);

    await health.writeHealthData(
      distance.amount.toDouble(),
      HealthDataType.STEPS,
      startTime, endTime,
    );
  }

  // 높이 데이터 저장
  static Future addFlightsData(Record height) async {
    DateTime startTime = today;
    DateTime endTime = now;

    await health.writeHealthData(
      height.amount.toDouble(),
      HealthDataType.FLIGHTS_CLIMBED,
      startTime, endTime,
    );
  }
}
