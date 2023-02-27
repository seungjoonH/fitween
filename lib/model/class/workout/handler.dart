import 'dart:math';

import 'package:fitween/model/class/workout/inference.dart';
import 'package:fitween/model/class/workout/limb.dart';
import 'package:fitween/model/class/workout/parts.dart';
import 'package:fitween/model/enum/part.dart';
import 'package:fitween/model/enum/workout.dart';
import 'package:fitween/presenter/widget/painter.dart';

class AngleRange {
  late double min;
  late double max;

  AngleRange(this.min, this.max);

  bool inRange(double angle) => angle >= min && angle <= max;
}

class ExerciseHandler {
  static WorkoutPosture posture = WorkoutPosture.ready;
  static late Parts parts;

  List<Limb> limbs = [];
  List<AngleRange> angleRanges = [];

  void init() {}
  void checkLimbs(Map<Part, Inference> inference) {}
}

class SquatHandler extends ExerciseHandler {
  @override
  void init() {
    limbs = [];
    limbs.add(Limb(Part.hipL, Part.kneeL, Part.ankleL));
    limbs.add(Limb(Part.hipR, Part.kneeR, Part.ankleR));

    angleRanges = [AngleRange(30, 150), AngleRange(30, 150)];
  }

  @override
  void checkLimbs(Map<Part, Inference> inference) {
    bool downed = true;
    bool isCorrect = true;

    ExerciseHandler.parts = Parts(inference);
    ExerciseHandler.posture = WorkoutPosture.ready;

    for (int i = 0; i < limbs.length; i++) {
      Part p1 = limbs[i].part1;
      Part p2 = limbs[i].part2;
      Part p3 = limbs[i].part3;

      Point pointA = ExerciseHandler.parts.points[p1]!;
      Point pointB = ExerciseHandler.parts.points[p2]!;
      Point pointC = ExerciseHandler.parts.points[p3]!;

      double angle = PainterP.getAngle(pointA, pointB, pointC);

      downed &= angleRanges[i].inRange(angle);
      isCorrect &= Parts.similar(pointB.x, pointC.x);
    }

    isCorrect &= Parts.similar(
      ExerciseHandler.parts.points[limbs[0].part3]!.y,
      ExerciseHandler.parts.points[limbs[1].part3]!.y,
    );

    if (downed) {
      ExerciseHandler.posture = WorkoutPosture.wrong;
      if (isCorrect) ExerciseHandler.posture = WorkoutPosture.correct;
    }
  }
}
