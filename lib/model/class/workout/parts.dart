import 'dart:math';

import 'package:fitween/model/class/workout/handler.dart';
import 'package:fitween/model/class/workout/inference.dart';
import 'package:fitween/model/enum/part.dart';

class Parts {
  Map<Part, Point> points = {};
  Map<Part, double> probs = {};

  Parts(Map<Part, Inference> inferences) {
    for (Part part in Part.values) {
      points[part] = Point(inferences[part]!.x, inferences[part]!.y);
      probs[part] = inferences[part]!.prob.toDouble();
    }
  }

  static bool similar(num n1, num n2) {
    return (n1 - n2).abs() < 40;
  }

  bool get humanDetected {
    const double threshold = .3;
    double sumProbs = .0; int count = 0;
    for (Part part in ExerciseHandler.probAvailParts) {
      sumProbs += probs[part]!; count++;
    }
    return sumProbs / count > threshold;
  }
}