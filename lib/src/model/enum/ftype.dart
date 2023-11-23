import 'package:fitween/global/global.dart';
import 'package:fitween/src/controller/lang.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum FType {
  calorie, distance, height, weight;

  String get locale => LangCont.tr('type.$name');
  String get localeShort => LangCont.isEnglish 
      ? locale.toUpperCase().substring(0, 3) : locale;
  String get _unitKey => ['', 'step', 'floor', 'count'][index];
  String get _altUnitKey => ['', 'step', 'floor', 'kg'][index];
  Color get color => [ThemeCont.colorA, ThemeCont.colorB, ThemeCont.colorC, ThemeCont.colorD][index];
  bool get active => activeValues.contains(this);

  String withUnit(num value, {bool thouSep = true, bool scaling = true, bool txs = false}) {
    String unit = LangCont.plural('unit.$_unitKey', value);
    return unit.replaceAll('[]', value.localizing(
      thouSep: thouSep, scaling: scaling, txs: txs,
    ));
  }

  String withAltUnit(num value, {bool thouSep = true, bool scaling = true, bool txs = false}) {
    String unit = LangCont.plural('unit.$_altUnitKey', value);
    return unit.replaceAll('[]', value.localizing(
      thouSep: thouSep, scaling: scaling, txs: txs,
    ));
  }

  String onlyUnit(num value) => withUnit(value, thouSep: false, scaling: false).replaceAll(RegExp(r'\d+'), '');
  String onlyAltUnit(num value) => withAltUnit(value, thouSep: false, scaling: false).replaceAll(RegExp(r'\d+'), '');

  static FType? toEnum(String? string) => FType
      .values.firstWhereOrNull((type) => type.name == string);

  static List<FType> get activeValues => [distance, height, weight];
}
