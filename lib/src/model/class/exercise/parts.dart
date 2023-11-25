import 'dart:math';

import 'package:fitween/src/model/class/exercise.dart';
import 'package:fitween/src/model/enum/enum.dart';

enum Part {
  nose,
  eyeL, eyeR, earL, earR,
  shoulderL, shoulderR, elbowL, elbowR,
  wristL, wristR, hipL, hipR,
  kneeL, kneeR, ankleL, ankleR
}

class Parts {
  Map<Part, Point> points = {};
  Map<Part, double> probs = {};

  Parts.init();
  Parts(Map<Part, Inference> inferences) {
    for (Part part in Part.values) {
      points[part] = Point(inferences[part]!.x, inferences[part]!.y);
      probs[part] = inferences[part]!.prob.toDouble();
    }
  }

  static bool similar(num n1, num n2) {
    return (n1 - n2).abs() < 40;
  }

  bool getHumanDetected(Exercise exercise) {
    const double threshold = .3;
    double sumProbs = .0; int count = 0;
    for (Part part in exercise.handler.probAvailParts) {
      sumProbs += probs[part]!; count++;
    }
    return sumProbs / count > threshold;
  }
}