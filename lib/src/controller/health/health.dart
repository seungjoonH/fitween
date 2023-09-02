import 'dart:io';

import 'package:fitween/global/global.dart';
import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/model/class/amount/amount.dart';
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
  static get _write =>
      List.generate(_types.length, (_) => HealthDataAccess.WRITE);
  static get _readWrite =>
      List.generate(_types.length, (_) => HealthDataAccess.READ_WRITE);


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

  static Future fetchDataAfterLogin() async {
    bool stepFetched = await fetchTodayStepData();
    bool flightsFetched = true;
    if (Platform.isIOS) flightsFetched = await fetchTodayFlightsData();
    bool fetched = stepFetched && flightsFetched;


    if (!fetched) {
      List<String> gotError = [];
      if (!stepFetched) gotError.add('step');
      if (!flightsFetched) gotError.add('flights');
      print('[ERROR] Health data (${gotError.join(', ')}) fetching error');
    }
  }

  static Future<bool> fetchAllStepData() async {
    DateTime startTime = _logged.regDate;
    DateTime endTime = now;
    return await fetchStepData(startTime, endTime);
  }
  
  static Future<bool> fetchOneDayStepData(DateTime date) async {
    return await fetchStepData(date, date);
  }

  static Future<bool> fetchTodayStepData() async {
    return await fetchOneDayStepData(today);
  }
  
  static Future<bool> fetchStepData(DateTime startTime, DateTime endTime) async {
    startTime = later(startTime, _logged.regDate).ignoreTime;
    endTime = earlier(endTime.lastTimeOfDay, now).ignoreTime;

    num value = 0;

    if (!_approved) return false;

    DateRange range = DateRange(startTime, endTime);
    for (DateTime date in range.dates) {
      num? fetchedValue = await _health.getTotalStepsInInterval(date, date.lastTimeOfDay);
      if (fetchedValue == null || fetchedValue == 0) continue;
      value = fetchedValue;
      
      DistanceAmount dis = DistanceAmount()..step = value;
      _logged.setTodayRecord(FType.distance, dis);
    }

    await FUserRecordDAO().saveOne(_logged.record!);

    return true;
  }

  static Future<bool> fetchAllFlightsData() async {
    DateTime startTime = _logged.regDate;
    DateTime endTime = now;
    return await fetchFlightsData(startTime, endTime);
  }

  static Future<bool> fetchOneDayFlightsData(DateTime date) async {
    return await fetchFlightsData(date, date);
  }

  static Future<bool> fetchTodayFlightsData() async {
    return await fetchOneDayFlightsData(today);
  }

  static Future fetchFlightsData(DateTime startTime, DateTime endTime) async {
    startTime = later(startTime, _logged.regDate).ignoreTime;
    endTime = earlier(endTime.lastTimeOfDay, now).ignoreTime;

    List<HealthDataPoint> flightsData = [];

    if (!_approved) return false;

    flightsData = await _health
        .getHealthDataFromTypes(startTime, endTime, _flightType);
    if (flightsData.isEmpty) return true;

    flightsData = HealthFactory.removeDuplicates(flightsData);

    Map<DateTime, num> amounts = {};

    for (var flight in flightsData) {
      num value = amounts[flight.dateFrom.ignoreTime] ?? .0;
      value += double.parse(flight.value.toString());
      amounts[flight.dateFrom.ignoreTime] = value;
    }

    DateRange range = DateRange(startTime, endTime);

    for (DateTime date in range.dates) {
      num? value = amounts[date];
      if (value == null) continue;
      HeightAmount hei = HeightAmount()..floor = value;
      _logged.setRecord(FType.height, hei, date);
    }

    await FUserRecordDAO().saveOne(_logged.record!);

    return true;
  }


}