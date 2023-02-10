import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:fitween/model/enum/activity_type.dart';

/// class
// 월간 도전과제 [quests.json] 파일 관련
class QuestPresenter extends GetxController {
  /// static variables
  static String asset = 'assets/json/data/quests.json';
  static Map<ActivityType, int> quests = {};

  /// static methods
  // 월간 도전과제 불러오기
  static Future importFile() async {
    String string = await rootBundle.loadString(asset);
    Map<String, dynamic> list = jsonDecode(string);
    list.forEach((type, amount) {
      quests[ActivityType.toEnum(type)!] = amount.toInt();
    });
  }
}