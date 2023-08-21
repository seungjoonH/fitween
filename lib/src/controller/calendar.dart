import 'package:fitween/global/date.dart';
import 'package:fitween/src/controller/user/auth.dart';
import 'package:fitween/src/model/class/model.dart';
import 'package:fitween/src/model/enum/ftype.dart';
import 'package:get/get.dart';

class CalendarCont extends GetxController {
  static CalendarCont get to => Get.find<CalendarCont>();

  Future init() async {}

  FUser get _logged => AuthCont.logged!;

  bool completed(FType type, DateTime date) {
    return _logged.completed(type, date);
  }

  bool started(FType type, DateTime date) {
    return _logged.started(type, date);
  }

  List<FType> completedTypes(DateTime date) {
    return FType.values.where((type) => completed(type, date)).toList();
  }

  List<FType> startedTypes(DateTime date) {
    return FType.values.where((type) => started(type, date)).toList();
  }
}