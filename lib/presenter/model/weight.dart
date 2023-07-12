import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:fitween/model/enum/sex.dart';

class WeightPresenter extends GetxController {
  static String asset = 'assets/json/data/weight.json';
  static Map<String, dynamic> weights = {};

  // 챌린지 json 파일 가져오기
  static Future importFile() async {
    String string = await rootBundle.loadString(asset);
    weights = jsonDecode(string) as Map<String, dynamic>;
  }

  static int getAverageWeight(int age, Sex sex) {
    int generation = age < 20 ? age : age ~/ 10 * 10;
    generation = max(min(generation, 70), 6);
    return weights[generation.toString()][sex.index];
  }
}