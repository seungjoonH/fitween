import 'dart:io';

import 'package:fitween/global/global.dart';
import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/model/class/dao.dart';
import 'package:fitween/src/model/class/date_range.dart';
import 'package:fitween/src/model/class/model.dart';
import 'package:fitween/src/model/enum/ftype.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';

class HealthDataCont extends GetxController {
  static final _health = HealthFactory();
  static const _stepType = [HealthDataType.STEPS];
  static const _flightType = [HealthDataType.FLIGHTS_CLIMBED];

  static get _types {
    if (Platform.isAndroid) return _stepType;
    return _stepType + _flightType;
  }

  static get _read =>
      List.generate(_types.length, (_) => HealthDataAccess.READ);
  // static get _write =>
  //     List.generate(_types.length, (_) => HealthDataAccess.WRITE);
  // static get _readWrite =>
  //     List.generate(_types.length, (_) => HealthDataAccess.READ_WRITE);


  static bool _approved = false;

  static Future requestPermission() async {
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
        hasPermission = await _health.hasPermissions(
          _types, permissions: _read,
        ) ?? false;
        break;
      default: break;
    }

    if (hasPermission) { _approved = true; return; }
    _approved = await _health.requestAuthorization(
      _types, permissions: _read,
    );
  }

  static FUser get _logged => AuthCont.logged!;

  static Map<DateTime, num> _fetchedSteps = {};
  static Map<DateTime, num> _fetchedFlights = {};

  static void initStepsData(DateTime startTime, DateTime endTime) {
    DateRange range = DateRange(startTime, endTime);
    for (DateTime date in range.dates) { _fetchedSteps[date] = .0; }
  }

  static void initFlightsData(DateTime startTime, DateTime endTime) {
    DateRange range = DateRange(startTime, endTime);
    for (DateTime date in range.dates) { _fetchedFlights[date] = .0; }
  }

  static num getStepsData(DateTime date) => _fetchedSteps[date] ?? .0;
  static num getFlightsData(DateTime date) => _fetchedFlights[date] ?? .0;
  static num getDataByType(FType type, DateTime date) {
    return _byType(type)![date] ?? .0;
  }

  static Map<DateTime, num>? _byType(FType type) {
    assert(FType.activeValues.contains(type));
    return [_fetchedSteps, _fetchedFlights, <DateTime, num>{}][type.index - 1];
  }

  static Future setRecordByType(FType type, DateTime startTime, DateTime endTime) async {
    startTime = later(startTime, _logged.regDate);
    endTime = earlier(endTime.lastTimeOfDay, now);
    DateRange range = DateRange(startTime, endTime);

    for (DateTime date in range.dates) {
      if (!(_byType(type)?.keys.contains(date) ?? false)) continue;
      _logged.setRecordByValue(type, _byType(type)![date]!, date);
    }
    await FUserRecordDAO().saveOne(_logged.record!);
  }

  static Future setOneDayRecordByType(FType type, DateTime date) async {
    await setRecordByType(type, date, date);
  }

  static Future setTodayRecordByType(FType type) async {
    await setOneDayRecordByType(type, today);
  }

  static Future setTodayRecord() async {
    await setTodayRecordByType(FType.distance);
    await setTodayRecordByType(FType.height);
  }

  static Future fetchDataAfterLogin() async {
    await fetchTodayStepData();
    if (Platform.isIOS) await fetchTodayFlightsData();
    await setTodayRecord();
  }

  static Future fetchAllStepData() async {
    DateTime startTime = _logged.regDate;
    DateTime endTime = now;
    await fetchStepData(startTime, endTime);
  }
  
  static Future fetchOneDayStepData(DateTime date) async {
    await fetchStepData(date, date);
  }

  static Future fetchTodayStepData() async {
    await fetchOneDayStepData(today);
  }
  
  static Future fetchStepData(DateTime startTime, DateTime endTime) async {
    startTime = later(startTime, _logged.regDate);
    endTime = earlier(endTime.lastTimeOfDay, now);

    initStepsData(startTime, endTime);

    num value = 0;

    if (!_approved) _fetchedSteps = {};

    DateRange dateRange = DateRange(startTime, endTime);
    for (DateTime date in dateRange.dates) {
      num? fetchedValue = await _health.getTotalStepsInInterval(date, date.lastTimeOfDay);
      if (fetchedValue == null || fetchedValue > 28796) fetchedValue = .0;
      value = fetchedValue;
      _fetchedSteps[date] = value;
    }
  }

  static Future fetchAllFlightsData() async {
    DateTime startTime = _logged.regDate;
    DateTime endTime = now;
    await fetchFlightsData(startTime, endTime);
  }

  static Future fetchOneDayFlightsData(DateTime date) async {
    await fetchFlightsData(date, date);
  }

  static Future fetchTodayFlightsData() async {
    await fetchOneDayFlightsData(today);
  }

  static Future fetchFlightsData(DateTime startTime, DateTime endTime) async {
    startTime = later(startTime, _logged.regDate);
    endTime = earlier(endTime.lastTimeOfDay, now);

    initFlightsData(startTime, endTime);

    List<HealthDataPoint> flightsData = [];

    if (!_approved) _fetchedFlights = {};

    flightsData = await _health
        .getHealthDataFromTypes(startTime, endTime, _flightType);

    flightsData = HealthFactory.removeDuplicates(flightsData);

    for (var flight in flightsData) {
      DateTime date = flight.dateFrom.ignoreTime;
      num value = _fetchedFlights[date] ?? .0;
      value += double.parse(flight.value.toString());
      _fetchedFlights[date] = value;
    }
  }

}