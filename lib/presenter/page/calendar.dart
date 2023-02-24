import 'dart:collection';

import 'package:fitween/global/date.dart';
import 'package:fitween/model/enum/activity_type.dart';
import 'package:fitween/presenter/model/user/info.dart';
import 'package:fitween/presenter/model/user/record.dart';
import 'package:fitween/presenter/widget/loading.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CalendarEvent {
  double goal;
  double amount;

  CalendarEvent(this.goal, this.amount);

  @override
  String toString() => 'amount: $amount';
}

class CalendarP extends GetxController {
  static final refreshCont = RefreshController();
  static final firstDay = Get.find<UserInfoP>().loggedUser.regDate ?? today;
  static final lastDay = today;

  static Future toCalendar() async {
    Get.toNamed('/calendar');
    await CalendarP.init();
  }

  static Future init() async {
    final userP = Get.find<UserInfoP>();
    final calendarP = Get.find<CalendarP>();
    final loadingP = Get.find<LoadingP>();
    calendarP.startDate = userP.loggedUser.regDate ?? today;

    if (loadingP.loading) return;
    loadingP.loadStart();

    await calendarP.getEvents();

    loadingP.loadEnd();
    calendarP.update();
  }

  static bool isAllFinished(List<CalendarEvent> events) {
    return List.generate(
      3, (index) => events[index].goal <= events[index].amount,
    ).every((e) => e);
  }

  LinkedHashMap<DateTime, List<CalendarEvent>>? events;
  late DateTime startDate;
  DateTime endDate = tomorrow;


  double getAmounts(ActivityType type, DateTime day) {
    final userP = Get.find<UserRecordP>();
    return userP.loggedUser.getAmounts(type, day, day);
  }

  Future getEvents() async {
    final userRecordP = Get.find<UserRecordP>();
    await userRecordP.load();
    events = userRecordP.loggedUser.getEvents(startDate, endDate);
  }
}