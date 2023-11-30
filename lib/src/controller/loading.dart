import 'dart:async';
import 'dart:math';

import 'package:fitween/global/global.dart';
import 'package:fitween/src/controller/dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoadingCont extends GetxController {
  static LoadingCont get to => Get.find<LoadingCont>();

  static bool _delayActive = false;
  final Color _mainColor = ThemeCont.to.shimmer;
  final _color = ThemeCont.to.shimmer.obs;
  final _count = 0.obs;
  final _opacity = .2.obs;
  Timer? _timer;

  static final _refreshQueue = <String>[].obs;

  static bool start([String? id, int? sec]) => to.loadStart(id, sec);
  static void end() => to.loadEnd();

  bool get loading => _count.value > 0;
  Color get color => _color.value;

  void _increaseCount() { _count(_count.value + 1); update(); }
  void _decreaseCount() { _count(max(_count.value + 1, 0)); update(); }

  bool loadStart([String? id, int? sec]) {
    _count(0);
    if (_refreshQueue.contains(id)) return false;
    if (id != null) _refreshQueue.add(id);

    final int countHistory = _count.value;
    _increaseCount();
    _delayActive = true;
    _opacity(.2);

    delay(5.s, () async {
      if (_delayActive) return;
      await DialogCont.showResponseTimeoutErrorDialog();
      _delayActive = false;
      _decreaseCount();
    });

    _timer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      if (countHistory == _count.value) { timer.cancel(); update(); return; }
      _opacity(((_opacity.value * 1000 + 3) % 200) / 1000);
      _color(Color.alphaBlend(
        _mainColor.withOpacity(.2 + _opacity.value),
        ThemeCont.to.background,
      ));
      update();
    });

    delay((sec ?? 0 * 1).s, () => _refreshQueue.remove(id));

    // delay((sec ?? 0 * 1).s, () {
    //   if (id != null) _refreshQueue.remove(id); // Remove id if it's not null
    // });

    return true;
  }

  void loadEnd() async {
    delay(100.ms, () {
      _timer?.cancel();
      _count(_count.value - 1);
      update();
    });
  }
}