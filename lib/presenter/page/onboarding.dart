import 'package:carousel_slider/carousel_controller.dart';
import 'package:get/get.dart';

class OnboardingP extends GetxController {
  static final carouselCont = CarouselController();

  static void toOnboarding() {
    final onboardingP = Get.find<OnboardingP>();
    onboardingP.init();
    Get.toNamed('/onboarding');
  }
  static String directory = 'assets/images/page/onboarding/';
  static String getAsset(int index) => '${directory}carousel_$index.svg';

  int pageIndex = 0;
  bool visible = false;

  void init() {
    pageIndex = 0;
    visible = false;
  }

  void pageChanged(int index) async {
    pageIndex = index; update();

    if (index == 3) {
      await Future.delayed(const Duration(seconds: 1), () {
        visible = true; update();
      });
      return;
    }
    visible = false;
    update();
  }
}