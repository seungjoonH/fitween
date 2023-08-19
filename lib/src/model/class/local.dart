import 'dart:convert';

import 'package:fitween/src/model/class/local.dart';
import 'package:fitween/src/model/class/model.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

export './local/badge.dart';
export './local/challenge.dart';
export './local/level.dart';

abstract class LocalModel<T extends Model> {
  static Future loadAll() async {
    await FBadgeLocal().load();
    await ChallengeLocal().load();
    await DistanceLevelLocal().load();
    await HeightLevelLocal().load();
    await WeightLevelLocal().load();
  }

  List<T> list = [];

  Future<String> get jsonString async {
    return await rootBundle.loadString(assetPath);
  }

  String get assetPath;

  T fromJson(Map<String, dynamic> json);

  Future load() async {
    list = jsonDecode(await jsonString)
        .map<T>((json) => fromJson(json)).toList();
  }

  T? get(String? id) {
    return list.firstWhereOrNull((t) => t.key == id);
  }
}