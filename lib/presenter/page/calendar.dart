import 'dart:collection';

import 'package:fitween/global/date.dart';
import 'package:fitween/global/theme.dart';
import 'package:fitween/model/enum/activity_type.dart';
import 'package:fitween/presenter/model/user/info.dart';
import 'package:fitween/presenter/model/user/record.dart';
import 'package:fitween/view/page/my/record/background/layout/components/floating_object.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CalendarEvent {
  double goal;
  double amount;

  CalendarEvent(this.goal, this.amount);

  @override
  String toString() => 'amount: $amount';
}

class CalendarP {
  static final firstDay = Get.find<UserInfoP>().loggedUser.regDate ?? today;
  static final lastDay = today;

  static void toCalendar() async {
    final calendarP = Get.find<CalendarP>();
    calendarP.init();
    Get.toNamed('/calendar');
  }

  static bool isAllFinished(List<CalendarEvent> events) {
    return List.generate(
      3, (index) => events[index].goal <= events[index].amount,
    ).every((e) => e);
  }

  static Color colorSelector(
    List<CalendarEvent> events,
    ActivityType type, [
      bool forLinearGraph = false,
  ]) {
    Color color = FTheme.lightGrey;

    CalendarEvent event = events[type.index - 1];
    // if (!forLinearGraph && event.amount == 0) color = Colors.transparent;
    if (event.goal <= event.amount) color = type.color;
    if (isAllFinished(events)) color = ActivityType.calorie.color;

    return color;
  }

  late LinkedHashMap<DateTime, List<CalendarEvent>> events;
  late DateTime startDate;
  DateTime endDate = tomorrow;

  void init() {
    final userP = Get.find<UserInfoP>();
    startDate = userP.loggedUser.regDate ?? today;
    getEvents();
  }

  double getAmounts(ActivityType type, DateTime day) {
    final userP = Get.find<UserRecordP>();
    return userP.loggedUser.getAmounts(type, day, day);
  }

  void getEvents() {
    final userRecordP = Get.find<UserRecordP>();
    events = userRecordP.loggedUser.getEvents(startDate, endDate);
  }
}