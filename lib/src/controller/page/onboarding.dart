import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:fitween/global/global.dart';
import 'package:fitween/route.dart';
import 'package:fitween/src/controller/lang.dart';
import 'package:fitween/src/controller/page.dart';
import 'package:fitween/src/controller/user/auth.dart';
import 'package:get/get.dart';

class OnboardingPageCont extends GetxController {
  static OnboardingPageCont get to => Get.find<OnboardingPageCont>();
  static const _imageDir = 'assets/image/page/onboarding/';
  static get tr => 'onboarding';

  final _carouselCont = CarouselController();
  CarouselController get carouselCont => _carouselCont;

  final  _opacity = .0.obs;
  final _pageIndex = 0.obs;
  final _buttonVisible = false.obs;

  String get buttonText => LangCont.tr('button.start');

  double get opacity => _opacity.value;
  int get pageIndex => _pageIndex.value;
  bool get buttonVisible => _buttonVisible.value;

  @override
  void onInit() {
    super.onInit();
    init();
  }

  void init() async {
    _pageIndex(0);
    _buttonVisible(false);
    delay(Duration.zero, () => _opacity(1.0));
  }

  int get itemCount => 4;
  List<String> get messages => List.generate(
    itemCount, (i) => LangCont.tr('$tr.messages.$i'),
  );

  String get comment => LangCont.tr('$tr.comment');

  List<String> get assets => List.generate(
    itemCount, (i) => '${_imageDir}carousel_$i.svg',
  );

  void onPageChanged(int index, CarouselPageChangedReason reason) async {
    _pageIndex(index);

    if (index == itemCount - 1) {
      await delay(1.s, () => _buttonVisible(true));
      return;
    }

    _buttonVisible(false);
  }

  void onStartButtonPressed() {
    RegisterPageCont.to.newcomer = AuthCont.stranger!;
    FRoute.toRegister();
  }
}