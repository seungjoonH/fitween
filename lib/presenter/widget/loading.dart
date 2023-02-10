import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fitween/global/theme.dart';

/// class
class LoadingPresenter extends GetxController {
  /// attributes
  bool loading = false;
  Color mainColor = PTheme.black;
  Color color = PTheme.black;
  Timer? timer;

  /// methods
  // 로딩 시작
  void loadStart() {
    if (loading) return;
    loading = true;
    double opacity = .2;
    timer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      opacity = ((opacity * 1000 + 3) % 200) / 1000;
      color = mainColor.withOpacity(.2 + opacity);
      update();
    });
  }

  // 로딩 종료
  void loadEnd() async {
    await Future.delayed(const Duration(milliseconds: 50), () {
      timer?.cancel();
      loading = false;
    });
    update();
  }

}