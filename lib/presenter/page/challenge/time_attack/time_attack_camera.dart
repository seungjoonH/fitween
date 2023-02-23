import 'package:fitween/presenter/model/user/record.dart';
import 'package:get/get.dart';
import 'package:fitween/model/enum/activity_type.dart';
import 'package:fitween/model/enum/unit.dart';
import 'package:fitween/presenter/model/record.dart';
// ignore: unused_import
import 'package:fitween/presenter/model/user.dart';
import 'package:fitween/presenter/page/home.dart';
import 'package:fitween/presenter/widget/painter.dart';

class TimeAttackCameraP extends GetxController {
  static void toTimeAttackCamera() {
    final workoutMain = Get.find<TimeAttackCameraP>();
    workoutMain.init();
    Get.offNamed('/challenge/timeAttack/camera');
  }

  int count = 0;

  void countUp() => count++;

  void init() {
    final painterP = Get.find<PainterPresenter>();
    count = 0;
    painterP.initWorkout();
  }

  void finishWorkout() async {
    final userP = Get.find<UserRecordP>();
    final homeP = Get.find<HomePresenter>();

    Record record = Record.init(
      ActivityType.weight,
      count.toDouble(),
      ExerciseUnit.count,
    );
    userP.addRecord(ActivityType.weight, record);
    Get.back();
    homeP.init();
  }
}