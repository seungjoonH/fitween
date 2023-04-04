import 'dart:math';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fitween/model/class/workout/classifier.dart';
import 'package:fitween/model/class/workout/isolate.dart';

class CameraP extends GetxController {
  static List<CameraDescription>? descriptions;
  CameraController? cameraController;
  static late Classifier classifier;
  static late IsolateUtils isolate;

  late List<dynamic> inferences;

  int direction = 1;
  late double initZoom = 0;
  double zoom = 1.0;

  Future init() async {
    isolate = IsolateUtils();
    await isolate.start();

    classifier = Classifier();
    classifier.loadModel();

    await loadCamera(direction);
    update();
  }

  Future toggleDirection() async {
    direction = 1 - direction;
    update();
  }

  Future loadCamera([direction = 0]) async {
    if (descriptions == null) return;

    cameraController = CameraController(
      descriptions![direction], ResolutionPreset.medium,
      enableAudio: false,
    );
    await cameraController!.initialize();
    await cameraController!.setZoomLevel(zoom);
  }

  void setInitZoom() => initZoom = zoom;

  Future setZoomLevel(ScaleUpdateDetails details) async {
    zoom = max(1.0, min(details.scale * initZoom, 189.0));
    await cameraController!.setZoomLevel(zoom);
  }
}