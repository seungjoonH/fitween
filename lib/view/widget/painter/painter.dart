import 'dart:ui';

import 'package:fitween/presenter/page/contents/workout/battle/camera.dart';
import 'package:fitween/presenter/page/contents/workout/solo/camera.dart';
import 'package:fitween/presenter/widget/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fitween/global/theme.dart';
import 'package:fitween/model/class/workout/edge.dart';
import 'package:fitween/model/class/workout/handler.dart';
import 'package:fitween/model/class/workout/inference.dart';
import 'package:fitween/model/class/workout/limb.dart';
import 'package:fitween/model/enum/part.dart';
import 'package:fitween/model/enum/workout.dart';

class LimbPainter extends CustomPainter {
  final workoutSoloCameraP = Get.find<WorkoutSoloCameraP>();
  final battleCameraP = Get.find<BattleCameraP>();

  bool isSolo = false;

  // COLOR PROFILES
  Paint pointBlue = Paint()
    ..color = FTheme.colorC.withOpacity(.5)
    ..strokeCap = StrokeCap.round
    ..strokeWidth = 8;

  Paint edgeBlue = Paint()
    ..color = FTheme.colorC.withOpacity(.8)
    ..strokeWidth = 5;

  // CORRECT POSTURE COLOR PROFILE
  Paint pointGreen = Paint()
    ..color = FTheme.colorA.withOpacity(.5)
    ..strokeCap = StrokeCap.round
    ..strokeWidth = 8;

  Paint edgeGreen = Paint()
    ..color = FTheme.colorA.withOpacity(.8)
    ..strokeWidth = 5;

  // INCORRECT POSTURE COLOR PROFILE
  Paint pointRed = Paint()
    ..color = FTheme.error.withOpacity(.5)
    ..strokeCap = StrokeCap.round
    ..strokeWidth = 8;

  Paint edgeRed = Paint()
    ..color = FTheme.error.withOpacity(.8)
    ..strokeWidth = 5;

  Paint area = Paint()
    ..style = PaintingStyle.stroke
    ..color = FTheme.colorB
    ..strokeWidth = 5;

  LimbPainter({
    required Map<Part, Inference> inferences,
    required List<Limb> limbs,
    this.isSolo = false,
  }) {
    workoutSoloCameraP.inferences = inferences;
    workoutSoloCameraP.limbs = limbs;
    battleCameraP.inferences = inferences;
    battleCameraP.limbs = limbs;
  }

  bool get humanDetected {
    if (isSolo) return Get.find<WorkoutSoloCameraP>().humanDetected;
    return Get.find<BattleCameraP>().humanDetected;
  }

  @override
  void paint(Canvas canvas, Size size) {
    // if (!humanDetected) return;
    renderEdges(canvas);
    renderPoints(canvas);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

  void renderPoints(Canvas canvas) {
    Map<Part, Inference> inferences = isSolo
        ? workoutSoloCameraP.inferences
        : battleCameraP.inferences;

    List<Offset> points = inferences.values.map((inf) => inf.offset).toList();
    List<Offset> refinedPoints = [];

    for (Part part in Part.values) {
      bool contain = false;
      for (Limb limb in ExerciseHandler.limbs) {
        contain |= limb.containsPart(part);
      }
      if (contain) refinedPoints.add(points[part.index]);
    }
    canvas.drawPoints(PointMode.points, refinedPoints, {
      WorkoutPosture.unbent: pointBlue,
      WorkoutPosture.correct: pointGreen,
      WorkoutPosture.wrong: pointRed,
      WorkoutPosture.fast: pointRed,
    }[ExerciseHandler.posture]!);
  }

  void renderEdges(Canvas canvas) {
    Map<Part, Inference> inferences = isSolo
        ? workoutSoloCameraP.inferences
        : battleCameraP.inferences;

    for (Edge edge in Edges.list) {
      Offset? p1 = inferences[edge.part1]?.offset;
      Offset? p2 = inferences[edge.part2]?.offset;
      if (p1 == null || p2 == null) continue;
      bool contain = false;
      for (Limb limb in ExerciseHandler.limbs) {
        contain |= limb.containsEdge(edge);
      }

      if (!contain) continue;
      canvas.drawLine(p1, p2, {
        WorkoutPosture.unbent: edgeBlue,
        WorkoutPosture.correct: edgeGreen,
        WorkoutPosture.wrong: edgeRed,
        WorkoutPosture.fast: edgeRed,
      }[ExerciseHandler.posture]!);
    }
  }
}
