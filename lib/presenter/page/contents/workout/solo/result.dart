import 'dart:math';

import 'package:fitween/global/date.dart';
import 'package:fitween/model/enum/activity_type.dart';
import 'package:fitween/model/enum/unit.dart';
import 'package:fitween/presenter/model/record.dart';
import 'package:fitween/presenter/model/user/record.dart';
import 'package:fitween/presenter/page/home/home.dart';
import 'package:get/get.dart';

class WorkoutSoloResultP extends GetxController {
  static void toWorkoutSoloResult(int count) {
    Get.offAllNamed('/contents/workout/solo/result');
    init(count);
  }

  static void init(int count) async {
    final workoutSoloResultP = Get.find<WorkoutSoloResultP>();
    await workoutSoloResultP.loadAll(count);
  }

  late WeightRecord addedWeight;
  double goal = 1.0;
  double initAmount = .0;
  double amount = .0;

  double get initPercent => min(initAmount / goal, 1.0);
  double get percent => min(amount / goal, 1.0);

  Future loadAll(int count) async {
    final userP = Get.find<UserRecordP>();
    weight = 0;
    goal = userP.loggedUser.getGoal(ActivityType.weight, today)?.amount ?? 1.0;
    initAmount = userP.loggedUser.getAmounts(ActivityType.weight, today);
    update();
    await Future.delayed(const Duration(milliseconds: 500), () {
      weight = count;
      amount = initAmount + count;
      update();
    });
    submit();
  }

  set weight(int count) {
    addedWeight = WeightRecord(
      amount: count.toDouble(),
      state: ExerciseUnit.count,
    ); update();
  }

  void submit() {
    final userP = Get.find<UserRecordP>();
    userP.loggedUser.addRecord(
      ActivityType.weight,
      today, addedWeight, true,
    );
    userP.save();
    update();
  }

  void submitButtonPressed() {
    final homeP = Get.find<HomeP>();
    HomeP.toHome(true);
    homeP.rotationIndex = 2;
  }
}