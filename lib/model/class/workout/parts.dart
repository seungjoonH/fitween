import 'dart:math';

import 'package:fitween/global/number.dart';
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

  bool get isHuman {
    return average(probs.values.toList().sublist(11)) > .3;
  }
}