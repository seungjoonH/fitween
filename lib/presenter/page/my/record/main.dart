import 'package:get/get.dart';
import 'package:fitween/model/enum/activity_type.dart';

class MyRecordMain extends GetxController {
  static void toMyRecordMain(ActivityType type) {
    final myRecordMain = Get.find<MyRecordMain>();
    Get.toNamed('my/record/main', arguments: type);
    myRecordMain.init();
  }

  bool fading = false;
  bool animating = false;

  void init() async {
    fading = false; animating = false; update();
    await Future.delayed(const Duration(milliseconds: 200), () {
      fading = true; animating = true; update();
    });
  }

  void startAnimation() {
    animating = true; update();
  }
  void endAnimation() {
    animating = false; update();
  }
}