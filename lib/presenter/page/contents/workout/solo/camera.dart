import 'dart:async';
import 'dart:math';

import 'package:fitween/global/number.dart';
import 'package:fitween/model/class/workout/handler.dart';
import 'package:fitween/model/class/workout/inference.dart';
import 'package:fitween/model/class/workout/limb.dart';
import 'package:fitween/model/class/workout/parts.dart';
import 'package:fitween/model/enum/part.dart';
import 'package:fitween/model/enum/workout.dart';
import 'package:fitween/presenter/page/contents/workout/solo/result.dart';
import 'package:fitween/presenter/widget/camera.dart';
import 'package:get/get.dart';

class WorkoutSoloCameraP extends GetxController {
  static void toWorkoutSoloCamera() {
    init();
    Get.toNamed('/contents/workout/solo/camera');
  }

  static void init() {
    final workoutSoloCameraP = Get.find<WorkoutSoloCameraP>();
    workoutSoloCameraP.loadAll();
  }

  late Map<Part, Inference> inferences;
  late List<Limb> limbs;

  int count = 0;

  String message = '';
  String postureMessage = '';

  late WorkoutState state = WorkoutState.stop;
  late WorkoutStage stage = WorkoutStage.down;
  late HumanDistance distance = HumanDistance.middle;
  bool humanDetected = false;

  TimerState threeSecTimerState = TimerState.stop;
  int threeSecTimerSeconds = 3;

  static const int historyMax = 5;
  List<WorkoutStage> stageHistory = [WorkoutStage.down];
  List<WorkoutStage> get subList => stageHistory
      .sublist(0, stageHistory.length - 1);

  List<WorkoutPosture> postures = [];

  void loadAll() {
    count = 0;
    state = WorkoutState.stop;
    message = state.message;
    stage = WorkoutStage.down;
    distance = HumanDistance.middle;
    resetThreeSecTimer();
    update();
  }

  void startButtonPressed() {
    state = WorkoutState.ready;
    message = state.message;
    update();
  }

  void pauseButtonPressed() {
    state = WorkoutState.pause;
    stage = WorkoutStage.down;
    distance = HumanDistance.middle;
    resetThreeSecTimer();
    update();
  }

  void stopButtonPressed() => init();

  void submitButtonPressed() {
    WorkoutSoloResultP.toWorkoutSoloResult(count);
    init();
  }

  void measureDistance() {
    humanDetected = false;
    if (state == WorkoutState.stop) return;

    double hipLY = inferences[Part.hipL]!.y.toDouble();
    double hipRY = inferences[Part.hipR]!.y.toDouble();
    double ankleLY = inferences[Part.ankleL]!.y.toDouble();
    double ankleRY = inferences[Part.ankleR]!.y.toDouble();
    double legHeight = average([ankleLY, ankleRY]).toDouble() - average([hipLY, hipRY]);

    humanDetected = Parts(inferences).humanDetected;

    distance = HumanDistance.middle;

    if (legHeight > CameraP.presetSize.height * .4) distance = HumanDistance.near;
    if (legHeight < 100 - (ExerciseHandler.bent ? 50.0 : .0)) {
      distance = HumanDistance.far;
    }
    if (!humanDetected) distance = HumanDistance.undetected;

  }

  void resetThreeSecTimer() {
    threeSecTimerState = TimerState.stop;
    threeSecTimerSeconds = 3;
    update();
  }

  void startThreeSecTimer() async {
    if (distance != HumanDistance.middle) {
      threeSecTimerState = TimerState.stop; return;
    }
    if (threeSecTimerState == TimerState.run) return;

    Duration d = const Duration(seconds: 1);
    void f() {
      threeSecTimerSeconds = max(threeSecTimerSeconds - 1, 0);
      update();
    }

    threeSecTimerState = TimerState.run;
    update();

    for (int i = 0; i < 4; i++) {
      if (distance != HumanDistance.middle) {
        resetThreeSecTimer(); return;
      }
      await Future.delayed(d, f);
    }
    state = WorkoutState.workout;
    threeSecTimerState = TimerState.stop;
    update();
  }

  void addStageHistory(WorkoutStage stage) {
    stageHistory.add(stage);
    if (stageHistory.length > historyMax) stageHistory.removeAt(0);
  }

  void setStage() {
    stage = ExerciseHandler.posture == WorkoutPosture.unbent
        ? WorkoutStage.down : WorkoutStage.up;
    addStageHistory(stage);
  }

  bool get changedDownToUp {
    bool downToUp = true;
    downToUp &= [...subList].every((s) => s == WorkoutStage.down);
    downToUp &= stageHistory.last == WorkoutStage.up;
    return downToUp;
  }

  bool get changedUpToDown {
    bool upToDown = true;
    upToDown &= [...subList].every((s) => s == WorkoutStage.up);
    upToDown &= stageHistory.last == WorkoutStage.down;
    return upToDown;
  }

  void estimatePosture() async {
    bool isCorrect = postures
        .every((posture) => posture == WorkoutPosture.correct);

    if (stage == WorkoutStage.up) postures.add(ExerciseHandler.posture);
    if (changedDownToUp) { postures = []; }
    if (changedUpToDown) {
      if (isCorrect) countUp();
      postureMessage = (isCorrect
          ? WorkoutPosture.correct
          : WorkoutPosture.wrong).message;
      update();
      await Future.delayed(const Duration(seconds: 1), () {
        postureMessage = ''; update();
      });
    }
  }

  void countUp() { count++; update(); }

  void staging() {
    message = state.message;
    measureDistance();

    switch (state) {
      case WorkoutState.stop: return;
      case WorkoutState.ready:
        message += '\n${distance.message}';
        if (distance == HumanDistance.middle) message += '인식 중...';
        update();
        startThreeSecTimer();
        break;
      case WorkoutState.workout:
        setStage();

        if (humanDetected) {
          estimatePosture();
          message += stage.message;
          message += '\n$postureMessage';
        }

        measureDistance();
        message += '\n${distance.message}'; update();
        break;
      case WorkoutState.pause: break;
      case WorkoutState.complete: break;
    }

    update();
  }
}