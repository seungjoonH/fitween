import 'package:get/get.dart';
import 'package:fitween/model/enum/activity_type.dart';
import 'package:fitween/model/enum/unit.dart';
import 'package:fitween/presenter/model/record.dart';
import 'package:fitween/presenter/model/user.dart';
import 'package:fitween/presenter/page/home.dart';
import 'package:fitween/presenter/widget/painter.dart';

class WorkoutMain extends GetxController {
  static void toWorkoutMain() {
    final workoutMain = Get.find<WorkoutMain>();
    workoutMain.init();
    Get.offNamed('workout/main');
  }

  int count = 0;

  void countUp() => count++;

  void init() {
    final painterP = Get.find<PainterPresenter>();
    count = 0;
    painterP.initWorkout();
  }

  void finishWorkout() async {
    final userP = Get.find<UserPresenter>();
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