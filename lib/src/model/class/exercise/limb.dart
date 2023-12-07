import 'dart:math';
import 'dart:ui';

import 'package:fitween/src/model/class/exercise.dart';
import 'package:fitween/src/model/class/exercise/handler.dart';
import 'package:flutter/material.dart';

class Limb {
  late Part part1;
  late Part part2;
  late Part part3;

  Limb(this.part1, this.part2, this.part3);
  Limb.list(List<Part> list) {
    part1 = list[0];
    part2 = list[1];
    part3 = list[2];
  }
  Limb.intList(List<int> list) {
    part1 = Part.values[list[0]];
    part2 = Part.values[list[1]];
    part3 = Part.values[list[2]];
  }

  List<Edge> get edges => [Edge(part1, part2), Edge(part2, part3)];

  bool containsPart(Part part) {
    return [part1, part2, part3].contains(part);
  }

  bool containsEdge(Edge edge) {
    bool result = false;
    for (Edge e in edges) { result |= e.equalTo(edge); }
    return result;
  }

  // 세 점이 이루는 각도를 반환 (0 ~ 180)
  static double getAngle(Point pointA, Point pointB, Point pointC) {
    double radians = atan2(pointC.y - pointB.y, pointC.x - pointB.x) -
        atan2(pointA.y - pointB.y, pointA.x - pointB.x);
    double angle = (radians * 180 / pi).abs();
    if (angle > 180) angle = 360 - angle;

    return angle;
  }
}

class LimbPainter extends CustomPainter {
  static Paint pointBlue = Paint()
    ..color = Colors.blue.withOpacity(.8)
    ..strokeCap = StrokeCap.round
    ..strokeWidth = 8;

  static Paint edgeBlue = Paint()
    ..color = Colors.blue.withOpacity(.5)
    ..strokeWidth = 5;

  static Paint pointGreen = Paint()
    ..color = Colors.green.withOpacity(.8)
    ..strokeCap = StrokeCap.round
    ..strokeWidth = 8;

  static Paint edgeGreen = Paint()
    ..color = Colors.green.withOpacity(.5)
    ..strokeWidth = 5;

  static Paint pointRed = Paint()
    ..color = Colors.red.withOpacity(.8)
    ..strokeCap = StrokeCap.round
    ..strokeWidth = 8;

  static Paint edgeRed = Paint()
    ..color = Colors.red.withOpacity(.5)
    ..strokeWidth = 5;

  // Paint area = Paint()
  //   ..style = PaintingStyle.stroke
  //   ..color = Colors.green
  //   ..strokeWidth = 5;

  late ExerciseHandler handler;
  Map<Part, Inference>? inferences;

  LimbPainter({
    required this.handler,
    this.inferences,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // if (!handler.humanDetected) return;
    renderEdges(canvas);
    renderPoints(canvas);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

  void renderPoints(Canvas canvas) {
    if (inferences == null) return;

    List<Offset> points = inferences!.values.map((inf) => inf.offset).toList();
    List<Offset> refinedPoints = [];

    if (points.isEmpty) return;

    for (Part part in Part.values) {
      bool contain = false;
      for (Limb limb in handler.limbs) {
        contain |= limb.containsPart(part);
      }
      refinedPoints.add(points[part.index]);
      // if (contain) refinedPoints.add(points[part.index]);
    }
    canvas.drawPoints(
      PointMode.points,
      refinedPoints,
      handler.posture.paint,
    );
  }

  void renderEdges(Canvas canvas) {
    if (inferences == null) return;

    for (Edge edge in Edges.list) {
      Offset? p1 = inferences![edge.part1]?.offset;
      Offset? p2 = inferences![edge.part2]?.offset;
      if (p1 == null || p2 == null) continue;
      bool contain = false;
      for (Limb limb in handler.limbs) {
        contain |= limb.containsEdge(edge);
      }

      // if (!contain) continue;
      canvas.drawLine(p1, p2, handler.posture.paint);
    }
  }
}
