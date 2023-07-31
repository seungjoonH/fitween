import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fitween/global/theme.dart';

enum ActivityType {
  calorie, distance, height, weight;

  String get locale {
    if (Get.locale!.languageCode == 'ko') return ['칼로리', '거리', '높이', '무게'][index];
    return ['calorie', 'distance', 'height', 'weight'][index];
  }
  Color get color => [FTheme.colorA, FTheme.colorB, FTheme.colorC, FTheme.colorD][index];
  String get asset => ['lightning.svg', 'running.svg', 'stairs.svg', 'dumbbell.svg'][index];
  bool get active => activeValues.contains(this);

  static ActivityType? toEnum(String? string) =>
    ActivityType.values.firstWhereOrNull((type) => type.name == string);

  static List<ActivityType> get activeValues => [distance, height, weight];

}
