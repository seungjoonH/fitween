import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fitween/global/number.dart';
import 'package:fitween/model/class/workout/handler.dart';
import 'package:fitween/model/class/workout/inference.dart';
import 'package:fitween/model/class/workout/limb.dart';
import 'package:fitween/model/enum/part.dart';
import 'package:fitween/model/enum/workout.dart';
import 'package:fitween/presenter/page/workout/main.dart';

import '../page/challenge/time_attack/time_attack_camera.dart';

class PainterPresenter extends GetxController {
  static Orientation orientation = Orientation.portrait;
  static double get screenRatio {
    const ratio = 4 / 6;
    if (orientation == Orientation.portrait) return ratio;
    return 1 / ratio;
  }
  static double get _canvasHeight =>
      MediaQuery.of(Get.context!).size.height * .74;
  static Size get canvasSize => Size(
    _canvasHeight * screenRatio,
    _canvasHeight,
  );

  static void setOrientation(Orientation orientation) {
    PainterPresenter.orientation = orientation;
  }

  static double getAngle(Point pointA, Point pointB, Point pointC) {
    double radians = atan2(pointC.y - pointB.y, pointC.x - pointB.x) -
        atan2(pointA.y - pointB.y, pointA.x - pointB.x);
    double angle = (radians * 180 / pi).abs();
    if (angle > 180) angle = 360 - angle;

    return angle;
  }

  late Map<Part, Inference> inferences;
  late List<Limb> limbs;

  bool countUpAllowed = true;
  String? floatingMessage;

  WorkoutStage beforeStage = WorkoutStage.ready;
  WorkoutStage currentStage = WorkoutStage.ready;
  WorkoutState state = WorkoutState.stop;

  String? stateText;
  int get count => Get.find<TimeAttackCameraP>().count;

  static List<WorkoutDistance> distanceHistory = [];
  static List<bool> hitHistory = [];
  static int humanHistory = 0;

  static void addDistanceHistory(WorkoutDistance distance) {
    distanceHistory.add(distance);
    if (distanceHistory.length > 50) distanceHistory.removeAt(0);
  }

  static void addHitHistory(bool hit) {
    hitHistory.add(hit);
    if (hitHistory.length > 5) hitHistory.removeAt(0);
  }

  static void addHumanHistory(bool isHuman) {
    int after = humanHistory + (isHuman ? 1 : -1);
    humanHistory = max(min(after, 10), -30);
  }

  WorkoutDistance get decideDistance {
    int max = 0;
    late WorkoutDistance maxDistance;

    for (WorkoutDistance distance in distanceHistory) {
      int temp = distanceHistory.where((d) => d == distance).length;
      if (max > temp) continue;
      max = temp;
      maxDistance = distance;
    }

    return maxDistance;
  }

  WorkoutDistance get distance {
    double hipLY = inferences[Part.hipL]!.y.toDouble();
    double hipRY = inferences[Part.hipR]!.y.toDouble();
    double ankleLY = inferences[Part.ankleL]!.y.toDouble();
    double ankleRY = inferences[Part.ankleR]!.y.toDouble();
    double legHeight = average([ankleLY, ankleRY]).toDouble() - average([hipLY, hipRY]);

    WorkoutDistance currentDistance = WorkoutDistance.middle;

    if (legHeight > 350) {
      currentDistance = WorkoutDistance.near;
      floatingMessage = '너무 가까워요!';
    }
    if (legHeight < 50 + (currentStage != WorkoutStage.ready ? 0 : 20)) {
      currentDistance = WorkoutDistance.far;
      floatingMessage = '좀 더 가까이 와주세요.';
    }

    addDistanceHistory(currentDistance);
    return decideDistance;
  }

  void staging() {
    addHitHistory(ExerciseHandler.posture != WorkoutPosture.ready);
    countUp();
  }

  void countUp() {
    final workoutMain = Get.find<TimeAttackCameraP>();

    if (humanHistory < 0 || distance != WorkoutDistance.middle) {
      floatingMessage = '사람이 인식되지 않습니다';
      return;
    }

    if (currentStage == WorkoutStage.fast) return;

    List<bool> subList = hitHistory.sublist(0, hitHistory.length - 1);

    late bool upCond, downCond, countCond;

    upCond = currentStage == WorkoutStage.up;
    upCond &= [...subList].every((s) => s);
    upCond &= !hitHistory.last;

    downCond = currentStage == WorkoutStage.down;
    downCond &= [...subList].every((s) => !s);
    downCond &= hitHistory.last;

    beforeStage = currentStage;

    if (downCond) currentStage = WorkoutStage.up;
    if (upCond) currentStage = WorkoutStage.down;

    countCond = beforeStage == WorkoutStage.down;
    countCond &= currentStage == WorkoutStage.up;

    floatingMessage = null;

    if (state == WorkoutState.workout) {
      switch (ExerciseHandler.posture) {
        case WorkoutPosture.correct:
          if (countCond) {
            if (countUpAllowed) {
              workoutMain.countUp();
              countUpAllowed = false;
              stateText = 'HIT!';
              Future.delayed(const Duration(milliseconds: 1500), () {
                currentStage = WorkoutStage.down;
                countUpAllowed = true;
                stateText = null;
              });
              return;
            }
            currentStage = WorkoutStage.fast;
            floatingMessage = '조금만 더 천천히 해주세요';
          }
          break;
        case WorkoutPosture.wrong:
          floatingMessage = '자세를 바르게 해주세요';
          break;
        default: break;
      }
    }
  }

  void initWorkout() {
    state = WorkoutState.stop;
    stateText = '';
    update();
  }

  void workout() {
    switch (state) {
      case WorkoutState.stop:
        stateText = 'READY';
        state = WorkoutState.ready;
        Future.delayed(const Duration(milliseconds: 2000), () {
          stateText = 'GO!'; update();
          Future.delayed(const Duration(milliseconds: 1000), () {
            state = WorkoutState.workout;
            currentStage = WorkoutStage.down;
            stateText = null; update();
          });
        });
        update();
        break;
      case WorkoutState.ready: break;
      case WorkoutState.workout:
        state = WorkoutState.stop;
        currentStage = WorkoutStage.ready;
        update();
        break;
    }

  }
}