import 'dart:async';
import 'dart:math';

import 'package:fitween/global/global.dart';
import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/view/page/page.dart';
import 'package:get/get.dart';

class LoginPageCont extends PageCont {
  static LoginPageCont get to => Get.find<LoginPageCont>();

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

  @override
  String get loadKey => 'login';

  @override
  Future load() async {
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

  final _textKey = ''.obs;
  final _loadingState = false.obs;
  final _loadedPercentage = .0.obs;
  bool get loading => _loadingState.value;
  set p(double percent) => _loadedPercentage(percent);
  double get p => _loadedPercentage.value;
  Timer? _loadingTimer;

  void startLoading([String? text]) {
    _textKey(text);
    p = .0; _loadingState(true);
    _loadingTimer = Timer.periodic(5.ms, (_) => p = min(1, p + .01));
  }

  Future endLoading() async {
    _loadingTimer?.cancel();
    _loadingTimer = Timer.periodic(5.ms, (_) => p = min(1, p + .01));
    await delay(300.ms);
    _loadingTimer?.cancel();
    delay(1.s, () => _loadingState(false));
  }

  String get loadingText {
    String key = 'login.${_textKey.value}-';
    key += p < 1 ? 'loading' : 'complete';
    String percent = '${(p * 100).round()}%';
    return '${LangCont.tr(key)} ($percent)';
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