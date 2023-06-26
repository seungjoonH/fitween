import 'dart:collection';

import 'package:fitween/global/date.dart';
import 'package:fitween/presenter/health/health.dart';
import 'package:fitween/presenter/model/user/info.dart';
import 'package:fitween/presenter/model/user/record.dart';
import 'package:fitween/presenter/widget/loading.dart';
import 'package:get/get.dart';

class CalendarEvent {
  double goal;
  double amount;

  CalendarEvent(this.goal, this.amount);

  @override
  String toString() => 'amount: $amount';
}

class CalendarP extends GetxController {
  static final firstDay = Get.find<UserInfoP>().loggedUser.regDate ?? today;
  static final lastDay = today;

  static Future toCalendar() async {
    Get.toNamed('/home/calendar');
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

  Future getEvents() async {
    final userRecordP = Get.find<UserRecordP>();
    await userRecordP.load();
    events = userRecordP.loggedUser.getEvents(startDate, endDate);
  }

  void fetchData([int? days]) async {
    final userP = Get.find<UserInfoP>();
    final loadingP = Get.find<LoadingP>();

    late DateTime startDate, endDate;

    startDate = ignoreTime(userP.loggedUser.regDate)!;
    if (days != null) startDate = today.subtract(Duration(days: days));
    endDate = today;

    loadingP.loadStart();

    await HealthP.fetchStepData(startDate, endDate);
    await HealthP.fetchFlightsData(startDate, endDate);

    loadingP.loadEnd();

    update();
  }
}