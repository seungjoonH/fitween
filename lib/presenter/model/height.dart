import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:fitween/model/enum/sex.dart';

class HeightPresenter extends GetxController {
  static String asset = 'assets/json/data/height.json';
  static Map<String, dynamic> heights = {};

  // 챌린지 json 파일 가져오기
  static Future importFile() async {
    String string = await rootBundle.loadString(asset);
    heights = jsonDecode(string) as Map<String, dynamic>;
  }

  static int getAverageHeight(int age, Sex sex) {
    int generation = age < 20 ? age : age ~/ 10 * 10;
    generation = max(min(generation, 80), 6);
    return heights[generation.toString()][sex.index];
  }
}