import 'package:flutter/material.dart';
import 'package:fitween/global/number.dart';
import 'package:fitween/model/class/workout/edge.dart';
import 'package:fitween/model/enum/part.dart';

// List refinedInferences = List.generate(inferenceList.length, (_) => [0, 0, .0]);
//
// for (int i = 0; i < inferenceResults.length; i++) {
//   historyX[i][frameCount % historyMax] = inferenceResults[i][0] * widthRatio;
//   historyY[i][frameCount % historyMax] = inferenceResults[i][1] * heightRatio;
//   historyC[i][frameCount % historyMax] = inferenceResults[i][2];
// }
//
// for (int i = 0; i < inferenceResults.length; i++) {
//   const int thresholdX = 50;
//   const int thresholdY = 50;
//
//   double refinedX = average(historyX[i]).toDouble();
//   double refinedY = average(historyY[i]).toDouble();
//   double refinedC = average(historyC[i]).toDouble();
//
//   if (frameCount < historyMax) {
//     refinedInferences[i][0] = refinedX;
//     refinedInferences[i][1] = refinedY;
//     refinedInferences[i][2] = refinedC;
//     continue;
//   }
//
//   refinedInferences[i][0] = (refinedX - historyX[i][frameCount % historyMax]).abs() > thresholdX
//       ? historyX[i][(frameCount % historyMax - 1) ~/ historyMax] : refinedX;
//   refinedInferences[i][1] = (refinedY - historyY[i][frameCount % historyMax]).abs() > thresholdY
//       ? historyY[i][(frameCount % historyMax - 1) ~/ historyMax] : refinedY;
//   refinedInferences[i][2] = refinedC;
// }

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