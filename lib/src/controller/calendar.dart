import 'dart:math';

import 'package:fitween/global/global.dart';
import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/model/class/dao.dart';
import 'package:fitween/src/model/class/model.dart';
import 'package:fitween/src/model/enum/ftype.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CalendarCont extends GetxController {
  static CalendarCont get to => Get.find<CalendarCont>();

  FUser? _user;
  bool get _loadComplete => _user != null;

  Future init() async {
    await AuthCont.reloadFromDB();
    _user = AuthCont.logged!;
    await loadRecord();
    _events = _user!.events;
  }

  Future loadRecord() async {
    FUserRecord? record = await FUserRecordDAO().loadOne(AuthCont.uid!);
    if (record == null) return;
    AuthCont.setUserRecord(record);
  }

  bool get visible => _user!.visible;
  void toggleVisibility() { _user!.toggleVisibility(); }

  final Rx<DateTime> _focusedDay = today.obs;
  final Rx<DateTime> _selectedDay = today.obs;


  DateTime get firstDay => _user!.regDate;
  DateTime get lastDay => today;
  DateTime get focusedDay => _focusedDay.value;
  DateTime get selectedDay => _selectedDay.value;

  bool get isToday => selectedDay.isAtSameMomentAs(today);

  Map<DateTime, List<CalendarEvent>>? _events;

  bool get allCompleted => completedTypes(selectedDay).length == FType.activeValues.length;

  bool completed(FType type, DateTime date) {
    if (!_loadComplete) return false;
    return _user!.completed(type, date.ignoreTime);
  }

  bool started(FType type, DateTime date) {
    if (!_loadComplete) return false;
    return _user!.started(type, date.ignoreTime);
  }

  List<FType> completedTypes(DateTime date) {
    if (!_loadComplete) return [];
    date = date.ignoreTime;
    return FType.activeValues.where((type) => completed(type, date)).toList();
  }

  List<FType> startedTypes(DateTime date) {
    if (!_loadComplete) return [];
    date = date.ignoreTime;
    return FType.activeValues.where((type) => started(type, date)).toList();
  }

  void selectDay(DateTime selectedDay, DateTime focusedDay) {
    if (!_loadComplete) return;
    selectedDay = selectedDay.ignoreTime;
    focusedDay = focusedDay.ignoreTime;
    if (selectedDay.isBefore(_user!.regDate)) return;
    if (selectedDay.isAfter(today)) return;
    _selectedDay(selectedDay);
    if (focusedDay.isBefore(_user!.regDate)) return;
    if (focusedDay.isAfter(today)) return;
    _focusedDay(focusedDay);
  }

  bool selectedDayPredicate(DateTime date) {
    return selectedDay.isAtSameMomentAs(date.ignoreTime);
  }

  List<CalendarEvent> getEventsForDay(DateTime date) {
    return _events?[date.ignoreTime] ?? [
      CalendarEvent(1, .0),
      CalendarEvent(1, .0),
      CalendarEvent(1, .0),
    ];
  }

  CalendarEvent _getEventForType(FType type) {
    return getEventsForDay(selectedDay)[type.index - 1];
  }

  num getGoal(FType type) => _getEventForType(type).goal;
  num getAmount(FType type) => _getEventForType(type).amount;

  double getPercent(FType type) {
    double percent = _getEventForType(type).percent;
    return min(max(percent, .0), 1.0);
  }

  bool isAllFinished(DateTime date) {
    return getEventsForDay(date.ignoreTime)
        .map((event) => event.completed).every((e) => e);
  }

  String get dayRecordGraphCardTitle => DateFormat
      .MMMd(LangCont.locale)
      .format(selectedDay);

  String getDayRecordGraphTextByType(FType type) {
    String amountText = getAmount(type).thouSep;
    String withUnit = type.withUnit(getGoal(type), scaling: false);
    return '$amountText / $withUnit';
  }
}