import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/model/class/model.dart';
import 'package:get/get.dart';

class CalendarEvent {
  num goal;
  num amount;

  CalendarEvent(this.goal, this.amount);

  bool get completed => goal <= amount;
  double get percent => amount / goal;
}

class CalendarPageCont extends PageCont {
  static CalendarPageCont get to => Get.find<CalendarPageCont>();

  FUser? _rival;
  FUser get rival => _rival!;

  CalendarCont get calendarCont => CalendarCont.to;

  @override
  String get loadKey => 'calendar';

  @override
  Future load() async => await calendarCont.init();

  void setRival(FUser rival) => _rival = rival;

  String get appBarText => LangCont.tr('appbar.calendar');
}