/* 단계 프리젠터 */

import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:fitween/model/class/json/level.dart';
import 'package:fitween/model/enum/activity_type.dart';
import 'package:fitween/model/enum/unit.dart';
import 'package:fitween/presenter/model/record.dart';

/// class
// 단계 [level/*.json] 파일 관련
class LevelJsonP extends GetxController {
  static String asset = 'assets/json/data/level/';
  static Map<ActivityType, List<Level>> levels = {};

  // 단계 json 파일 가져오기
  static Future importFile(ActivityType type) async {
    String string = await rootBundle.loadString('$asset${type.name}.json');
    List<dynamic> list = jsonDecode(string);
    levels[type] = list.map((json) => Level.fromJson(json)).toList()
        .where((json) => json.activate!).toList();
  }

  // 활동형식의 해당 값의 등급(티어) 정보 반환
  // 현재 등급과 다음 등급의 제목 및 값, 현재 백분율 값 반환
  static Map<String, dynamic> getTier(ActivityType type, Record record) {
    Map<String, dynamic> result = {};

    List<Level> levelList = levels[type] ?? [];
    record.convert({
      ActivityType.distance: ExerciseUnit.kilometer,
      ActivityType.weight: ExerciseUnit.count,
    }[type]);

    for (int i = 0; i < levelList.length - 1; i++) {
      double current = levelList[i].amount!;
      double next = levelList[i + 1].amount!;

      if (record.amount >= current && record.amount < next) {
        result['current'] = levelList[i];
        result['next'] = levelList[i + 1];
        result['percent'] = (record.amount - current) / (next - current);
      }
    }
    return result;
  }

  static List<Level> getUnlockedLevels(ActivityType type, Record record) {
    record.convert({
      ActivityType.distance: ExerciseUnit.kilometer,
      ActivityType.weight: ExerciseUnit.weight,
    }[type]);
    return levels[type]!
        .where((level) => level.amount! <= record.amount).toList();
  }
}