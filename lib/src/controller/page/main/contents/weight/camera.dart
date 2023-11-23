import 'package:fitween/src/controller/controller.dart';
import 'package:get/get.dart';

class WeightCameraPageCont extends CameraPageCont {
  static WeightCameraPageCont get to => Get.find<WeightCameraPageCont>();

  @override
  String get loadKey => 'weight-camera';
}