import 'package:fitween/src/controller/page.dart';
import 'package:flutter/material.dart';

TextTheme textTheme(BuildContext context) => Theme.of(context).textTheme;
ColorScheme colorScheme(BuildContext context) => Theme.of(context).colorScheme;

class FTheme {
  static Brightness get brightness => PageCont.mediaQuery.platformBrightness;
  static bool get isLightMode => brightness == Brightness.light;
  static bool get isDarkMode => brightness == Brightness.dark;

  static const Color colorA = Color(0xFF50CDC4);
  static const Color colorB = Color(0xFFFB656A);
  static const Color colorC = Color(0xFF29A9FA);
  static const Color colorD = Color(0xFFFFB164);

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
  static const Color achro70 = Color(0xFFE9E9E9);
  static const Color achro80 = Color(0xFFEEEEEE);
  static const Color achro90 = Color(0xFFF4F4F4);
  static const Color achro95 = Color(0xFFFDFDFD);
  static const Color achro100 = Colors.white;

  static Color get text => isLightMode ? achro30 : achro70;
  static Color get textAlt => isLightMode ? achro10 : achro90;
  static Color get hintText => isLightMode ? achro60 : achro40;
  static Color get comment => isLightMode ? achro50 : achro50;
  static Color get card => isLightMode ? achro95 : achro30;
  static Color get background => isLightMode ? achro90 : achro10;
  static Color get backgroundAlt => isLightMode ? achro95 : achro5;
  static Color get stroke => isLightMode ? achro60 : achro40;
  static Color get selected => isLightMode ? achro40 : achro60;
  static Color get unselected => achro50;
  static Color get shimmer => isLightMode ? achro30 : achro70;
  static Color get bar => isLightMode ? achro60 : achro40;
  static Color get surface => isLightMode ? achro90 : achro10;
  static Color get outline => isLightMode ? achro40 : achro60;

  static const Color error = Color(0xFFBA1A1A);

  /// typography
  static const fontFamily = 'Pretendard';

  static TextTheme get _textTheme => Theme.of(PageCont.context).textTheme;

  static TextStyle? get cardTitleStyle => headlineSmall;
  static TextStyle? get commentStyle => bodyLarge;

  static TextStyle? get displayLarge => _textTheme.displayLarge;
  static TextStyle? get displayMedium => _textTheme.displayMedium;
  static TextStyle? get displaySmall => _textTheme.displaySmall;
  static TextStyle? get headlineLarge => _textTheme.headlineLarge;
  static TextStyle? get headlineMedium => _textTheme.headlineMedium;
  static TextStyle? get headlineSmall => _textTheme.headlineSmall;
  static TextStyle? get titleLarge => _textTheme.titleLarge;
  static TextStyle? get titleMedium => _textTheme.titleMedium;
  static TextStyle? get titleSmall => _textTheme.titleSmall;
  static TextStyle? get bodyLarge => _textTheme.bodyLarge;
  static TextStyle? get bodyMedium => _textTheme.bodyMedium;
  static TextStyle? get bodySmall => _textTheme.bodySmall;
  static TextStyle? get labelLarge => _textTheme.labelLarge;
  static TextStyle? get labelMedium => _textTheme.labelMedium;
  static TextStyle? get labelSmall => _textTheme.labelSmall;

  static TextStyle get veryLargeText => const TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w700,
    fontSize: 250.0,
    height: (270 / 250),
  );

  static TextStyle get largeText => const TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w700,
    fontSize: 70.0,
    height: (74 / 70),
  );

  static TextTheme get textTheme => const TextTheme(
    displayLarge: TextStyle(
      fontFamily: fontFamily,
      fontWeight: FontWeight.w700,
      fontSize: 50.0,
      height: (60 / 50),
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
      height: (22 / 18),
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
      height: (24 / 16),
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
