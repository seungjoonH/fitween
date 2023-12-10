import 'package:fitween/global/global.dart';
import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/model/class/dao.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum GeneralSettingMenu {
  display, language;

  String get _tr => 'settings.general-menu';
  String get locale => LangCont
      .tr('$_tr.${name.toSkewerCase}');
}

class GeneralSettingPageCont extends PageCont {
  static GeneralSettingPageCont get to => Get.find<GeneralSettingPageCont>();

  String get appBarTitle => LangCont.tr('appbar.general');

  static const String _asset = 'assets/image/page/see_more/settings';
  String get _selectedAsset => '$_asset/selected';
  String get _unselectedAsset => '$_asset/unselected';

  ThemeMode get themeMode => ThemeCont.to.themeMode;

  Map<ThemeMode, String> get modeAssets {
    return ThemeMode.values.asMap().map((index, mode) {
      String asset = themeMode == mode ? _selectedAsset : _unselectedAsset;
      return MapEntry(mode, '$asset/${mode.name}_theme.svg');
    });
  }

  Language get language => LangCont.to.language;

  Map<Language, String> get langAssets {
    return Language.values.asMap().map((index, lang) {
      String asset = language == lang ? _selectedAsset : _unselectedAsset;
      return MapEntry(lang, '$asset/${lang.name}_lang.svg');
    });
  }

  void setMode(ThemeMode mode) { ThemeCont.to.setThemeMode(mode); _save(); }
  void setLang(Language lang) { LangCont.to.setLanguage(lang); _save(); }

  void _save() async {
    logged.info!.setThemeMode(themeMode);
    logged.info!.setLanguage(language);
    await FUserInfoDAO().saveOne(logged.info!);
    await onRefresh();
  }

  @override
  Future load() async {}

  @override
  String get loadKey => 'display-setting';
}