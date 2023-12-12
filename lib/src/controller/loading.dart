import 'dart:async';
import 'dart:math';

import 'package:fitween/global/global.dart';
import 'package:fitween/src/controller/dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoadingCont extends GetxController {
  static LoadingCont get to => Get.find<LoadingCont>();

  final Color _mainColor = ThemeCont.to.shimmer;
  final _color = ThemeCont.to.shimmer.obs;
  final _count = 0.obs;
  final _opacity = .2.obs;
  Timer? _timer;

  static final _refreshQueue = <String>[].obs;

  static bool start([String? id, int? sec]) => to.loadStart(id, sec);
  static void end() => to.loadEnd();
  static void clearQueue() => _refreshQueue.clear();

  bool get loading => _count.value > 0;
  Color get color => _color.value;

  void _increaseCount() { _count(_count.value + 1); update(); }
  void _decreaseCount() { _count(max(_count.value - 1, 0)); update(); }

  late DateTime _loadTime;

  bool loadStart([String? id, int? sec]) {
    _count(0);
    if (_refreshQueue.contains(id)) return false;
    if (id != null) _refreshQueue.add(id);

    final int countHistory = _count.value;
    _increaseCount();
    _opacity(.2);

    _loadTime = now;

    _timer = Timer.periodic(10.ms, (timer) {
      if (countHistory == _count.value) { timer.cancel(); update(); return; }
      _opacity(((_opacity.value * 1000 + 3) % 200) / 1000);
      _color(Color.alphaBlend(
        _mainColor.withOpacity(.2 + _opacity.value),
        ThemeCont.to.background,
      ));
      if (loading && _loadTime.add(20.s).isBefore(now)) {
        DialogCont.showNetworkErrorDialog();
        timer.cancel();
        _decreaseCount();
        return;
      }
      update();
    });

    delay(((sec ?? 1) * 1000).ms, () {
      _refreshQueue.remove(id);
      _decreaseCount();
    });

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