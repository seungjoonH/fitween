import 'dart:async';
import 'dart:math';

import 'package:fitween/global/number.dart';
import 'package:fitween/model/class/workout/handler.dart';
import 'package:fitween/model/class/workout/inference.dart';
import 'package:fitween/model/class/workout/limb.dart';
import 'package:fitween/model/class/workout/parts.dart';
import 'package:fitween/model/enum/part.dart';
import 'package:fitween/model/enum/workout.dart';
import 'package:fitween/presenter/model/json/battle.dart';
import 'package:fitween/presenter/page/contents/workout/battle/result.dart';
import 'package:get/get.dart';

class BattleCameraP extends GetxController {
  static void toBattleCamera(String id) {
    BattleCameraP.init(id);
    Get.offAllNamed('/contents/workout/battle/camera');
  }

  static void init([String? id]) {
    final battleCameraP = Get.find<BattleCameraP>();
    battleCameraP.loadAll(id);
  }

  bool completed = false;
  late String battleId;

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

  late TimerState timerState = TimerState.stop;
  static late Timer timer;
  int timerSeconds = 180;
  String get minuteString => '${timerSeconds ~/ 60}'.padLeft(2, '0');
  String get secondString => '${timerSeconds % 60}'.padLeft(2, '0');

  static const int historyMax = 5;
  List<WorkoutStage> stageHistory = [WorkoutStage.down];
  List<WorkoutStage> get subList => stageHistory
      .sublist(0, stageHistory.length - 1);

  List<WorkoutPosture> postures = [];

  bool activeSnackBar = false;

  void loadAll([String? id]) {
    if (id != null) battleId = id;
    count = 0;
    state = WorkoutState.stop;
    stage = WorkoutStage.down;
    distance = HumanDistance.middle;
    resetThreeSecTimer();
    resetTimer();
    update();
  }

  void completeExercise() async {
    await BattleJsonP.complete(battleId, count);
    BattleResultP.toBattleResult(battleId, count: count);
    init(); stopTimer();
  }

  void startButtonPressed() {
    state = WorkoutState.ready;
    message = state.message;
    update();
  }

  void stopButtonPressed() async {
    activeSnackBar = true; update();
    await Future.delayed(const Duration(seconds: 2), () {
      activeSnackBar = false; update();
    });
  }

  void stopButtonLongPressed() => completeExercise();

  void measureDistance() {
    double hipLY = inferences[Part.hipL]!.y.toDouble();
    double hipRY = inferences[Part.hipR]!.y.toDouble();
    double ankleLY = inferences[Part.ankleL]!.y.toDouble();
    double ankleRY = inferences[Part.ankleR]!.y.toDouble();
    double legHeight = average([ankleLY, ankleRY]).toDouble() - average([hipLY, hipRY]);

    humanDetected = Parts(inferences).humanDetected;

    distance = HumanDistance.middle;
    if (legHeight > 250) distance = HumanDistance.near;
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

  void resetTimer() {
    timerState = TimerState.stop;
    timerSeconds = 20;
    update();
  }

  void stopTimer() { timer.cancel(); resetTimer(); update(); }

  void startTimer() {
    if (timerState == TimerState.run) return;
    timerState = TimerState.run;
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (timerState == TimerState.stop) {
        return;
      }
      timerSeconds = max(timerSeconds - 1, 0);
      if (timerSeconds == 0) state = WorkoutState.complete;
      update();
    });
  }

  void timerFinished() {
    if (timerSeconds > 0) return;
    stopTimer();
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
    if (changedUpToDown) postures = [];
    if (changedDownToUp) {
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

  void staging() async {
    message = state.message;
    if (completed) return;
    if (state != WorkoutState.stop) measureDistance();

    switch (state) {
      case WorkoutState.stop: return;
      case WorkoutState.ready:
        message += '\n${distance.message}';
        if (distance == HumanDistance.middle) message += '인식 중...';
        update();
        startThreeSecTimer();
        break;
      case WorkoutState.workout:
        startTimer();
        setStage();
        if (humanDetected) {
          estimatePosture();
          message += stage.message;
          message += '\n$postureMessage';
        }
        measureDistance();
        message += '\n${distance.message}'; update();
        break;
      case WorkoutState.complete:
        completed = true;
        await Future.delayed(
          const Duration(seconds: 1),
          completeExercise,
        );
        break;
      case WorkoutState.pause: break;
    }

    update();
  }
}