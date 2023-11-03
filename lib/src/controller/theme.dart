import 'package:fitween/src/controller/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

extension ThemeModeExtension on ThemeMode {
  String get _tr => 'settings.general-menu.display-type';
  String get locale => LangCont.tr('$_tr.$name');
  static ThemeMode? toEnum(String? string) =>
      ThemeMode.values.firstWhereOrNull((mode) => mode.name == string);
}

TextTheme textTheme(BuildContext context) => Theme.of(context).textTheme;
ColorScheme colorScheme(BuildContext context) => Theme.of(context).colorScheme;

class ThemeCont extends GetxController {
  static ThemeCont get to => Get.find<ThemeCont>();

  final _mode = ThemeMode.system.obs;
  ThemeMode get themeMode => _mode.value;

  void setThemeMode(ThemeMode mode) => _mode(mode);
  void init() => _mode(AuthCont.logged!.themeMode);

  Brightness get brightness {
    Brightness system = PageCont.mediaQuery.platformBrightness;
    if (!AuthCont.isLogged) return system;
    switch (themeMode) {
      case ThemeMode.system: return system;
      case ThemeMode.light: return Brightness.light;
      case ThemeMode.dark: return Brightness.dark;
    }
  }
  bool get isLightMode => brightness == Brightness.light;
  bool get isDarkMode => brightness == Brightness.dark;

  static const Color colorA = Color(0xFF50CDC4);
  static const Color colorB = Color(0xFFFB656A);
  static const Color colorC = Color(0xFF29A9FA);
  static const Color colorD = Color(0xFFFFB164);
  static const Color colorE = Color(0xFFD782FF);

  static const Color gold = Color(0xFFFFAB48);
  static const Color silver = Color(0xFFD7D7D7);
  static const Color bronze = Color(0xFFB78250);

  static const Color sea = Color(0xFF6BD4EB);
  static const Color darkSea = Color(0xFF35359E);

  // static const Color black = Color(0xFF1F1F1F);
  // static const Color darkGrey = Color(0xFF494D45);
  // static const Color grey = Color(0xFF73796E);
  // static const Color stroke = Color(0xFFAAAAAA);
  // static const Color lightGrey = Color(0xFFB4B4B4);
  // static const Color background = Color(0xFFF4F4F4);
  // static const Color white = Color(0xFFFDFDFD);

  // static const Color achro0 = Colors.black;
  // static const Color achro10 = Color(0xFF1F1F1F);
  // static const Color achro20 = Color(0xFF323436);
  // static const Color achro30 = Color(0xFF494D45);
  // static const Color achro40 = Color(0xFF73796E);
  // static const Color achro50 = Color(0xFFAAAAAA);
  // static const Color achro60 = Color(0xFFB4B4B4);
  // static const Color achro70 = Color(0xFFE9E9E9);
  // static const Color achro80 = Color(0xFFF4F4F4);
  // static const Color achro90 = Color(0xFFFDFDFD);
  // static const Color achro100 = Colors.white;

  static const Color achro0 = Colors.black;
  static const Color achro5 = Color(0xFF131313);
  static const Color achro10 = Color(0xFF1F1F1F);
  static const Color achro20 = Color(0xFF323436);
  static const Color achro30 = Color(0xFF494D45);
  static const Color achro40 = Color(0xFF73796E);
  static const Color achro50 = Color(0xFFAAAAAA);
  static const Color achro60 = Color(0xFFB4B4B4);
  static const Color achro70 = Color(0xFFDEDEDE);
  static const Color achro80 = Color(0xFFEEEEEE);
  static const Color achro90 = Color(0xFFF4F4F4);
  static const Color achro95 = Color(0xFFFDFDFD);
  static const Color achro100 = Colors.white;

  Color get text => isLightMode ? achro30 : achro70;
  Color get textAlt => isLightMode ? achro10 : achro90;
  Color get hintText => isLightMode ? achro60 : achro40;
  Color get comment => isLightMode ? achro50 : achro50;
  Color get card => isLightMode ? achro95 : achro20;
  Color get background => isLightMode ? achro90 : achro10;
  Color get backgroundAlt => isLightMode ? achro95 : achro5;
  Color get stroke => isLightMode ? achro60 : achro40;
  Color get selected => isLightMode ? achro30 : achro70;
  Color get unselected => achro50;
  Color get shimmer => achro50;
  Color get bar => isLightMode ? achro70 : achro30;
  Color get surface => isLightMode ? achro90 : achro10;
  Color get outline => isLightMode ? achro40 : achro60;

  Color get point => colorE;
  static const Color error = Color(0xFFBA1A1A);

  /// typography
  static const fontFamily = 'Pretendard';

  TextStyle? get cardTitleStyle => headlineSmall;
  TextStyle? get commentStyle => bodyLarge;

  TextStyle? get displayLarge => textTheme.displayLarge;
  TextStyle? get displayMedium => textTheme.displayMedium;
  TextStyle? get displaySmall => textTheme.displaySmall;
  TextStyle? get headlineLarge => textTheme.headlineLarge;
  TextStyle? get headlineMedium => textTheme.headlineMedium;
  TextStyle? get headlineSmall => textTheme.headlineSmall;
  TextStyle? get titleLarge => textTheme.titleLarge;
  TextStyle? get titleMedium => textTheme.titleMedium;
  TextStyle? get titleSmall => textTheme.titleSmall;
  TextStyle? get bodyLarge => textTheme.bodyLarge;
  TextStyle? get bodyMedium => textTheme.bodyMedium;
  TextStyle? get bodySmall => textTheme.bodySmall;
  TextStyle? get labelLarge => textTheme.labelLarge;
  TextStyle? get labelMedium => textTheme.labelMedium;
  TextStyle? get labelSmall => textTheme.labelSmall;

  TextStyle get veryLargeText => const TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w700,
    fontSize: 250.0,
    height: (270 / 250),
  );

  TextStyle get largeText => const TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w700,
    fontSize: 58.0,
    height: (66 / 58),
  );

  TextTheme get textTheme => const TextTheme(
    displayLarge: TextStyle(
      fontFamily: fontFamily,
      fontWeight: FontWeight.w700,
      fontSize: 48.0,
      height: (60 / 48),
    ),
    displayMedium: TextStyle(
      fontFamily: fontFamily,
      fontWeight: FontWeight.w700,
      fontSize: 42.0,
      height: (52 / 42),
    ),
    displaySmall: TextStyle(
      fontFamily: fontFamily,
      fontWeight: FontWeight.w700,
      fontSize: 34.0,
      height: (44 / 34),
    ),
    headlineLarge: TextStyle(
      fontFamily: fontFamily,
      fontWeight: FontWeight.w700,
      fontSize: 32.0,
      height: (40 / 32),
    ),
    headlineMedium: TextStyle(
      fontFamily: fontFamily,
      fontWeight: FontWeight.w700,
      fontSize: 28.0,
      height: (36 / 28),
    ),
    headlineSmall: TextStyle(
      fontFamily: fontFamily,
      fontWeight: FontWeight.w700,
      fontSize: 24.0,
      height: (32 / 24),
    ),
    titleLarge: TextStyle(
      fontFamily: fontFamily,
      fontWeight: FontWeight.w500,
      fontSize: 22.0,
      height: (30 / 22),
    ),
    titleMedium: TextStyle(
      fontFamily: fontFamily,
      fontWeight: FontWeight.w500,
      fontSize: 20.0,
      height: (28 / 20),
    ),
    titleSmall: TextStyle(
      fontFamily: fontFamily,
      fontWeight: FontWeight.w500,
      fontSize: 18.0,
      height: (26 / 18),
    ),
    labelLarge: TextStyle(
      fontFamily: fontFamily,
      fontWeight: FontWeight.w500,
      fontSize: 14.0,
      height: (20 / 14),
    ),
    labelMedium: TextStyle(
      fontFamily: fontFamily,
      fontWeight: FontWeight.w500,
      fontSize: 12.0,
      height: (16 / 12),
    ),
    labelSmall: TextStyle(
      fontFamily: fontFamily,
      fontWeight: FontWeight.w500,
      fontSize: 10.0,
      height: (13 / 10),
    ),
    bodyLarge: TextStyle(
      fontFamily: fontFamily,
      fontWeight: FontWeight.w400,
      fontSize: 16.0,
      height: (22 / 16),
    ),
    bodyMedium: TextStyle(
      fontFamily: fontFamily,
      fontWeight: FontWeight.w400,
      fontSize: 14.0,
      height: (20 / 14),
    ),
    bodySmall: TextStyle(
      fontFamily: fontFamily,
      fontWeight: FontWeight.w400,
      fontSize: 12.0,
      height: (16 / 12),
    ),
  );
}
