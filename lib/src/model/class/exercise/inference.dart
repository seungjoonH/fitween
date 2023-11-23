import 'package:fitween/src/model/class/exercise.dart';
import 'package:flutter/material.dart';
import 'package:fitween/global/number.dart';

class Inference {
  static int length = Edges.list.length;
  static int historyMax = 4;
  static Map<Part, List<Inference>> history = {
    for (Part part in Part.values) part: [],
  };

  static void saveHistory(Map<Part, Inference> inferences) {
    inferences.forEach((part, inference) {
      history[part]!.add(inference);
      if (history[part]!.length < historyMax) return;
      history[part]!.removeAt(0);
    });
  }

  static Map<Part, List<num>> get historyX => {
    for (Part part in Part.values)
      part: history[part]!.map((h) => h.x).toList()
  };
  static Map<Part, List<num>> get historyY => {
    for (Part part in Part.values)
      part: history[part]!.map((h) => h.y).toList()
  };
  static Map<Part, List<num>> get historyP => {
    for (Part part in Part.values)
      part: history[part]!.map((h) => h.prob).toList()
  };

  static Map<Part, Inference> get refinedInferences => {
    for (Part part in Part.values)
      part: Inference(
        average(historyX[part]!).toInt(),
        average(historyY[part]!).toInt(),
        average(historyP[part]!).toDouble(),
      ),
  };

  late int x;
  late int y;
  late double prob;

  Inference(this.x, this.y, this.prob);
  Inference.list(List<dynamic> list) {
    x = list[0];
    y = list[1];
    prob = list[2];
  }

  Offset get offset => Offset(x.toDouble(), y.toDouble());

  void adjustRatio(double width, double height) {
    x = (x * width).round();
    y = (y * height).round();
  }

  @override
  String toString() {
    return 'pos:($x, $y), prob: ${prob.toStringAsFixed(2)}';
  }
}