import 'dart:convert';
import 'dart:math';

import 'package:fitween/src/model/class/model.dart';
import 'package:flutter/services.dart';

abstract class DataLocal {
  Map<String, dynamic> _list = {};

  String get assetPath => 'assets/json/data/';

  Future load() async {
    String string = await rootBundle.loadString(assetPath);
    _list = jsonDecode(string) as Map<String, dynamic>;
  }

  int getAverage(int age, Sex sex) {
    int generation = age < 20 ? age : age ~/ 10 * 10;
    generation = max(min(generation, 80), 6);
    return _list[generation.toString()][sex.index];
  }
}

class WeightDataLocal extends DataLocal {
  static final WeightDataLocal _instance = WeightDataLocal._privateConstructor();
  WeightDataLocal._privateConstructor();

  factory WeightDataLocal() => _instance;

  @override
  String get assetPath => '${super.assetPath}weight.json';
}

class HeightDataLocal extends DataLocal {
  static final HeightDataLocal _instance = HeightDataLocal._privateConstructor();
  HeightDataLocal._privateConstructor();

  factory HeightDataLocal() => _instance;

  @override
  String get assetPath => '${super.assetPath}height.json';
}