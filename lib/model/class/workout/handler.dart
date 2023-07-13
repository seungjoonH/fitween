import 'dart:math';

import 'package:fitween/model/class/workout/inference.dart';
import 'package:fitween/model/class/workout/limb.dart';
import 'package:fitween/model/class/workout/parts.dart';
import 'package:fitween/model/enum/part.dart';
import 'package:fitween/model/enum/workout.dart';

class AngleRange {
  late double min;
  late double max;

  AngleRange(this.min, this.max);

  bool inRange(double angle) => angle >= min && angle <= max;
}

class ExerciseHandler {
  static WorkoutPosture posture = WorkoutPosture.unbent;
  static late Workout workout;

  static bool bent = true;
  static bool humanDetected = false;
  static late Parts parts;

  static List<Limb> limbs = [];
  static List<AngleRange> angleRanges = [];
  static List<Part> probAvailParts = [];

  static void doWorkout() {
    switch (workout) {
      case Workout.squat: squat(); break;
      case Workout.shoulderPress: shoulderPress(); break;
    }
  }

  static void squat() {
    limbs = [];
    limbs.add(Limb(Part.hipL, Part.kneeL, Part.ankleL));
    limbs.add(Limb(Part.hipR, Part.kneeR, Part.ankleR));
    angleRanges = [AngleRange(60, 150), AngleRange(60, 150)];
    probAvailParts = [
      Part.hipL, Part.kneeL, Part.ankleL,
      Part.hipR, Part.kneeR, Part.ankleR,
    ];
  }

  static void shoulderPress() {
    limbs = [];
    limbs.add(Limb(Part.wristL, Part.elbowL, Part.shoulderL));
    limbs.add(Limb(Part.wristR, Part.elbowR, Part.shoulderR));
    limbs.add(Limb(Part.hipL, Part.shoulderL, Part.elbowL));
    limbs.add(Limb(Part.hipR, Part.shoulderR, Part.elbowR));
    angleRanges = [
      AngleRange(0, 120), AngleRange(0, 120),
      AngleRange(0, 120), AngleRange(0, 120),
    ];
    probAvailParts = [
      Part.wristL, Part.ankleL, Part.shoulderL,
      Part.wristR, Part.ankleR, Part.shoulderR,
      Part.hipL, Part.shoulderL, Part.elbowL,
      Part.hipR, Part.shoulderR, Part.elbowR,
    ];
  }

  static void checkLimbs(Map<Part, Inference> inference) {
    switch (workout) {
      case Workout.squat: checkSquatLimbs(inference); break;
      case Workout.shoulderPress:
        checkShoulderPressLimbs(inference); break;
    }
  }

  static void checkSquatLimbs(Map<Part, Inference> inference) {
    bool isCorrect = true;
    bent = true;
    parts = Parts(inference);

    for (int i = 0; i < limbs.length; i++) {
      Part p1 = limbs[i].part1;
      Part p2 = limbs[i].part2;
      Part p3 = limbs[i].part3;

      Point point1 = parts.points[p1]!;
      Point point2 = parts.points[p2]!;
      Point point3 = parts.points[p3]!;

      double angle = Limb.getAngle(point1, point2, point3);

      bent &= angleRanges[i].inRange(angle);
      isCorrect &= Parts.similar(point2.x, point3.x);
    }

    isCorrect &= Parts.similar(
      parts.points[limbs[0].part3]!.y,
      parts.points[limbs[1].part3]!.y,
    );

    if (bent) {
      posture = WorkoutPosture.wrong;
      if (isCorrect) posture = WorkoutPosture.correct;
      return;
    }

    posture = WorkoutPosture.unbent;
  }

  static void checkShoulderPressLimbs(Map<Part, Inference> inference) {
    bool isCorrect = true;
    bent = true;
    parts = Parts(inference);

    for (int i = 0; i < limbs.length; i++) {
      Part p1 = limbs[i].part1;
      Part p2 = limbs[i].part2;
      Part p3 = limbs[i].part3;

      Point point1 = parts.points[p1]!;
      Point point2 = parts.points[p2]!;
      Point point3 = parts.points[p3]!;

      double angle = Limb.getAngle(point1, point2, point3);

      bent &= angleRanges[i].inRange(angle);
      isCorrect &= angle > 40;
      // isCorrect &= Parts.similar(point2.x, point3.x);
    }

    // isCorrect &= Parts.similar(
    //   parts.points[limbs[0].part3]!.y,
    //   parts.points[limbs[1].part3]!.y,
    // );

    if (bent) {
      posture = WorkoutPosture.wrong;
      if (isCorrect) posture = WorkoutPosture.correct;
      return;
    }

    posture = WorkoutPosture.unbent;
  }
}
