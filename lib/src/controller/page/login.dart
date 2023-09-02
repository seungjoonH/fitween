import 'dart:async';
import 'dart:math';

import 'package:fitween/global/global.dart';
import 'package:fitween/src/controller/lang.dart';
import 'package:fitween/src/controller/user/auth.dart';
import 'package:fitween/src/view/page/page.dart';
import 'package:get/get.dart';

class LoginPageCont extends GetxController {
  static LoginPageCont get to => Get.find<LoginPageCont>();

  @override
  void onInit() {
    super.onInit();
    init();
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  final _backgroundOpacity = .0.obs;
  final _buttonsOpacity = .0.obs;

  double get backgroundOpacity => _backgroundOpacity.value;
  double get buttonsOpacity => _buttonsOpacity.value;

  Timer? _timer;
  final _pointCount = 0.obs;

  void init() {
    _backgroundOpacity(.0);
    _buttonsOpacity(.0);

    _visualize();
    _startTimer();
  }

  void _visualize() {
    delay(500.ms, () => _backgroundOpacity(1.0));
    delay(1000.ms, () => _buttonsOpacity(1.0));
  }

  void _startTimer() {
    _timer = Timer.periodic(
        const Duration(milliseconds: 500), (_) {
      _pointCount((_pointCount.value + 1) % 4);
    });
  }

  final _loadingState = false.obs;
  final _loadedPercentage = .0.obs;
  bool get loading => _loadingState.value;
  set p(double percent) => _loadedPercentage(percent);
  double get p => _loadedPercentage.value;
  Timer? _loadingTimer;

  void startLoading() {
    p = .0; _loadingState(true);
    _loadingTimer = Timer.periodic(10.ms, (_) async {
      p = min(1, p + .01);
      if (p == 1) {
        await delay(500.ms);
        endLoading();
        return;
      }
    });
  }

  void endLoading() {
    _loadingState(false);
    _loadingTimer?.cancel();
  }

  String get loadingText {
    String key = p < 1 ? 'loading' : 'complete';
    return LangCont.tr('login.$key');
  }

  void onPressed(LoginType type) {
    // if (await Inspection.load()) return;
    // if (networkResult == ConnectivityResult.none) {
    //   DialogCont.showNetworkErrorDialog();
    //   return;
    // }
    // if (!await AuthP.versionCheck()) {
    //   DialogCont.showVersionInvalidDialog();
    //   return;
    // }
    AuthCont.fLogin(type);
  }
}