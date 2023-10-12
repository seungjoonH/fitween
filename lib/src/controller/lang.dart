import 'package:flutter/material.dart';
import 'package:get/get.dart' as get_lib;
import 'package:easy_localization/easy_localization.dart' as local_lib;

class LangCont {
  static const List<String> _supports = ['en', 'ko'];
  static const String _asset = 'assets/json/locale';
  static const String _fallback = 'en';

  static Widget equipLocalization(Widget child) {
    return local_lib.EasyLocalization(
      supportedLocales: _supports.map((s) => Locale(s)).toList(),
      path: _asset,
      fallbackLocale: const Locale(_fallback),
      child: child,
    );
  }

  static bool get isKorean => locale == 'ko';
  static bool get isEnglish => locale == 'en';

  static String get locale {
    String locale = get_lib.Get.locale!.languageCode;
    if (locale != 'ko') return 'en';
    return locale;
  }

  static String tr(String text, {
    List<String>? args,
    Map<String, String>? namedArgs,
    String? gender,
    BuildContext? context,
  }) => local_lib.tr(
    text,
    args: args,
    namedArgs: namedArgs,
    gender: gender,
    context: context,
  );

  static String plural(String text, num value, {
    List<String>? args,
    BuildContext? context,
    Map<String, String>? namedArgs,
    String? name,
    local_lib.NumberFormat? format,
  }) => text.plural(value,
    args: args,
    context: context,
    namedArgs: namedArgs,
    name: name,
    format: format,
  );
}