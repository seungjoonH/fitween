import 'dart:io';

import 'package:fitween/global/global.dart';
import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/model/class/dao.dart';
import 'package:fitween/src/model/class/date_range.dart';
import 'package:fitween/src/model/class/model.dart';
import 'package:fitween/src/model/enum/ftype.dart';
import 'package:flutter/foundation.dart';
import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';

class HealthDataCont {
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

  static final Map<DateTime, num> _fetchedSteps = {};
  static final Map<DateTime, num> _fetchedFlights = {};

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

  static Future setAllRecords() async {
    await setAllRecordByType(FType.distance);
    if (Platform.isIOS) await setAllRecordByType(FType.height);
  }

  static Future setAllRecordByType(FType type) async {
    await setRecordByType(type, _logged.regDate.ignoreTime, today);
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

  static Future fetchAllData() async {
    await fetchAllStepData();
    if (Platform.isIOS) await fetchAllFlightsData();
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

    DateRange dateRange = DateRange(startTime, endTime);
    for (DateTime date in dateRange.dates) {
      _fetchedSteps[date] = await _fetchWithoutArtificialData(_stepType.first, date);
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

    DateRange dateRange = DateRange(startTime, endTime);
    for (DateTime date in dateRange.dates) {
      _fetchedFlights[date] = await _fetchWithoutArtificialData(_flightType.first, date);
    }

    // flightsData = await _health
    //     .getHealthDataFromTypes(startTime, endTime, _flightType);
    //
    // flightsData = HealthFactory.removeDuplicates(flightsData);
    //
    // Map<DateTime, num> data = {};
    // for (var flight in flightsData) {
    //   DateTime date = flight.dateFrom.ignoreTime;
    //   num value = data[date] ?? .0;
    //   value += double.parse(flight.value.toString());
    //   data[date] = value;
    // }
    // _fetchedFlights.addAll(data);
  }

  static Future _fetchWithoutArtificialData(HealthDataType type, DateTime date) async {
    List<HealthDataPoint> points = await _health
        .getHealthDataFromTypes(date, date.lastTimeOfDay, [type]);

    points = HealthFactory.removeDuplicates(points);

    int fetchedValue = 0;

    num getValue(HealthDataPoint p) => (p.value as NumericHealthValue).numericValue;

    switch (type) {
      case HealthDataType.STEPS:
        fetchedValue = await _health.getTotalStepsInInterval(date, date.lastTimeOfDay) ?? 0;
        break;
      case HealthDataType.FLIGHTS_CLIMBED:
        fetchedValue = sum(points.map(getValue)).toInt();
        break;
      default: break;
    }

    num artificialValue = sum(points.where((point) => point.sourceName == 'Health')
        .map((point) => (point.value as NumericHealthValue).numericValue));

    return fetchedValue - artificialValue;
  }

}