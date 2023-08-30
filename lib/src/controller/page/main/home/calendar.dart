import 'package:fitween/src/controller/controller.dart';
import 'package:get/get.dart';

class CalendarEvent {
  num goal;
  num amount;

  CalendarEvent(this.goal, this.amount);

  bool get completed => goal <= amount;
  double get percent => amount / goal;
}

class CalendarPageCont extends GetxController {
  static CalendarPageCont get to => Get.find<CalendarPageCont>();

  String get appBarText => LangCont.tr('appbar.calendar');
}