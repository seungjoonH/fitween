import 'dart:math';

import 'package:fitween/global/global.dart';
import 'package:fitween/src/model/class/exercise.dart';
import 'package:fitween/src/model/enum/enum.dart';
import 'package:get/get.dart';

class AngleRange {
  late double min;
  late double max;

  AngleRange(this.min, this.max);

  bool inRange(double angle) => angle >= min && angle <= max;
}

abstract class ExerciseHandler extends GetxController {
  final _posture = ExercisePosture.unbent.obs;
  ExercisePosture get posture => _posture.value;

  final _humanDistance = HumanDistance.undetected.obs;
  HumanDistance get humanDistance => _humanDistance.value;

  Exercise get exercise;

  final _bent = false.obs;
  bool get bent => _bent.value;

  final _parts = Parts.init().obs;
  Parts get parts => _parts.value;

  final List<Limb> limbs = [];
  final List<AngleRange> angleRanges = [];
  final List<Part> probAvailParts = [];

  void init();
  void measureDistance(Map<Part, Inference> inferences);
  void checkLimbs(Map<Part, Inference> inferences);
  bool get humanDetected => parts.getHumanDetected(exercise);
}

class SquatHandler extends ExerciseHandler {
  SquatHandler._privateConstructor();
  static final SquatHandler _instance = SquatHandler._privateConstructor();
  factory SquatHandler() => _instance;

  @override
  Exercise get exercise => Exercise.squat;

  @override
  void init() {
    limbs.assignAll([
      Limb(Part.hipL, Part.kneeL, Part.ankleL),
      Limb(Part.hipR, Part.kneeR, Part.ankleR),
    ]);
    angleRanges.assignAll([
      AngleRange(60, 150),
      AngleRange(60, 150),
    ]);
    probAvailParts.assignAll([
      Part.hipL, Part.kneeL, Part.ankleL,
      Part.hipR, Part.kneeR, Part.ankleR,
    ]);
  }

  @override
  void measureDistance(Map<Part, Inference> inferences) {
    num hipLY = inferences[Part.hipL]!.y;
    num hipRY = inferences[Part.hipR]!.y;
    num ankleLY = inferences[Part.ankleL]!.y;
    num ankleRY = inferences[Part.ankleR]!.y;
    num legHeight = average([ankleLY, ankleRY]) - average([hipLY, hipRY]);

    double maxLength = 250.0;
    double minLength = 50.0 - (bent ? 10.0 : .0);

    if (!humanDetected) { _humanDistance(HumanDistance.undetected); return; }
    if (legHeight > maxLength) { _humanDistance(HumanDistance.near); return; }
    if (legHeight < minLength) { _humanDistance(HumanDistance.far); return; }
    _humanDistance(HumanDistance.middle);
  }

  @override
  void checkLimbs(Map<Part, Inference> inferences) {
    bool isCorrect = true;
    bool bent = true;

    _bent(true);
    _parts(Parts(inferences));

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

    if (limbs.isNotEmpty) {
      isCorrect &= Parts.similar(
        parts.points[limbs[0].part3]!.y,
        parts.points[limbs[1].part3]!.y,
      );
    }

    if (bent) {
      _posture(isCorrect
          ? ExercisePosture.correct
          : ExercisePosture.wrong);
      return;
    }

    _bent(bent);
    _posture(ExercisePosture.unbent);
  }
}


class ShoulderPressHandler extends ExerciseHandler {
  ShoulderPressHandler._privateConstructor();
  static final ShoulderPressHandler _instance = ShoulderPressHandler._privateConstructor();
  factory ShoulderPressHandler() => _instance;

  @override
  Exercise get exercise => Exercise.shoulderPress;

  @override
  void init() {
    limbs.assignAll([
      Limb(Part.wristL, Part.elbowL, Part.shoulderL),
      Limb(Part.wristR, Part.elbowR, Part.shoulderR),
      Limb(Part.hipL, Part.shoulderL, Part.elbowL),
      Limb(Part.hipR, Part.shoulderR, Part.elbowR),
    ]);
    angleRanges.assignAll([
      AngleRange(0, 120), AngleRange(0, 120),
      AngleRange(0, 120), AngleRange(0, 120),
    ]);
    probAvailParts.assignAll([
      Part.wristL, Part.ankleL, Part.shoulderL,
      Part.wristR, Part.ankleR, Part.shoulderR,
      Part.hipL, Part.shoulderL, Part.elbowL,
      Part.hipR, Part.shoulderR, Part.elbowR,
    ]);
  }

  @override
  void checkLimbs(Map<Part, Inference> inferences) {
    bool isCorrect = true;
    bool bent = true;
    _parts(Parts(inferences));

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
      _posture(isCorrect
          ? ExercisePosture.correct
          : ExercisePosture.wrong);
      return;
    }

    _bent(bent);
    _posture(ExercisePosture.unbent);
  }

  @override
  void measureDistance(Map<Part, Inference> inferences) {
    throw UnimplementedError();
  }
}

// class ExerciseHandler {
//   static ExercisePosture posture = ExercisePosture.unbent;
//   static late Exercise exercise;
//
//   static bool bent = true;
//   static bool humanDetected = false;
//   static late Parts parts;
//
//   static List<Limb> limbs = [];
//   static List<AngleRange> angleRanges = [];
//   static List<Part> probAvailParts = [];
//
//   static void doWorkout() {
//     switch (exercise) {
//       case Exercise.squat: squat(); break;
//       case Exercise.shoulderPress: shoulderPress(); break;
//     }
//   }
//
//   static void squat() {
//     limbs = [];
//     limbs.add(Limb(Part.hipL, Part.kneeL, Part.ankleL));
//     limbs.add(Limb(Part.hipR, Part.kneeR, Part.ankleR));
//     angleRanges = [AngleRange(60, 150), AngleRange(60, 150)];
//     probAvailParts = [
//       Part.hipL, Part.kneeL, Part.ankleL,
//       Part.hipR, Part.kneeR, Part.ankleR,
//     ];
//   }
//
//   static void shoulderPress() {
//     limbs = [];
//     limbs.add(Limb(Part.wristL, Part.elbowL, Part.shoulderL));
//     limbs.add(Limb(Part.wristR, Part.elbowR, Part.shoulderR));
//     limbs.add(Limb(Part.hipL, Part.shoulderL, Part.elbowL));
//     limbs.add(Limb(Part.hipR, Part.shoulderR, Part.elbowR));
//     angleRanges = [
//       AngleRange(0, 120), AngleRange(0, 120),
//       AngleRange(0, 120), AngleRange(0, 120),
//     ];
//     probAvailParts = [
//       Part.wristL, Part.ankleL, Part.shoulderL,
//       Part.wristR, Part.ankleR, Part.shoulderR,
//       Part.hipL, Part.shoulderL, Part.elbowL,
//       Part.hipR, Part.shoulderR, Part.elbowR,
//     ];
//   }
//
//   static void checkLimbs(Map<Part, Inference> inference) {
//     switch (workout) {
//       case Workout.squat: checkSquatLimbs(inference); break;
//       case Workout.shoulderPress:
//         checkShoulderPressLimbs(inference); break;
//     }
//   }
//
//   static void checkSquatLimbs(Map<Part, Inference> inference) {
//     bool isCorrect = true;
//     bent = true;
//     parts = Parts(inference);
//
//     for (int i = 0; i < limbs.length; i++) {
//       Part p1 = limbs[i].part1;
//       Part p2 = limbs[i].part2;
//       Part p3 = limbs[i].part3;
//
//       Point point1 = parts.points[p1]!;
//       Point point2 = parts.points[p2]!;
//       Point point3 = parts.points[p3]!;
//
//       double angle = Limb.getAngle(point1, point2, point3);
//
//       bent &= angleRanges[i].inRange(angle);
//       isCorrect &= Parts.similar(point2.x, point3.x);
//     }
//
//     isCorrect &= Parts.similar(
//       parts.points[limbs[0].part3]!.y,
//       parts.points[limbs[1].part3]!.y,
//     );
//
//     if (bent) {
//       posture = ExercisePosture.wrong;
//       if (isCorrect) posture = ExercisePosture.correct;
//       return;
//     }
//
//     posture = ExercisePosture.unbent;
//   }
//
//   static void checkShoulderPressLimbs(Map<Part, Inference> inference) {
//     bool isCorrect = true;
//     bent = true;
//     parts = Parts(inference);
//
//     for (int i = 0; i < limbs.length; i++) {
//       Part p1 = limbs[i].part1;
//       Part p2 = limbs[i].part2;
//       Part p3 = limbs[i].part3;
//
//       Point point1 = parts.points[p1]!;
//       Point point2 = parts.points[p2]!;
//       Point point3 = parts.points[p3]!;
//
//       double angle = Limb.getAngle(point1, point2, point3);
//
//       bent &= angleRanges[i].inRange(angle);
//       isCorrect &= angle > 40;
//       // isCorrect &= Parts.similar(point2.x, point3.x);
//     }
//
//     // isCorrect &= Parts.similar(
//     //   parts.points[limbs[0].part3]!.y,
//     //   parts.points[limbs[1].part3]!.y,
//     // );
//
//     if (bent) {
//       posture = ExercisePosture.wrong;
//       if (isCorrect) posture = ExercisePosture.correct;
//       return;
//     }
//
//     posture = ExercisePosture.unbent;
//   }
// }
