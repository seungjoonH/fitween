import 'dart:async';

import 'package:fitween/global/global.dart';
import 'package:fitween/src/controller/dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoadingCont extends GetxController {
  static LoadingCont get to => Get.find<LoadingCont>();

  static bool _delayActive = false;
  final Color _mainColor = FTheme.bar;
  Color _color = FTheme.bar;
  int _count = 0;
  Timer? _timer;

  static final _refreshQueue = <String>[].obs;

  static bool start([String? id, int? sec]) => to.loadStart(id, sec);
  static void end() => to.loadEnd();

  bool get loading => _count > 0;
  Color get color => _color;

  bool loadStart([String? id, int? sec]) {
    if (_refreshQueue.contains(id)) return false;
    if (id != null) _refreshQueue.add(id);

    final int countHistory = _count;
    _count++;
    _delayActive = true;
    double opacity = .2;

    delay(5000.ms, () async {
      if (_delayActive) return;
      await DialogCont.showResponseTimeoutErrorDialog();
      _delayActive = false;
      _count--;
    });

    _timer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      if (countHistory == _count) { timer.cancel(); update(); return; }
      opacity = ((opacity * 1000 + 3) % 200) / 1000;
      _color = _mainColor.withOpacity(.2 + opacity);
      update();
    });

    delay((sec ?? 0 * 1).s, () {
      _refreshQueue.remove(id);
    });
    return true;
  }

  void loadEnd() async {
    delay(100.ms, () {
      _timer?.cancel();
      _count--;
      update();
    });
  }
}