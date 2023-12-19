import 'dart:async';

import 'package:fitween/global/global.dart';
import 'package:fitween/src/model/class/model.dart';
import 'package:get/get.dart';

class SnowyBackgroundCont extends GetxController {
  static SnowyBackgroundCont get to => Get.find<SnowyBackgroundCont>();

  final _snowballs = <Snowball>[].obs;
  List<Snowball> get snowballs => _snowballs;

  void generate() {
    _snowballs.assignAll(List.generate(30, (_) => Snowball.random()));
    _startSnow();
  }

  late Timer? _timer;

  void _startSnow() { _timer = Timer.periodic(10.ms, (_) => _snow()); }
  void _snow() => _snowballs.assignAll([...snowballs.map((ball) => ball..next())]);
  void eliminate() => _timer?.cancel();
}