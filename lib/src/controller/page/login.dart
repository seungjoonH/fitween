import 'dart:async';

import 'package:fitween/global/global.dart';
import 'package:fitween/src/controller/lang.dart';
import 'package:fitween/src/controller/user/auth.dart';
import 'package:fitween/src/view/page/page.dart';
import 'package:get/get.dart';

class LoginPageCont extends GetxController {
  static get to => Get.find<LoginPageCont>();

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

  final _loading = false.obs;
  final _loadPercent = .0.obs;

  set percent(double p) => _loadPercent(p);
  double get percent => _loadPercent.value;
  bool get loading => _loading.value;

  void loadStart() { percent = .0; _loading(true); }
  void loadEnd() { percent = 1.0; _loading(false); }

  String get loadingText => LangCont.tr('word.loading');

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