import 'package:fitween/global/global.dart';
import 'package:fitween/src/controller/lang.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum FType {
  calorie, distance, height, weight;

  String get locale => LangCont.tr('type.$name');
  String get _unitKey => ['', 'step', 'floor', 'count'][index];
  Color get color => [FTheme.colorA, FTheme.colorB, FTheme.colorC, FTheme.colorD][index];
  bool get active => activeValues.contains(this);

  String withUnit(num value, {bool thouSep = true, bool scaling = true, bool decimal = true}) {
    String unit = LangCont.plural('unit.$_unitKey', value);
    return unit.replaceAll('[]', value.localizing(
      thouSep: thouSep, scaling: scaling, decimal: decimal,
    ));
  }

  static FType? toEnum(String? string) => FType
      .values.firstWhereOrNull((type) => type.name == string);

  static List<FType> get activeValues => [distance, height, weight];
}
