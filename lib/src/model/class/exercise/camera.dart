import 'dart:io';

import 'package:camera/camera.dart';
import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/model/class/exercise.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum CameraDirection {
  back, front;
  CameraDirection get inverse => values[1 - index];
}

class CameraCont extends GetxController {
  static CameraCont get to => Get.find<CameraCont>();

  static late List<CameraDescription> descriptions;
  final _cameraController = Rx<CameraController?>(null);
  CameraController? get cameraController => _cameraController.value;

  final _isInitialized = false.obs;
  bool get isInitialized => _isInitialized.value;

  bool get isCameraAvailable => cameraController != null && isInitialized;

  static ResolutionPreset preset = ResolutionPreset.medium;

  static Size get presetSize => Platform.isIOS
      ? const Size(480, 640)
      : const Size(480, 720);

  late Classifier classifier;
  late IsolateUtils isolate;

  final _direction = CameraDirection.front.obs;
  CameraDirection get direction => _direction.value;

  List<double> get ltrb {
    double w1 = PageCont.size.width;
    double h1 = PageCont.size.height;
    double r1 = PageCont.size.aspectRatio;
    double w2 = presetSize.width;
    double h2 = presetSize.height;
    double r2 = presetSize.aspectRatio;

    late double dif;
    if (r1 < r2) {
      dif = (w2 - w1 * h2 / h1) * .5;
      return [-dif, .0, -dif, .0];
    }
    else {
      dif = (h2 - h1 * w2 / w1) * .5;
      return [.0, -dif, .0, -dif];
    }
  }
  double get left => ltrb[0];
  double get top => ltrb[1];
  double get right => ltrb[2];
  double get bottom => ltrb[3];

  Future init() async {
    _isInitialized(false);
    assert(descriptions.isNotEmpty);

    isolate = IsolateUtils();
    await isolate.start();

    classifier = Classifier();
    await classifier.loadModel();

    await loadCamera(direction);
  }

  void toggleDirection() => _direction(direction.inverse);

  Future loadCamera(CameraDirection direction) async {
    LoadingCont.to.loadStart();

    _cameraController.value?.dispose();
    _cameraController(CameraController(
      descriptions[direction.index], preset,
      enableAudio: false,
    ));

    await _cameraController.value!.initialize();
    _isInitialized(true);

    LoadingCont.to.loadEnd();
  }

  Future disposeAll() async {
    isolate.dispose();
    await _cameraController.value?.dispose();
    cameraController?.debugCheckIsDisposed();
    _cameraController.value = null;
  }

  void convertCamera() async {
    _direction(direction.inverse);
    await init();
  }
}