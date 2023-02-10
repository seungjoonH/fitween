/* 테마 관련 */

import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// global variables
// 텍스트 테마
TextTheme textTheme = Theme.of(Get.context!).textTheme;

// 컬러 스키마
ColorScheme colorScheme = Theme.of(Get.context!).colorScheme;

/// class
class PTheme {
  /// colors
  // simple
  static const Color black = Color(0xFF1F1F1F);
  static const Color lightGrey = Color(0xFFD9D9D9);
  static const Color grey = Color(0xFF73796E);
  static const Color white = Color(0xFFFDFDFD);
  static const Color bar = Color(0xFFECCFC0);
  static const Color surface = Color(0xFFFFF4F1);
  static const Color background = Color(0xFFF4E9E7);
  static const Color outline = Color(0xFF73796E);

  static const Color waterLight = Color(0xFF21CBE4);
  static const Color waterLightSecondary = Color(0xFFA1EBFF);
  static const Color waterDark = Color(0xFF1A365F);
  static const Color waterDarkSecondary = Color(0xFF4573B8);
  static const Color sun = Color(0xFFFFD600);
  static const Color moon = Color(0xFFF0F5E3);

  static const Color colorA = Color(0xFF59A86B);
  static const Color colorB = Color(0xFFE45B47);
  static const Color colorC = Color(0xFF71A3EE);
  static const Color colorD = Color(0xFFE5953E);
  static List<Color> get mainColors => [colorA, colorB, colorC, colorD];
  static List<Color> get orderedColors => [colorB, colorD, colorA, colorC];

  static const gradient = LinearGradient(colors: [
    colorA, colorB, colorC, colorD,
  ]);

  // materialColor
  static const MaterialColor primary = MaterialColor(0xFFAEDB9F, {
    100: Color(0xFFFFFFFF),
    99: Color(0xFFF7FFEE),
    95: Color(0xFFCAFFB9),
    90: Color(0xFFB0F49E),
    80: Color(0xFF95D784),
    70: Color(0xFF7BBB6B),
    60: Color(0xFF619F53),
    50: Color(0xFF48853C),
    40: Color(0xFF2F6B26),
    30: Color(0xFF15520F),
    20: Color(0xFF003A00),
    10: Color(0xFF002200),
    0: Color(0xFF000000),
  });

  static const MaterialColor secondary = MaterialColor(0xFF54634D, {
    100: Color(0xFFFFFFFF),
    99: Color(0xFFF7FFEE),
    95: Color(0xFFE5F6DB),
    90: Color(0xFFD7E8CD),
    80: Color(0xFFBBCBB2),
    70: Color(0xFFA0B097),
    60: Color(0xFF85957E),
    50: Color(0xFF6C7B65),
    40: Color(0xFF54634D),
    30: Color(0xFF3C4B37),
    20: Color(0xFF263422),
    10: Color(0xFF121F0E),
    0: Color(0xFF000000),
  });

  static const MaterialColor tertiary = MaterialColor(0xFF386569, {
    100: Color(0xFFFFFFFF),
    99: Color(0xFFF3FFFF),
    95: Color(0xFFCAF9FD),
    90: Color(0xFFBCEBEE),
    80: Color(0xFFA0CFD2),
    70: Color(0xFF85B3B6),
    60: Color(0xFF6B989C),
    50: Color(0xFF517F82),
    40: Color(0xFF386569),
    30: Color(0xFF1E4D51),
    20: Color(0xFF00373A),
    10: Color(0xFF002022),
    0: Color(0xFF000000),
  });

  static const MaterialColor error = MaterialColor(0xFFBA1A1A, {
    100: Color(0xFFFFFFFF),
    99: Color(0xFFFFFBFF),
    95: Color(0xFFFFEDEA),
    90: Color(0xFFFFDAD6),
    80: Color(0xFFFFB4AB),
    70: Color(0xFFFF897D),
    60: Color(0xFFFF5449),
    50: Color(0xFFDE3730),
    40: Color(0xFFBA1A1A),
    30: Color(0xFF93000A),
    20: Color(0xFF690005),
    10: Color(0xFF410002),
    0: Color(0xFF000000),
  });

  static const MaterialColor neutral = MaterialColor(0xFF5D5F5A, {
    100: Color(0xFFFFFFFF),
    99: Color(0xFFFCFDF6),
    95: Color(0xFFF1F1EB),
    90: Color(0xFFE2E3DC),
    80: Color(0xFFC6C7C1),
    70: Color(0xFFABACA6),
    60: Color(0xFF90918C),
    50: Color(0xFF767872),
    40: Color(0xFF5D5F5A),
    30: Color(0xFF454743),
    20: Color(0xFF2F312D),
    10: Color(0xFF1A1C18),
    0: Color(0xFF000000),
  });

  static const MaterialColor neutralVariant = MaterialColor(0xFF5A6056, {
    100: Color(0xFFFFFFFF),
    99: Color(0xFFF9FEF1),
    95: Color(0xFFEDF3E6),
    90: Color(0xFFDFE4D7),
    80: Color(0xFFC3C8BC),
    70: Color(0xFFA7ADA1),
    60: Color(0xFF8D9387),
    50: Color(0xFF73796E),
    40: Color(0xFF5A6056),
    30: Color(0xFF43483F),
    20: Color(0xFF2C3229),
    10: Color(0xFF181D15),
    0: Color(0xFF000000),
  });


  // colorScheme
  static const lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF106D34),
    onPrimary: Color(0xFFFDFDFD),
    primaryContainer: Color(0xFF9FF6AE),
    onPrimaryContainer: Color(0xFF00210B),
    secondary: Color(0xFFAC3323),
    onSecondary: Color(0xFFFDFDFD),
    secondaryContainer: Color(0xFFFFDAD4),
    onSecondaryContainer: Color(0xFF400100),
    tertiary: Color(0xFF235FA6),
    onTertiary: Color(0xFFFDFDFD),
    tertiaryContainer: Color(0xFFD5E3FF),
    onTertiaryContainer: Color(0xFF001B3C),
    error: Color(0xFFBA1A1A),
    onError: Color(0xFFFFFFFF),
    errorContainer: Color(0xFFFFDAD6),
    onErrorContainer: Color(0xFF410002),
    background: Color(0xFFF4E9E7),
    onBackground: Color(0xFF1F1F1F),
    surface: Color(0xFFFFF4F1),
    onSurface: Color(0xFF1F1F1F),
    surfaceVariant: Color(0xFFDDE5DA),
    onSurfaceVariant: Color(0xFF414941),
    outline: Color(0xFF717970),
    onInverseSurface: Color(0xFFFFEDE9),
    inverseSurface: Color(0xFF5F150A),
    inversePrimary: Color(0xFF84D994),
    shadow: Color(0xFF000000),
    surfaceTint: Color(0xFF106D34),
  );

  static const darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFF84D994),
    onPrimary: Color(0xFF003917),
    primaryContainer: Color(0xFF005224),
    onPrimaryContainer: Color(0xFF9FF6AE),
    secondary: Color(0xFFFFB4A7),
    onSecondary: Color(0xFF680300),
    secondaryContainer: Color(0xFF8B1A0E),
    onSecondaryContainer: Color(0xFFFFDAD4),
    tertiary: Color(0xFFA7C8FF),
    onTertiary: Color(0xFF003061),
    tertiaryContainer: Color(0xFF004788),
    onTertiaryContainer: Color(0xFFD5E3FF),
    error: Color(0xFFFFB4AB),
    errorContainer: Color(0xFF93000A),
    onError: Color(0xFF690005),
    onErrorContainer: Color(0xFFFFDAD6),
    background: Color(0xFF3F0300),
    onBackground: Color(0xFFFFDAD4),
    surface: Color(0xFF3F0300),
    onSurface: Color(0xFFFFDAD4),
    surfaceVariant: Color(0xFF414941),
    onSurfaceVariant: Color(0xFFC1C9BE),
    outline: Color(0xFF8B9389),
    onInverseSurface: Color(0xFF3F0300),
    inverseSurface: Color(0xFFFFDAD4),
    inversePrimary: Color(0xFF106D34),
    shadow: Color(0xFF000000),
    surfaceTint: Color(0xFF84D994),
  );

  // surface
  // static Map<int, Color> get surface => {
  //   Brightness.light: {
  //     1: Color.alphaBlend(
  //       primary[40]!.withOpacity(.05),
  //       Theme.of(Get.context!).colorScheme.surface,
  //     ),
  //     2: Color.alphaBlend(
  //       primary[40]!.withOpacity(.08),
  //       Theme.of(Get.context!).colorScheme.surface,
  //     ),
  //     3: Color.alphaBlend(
  //       primary[40]!.withOpacity(.11),
  //       Theme.of(Get.context!).colorScheme.surface,
  //     ),
  //     4: Color.alphaBlend(
  //       primary[40]!.withOpacity(.12),
  //       Theme.of(Get.context!).colorScheme.surface,
  //     ),
  //     5: Color.alphaBlend(
  //       primary[40]!.withOpacity(.14),
  //       Theme.of(Get.context!).colorScheme.surface,
  //     ),
  //   },
  //   Brightness.dark: {
  //     1: Color.alphaBlend(
  //       primary[80]!.withOpacity(.05),
  //       Theme.of(Get.context!).colorScheme.surface,
  //     ),
  //     2: Color.alphaBlend(
  //       primary[80]!.withOpacity(.08),
  //       Theme.of(Get.context!).colorScheme.surface,
  //     ),
  //     3: Color.alphaBlend(
  //       primary[80]!.withOpacity(.11),
  //       Theme.of(Get.context!).colorScheme.surface,
  //     ),
  //     4: Color.alphaBlend(
  //       primary[80]!.withOpacity(.12),
  //       Theme.of(Get.context!).colorScheme.surface,
  //     ),
  //     5: Color.alphaBlend(
  //       primary[80]!.withOpacity(.14),
  //       Theme.of(Get.context!).colorScheme.surface,
  //     ),
  //   },
  // }[Theme.of(Get.context!).brightness]!;

  /// typography
  static const fontFamily = 'Pretendard';

  static TextStyle largeText = const TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w700,
    fontSize: 100.0,
    height: (64 / 57),
  );

  static TextTheme textTheme = const TextTheme(
    //Display
    displayLarge: TextStyle(
      fontFamily: fontFamily,
      fontWeight: FontWeight.w700,
      fontSize: 57.0,
      height: (64 / 57),
    ),
    displayMedium: TextStyle(
      fontFamily: fontFamily,
      fontWeight: FontWeight.w700,
      fontSize: 45.0,
      height: (52 / 45),
    ),
    displaySmall: TextStyle(
      fontFamily: fontFamily,
      fontWeight: FontWeight.w700,
      fontSize: 36.0,
      height: (44 / 36),
    ),

    //Headline
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

    //Title
    titleLarge: TextStyle(
      fontFamily: fontFamily,
      fontWeight: FontWeight.w500,
      fontSize: 22.0,
      height: (28 / 22),
    ),
    titleMedium: TextStyle(
      fontFamily: fontFamily,
      fontWeight: FontWeight.w500,
      fontSize: 18.0,
      height: (24 / 18),
    ),
    titleSmall: TextStyle(
      fontFamily: fontFamily,
      fontWeight: FontWeight.w500,
      fontSize: 14.0,
      height: (20 / 14),
    ),

    //Label
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
      fontSize: 11.0,
      height: (16 / 11),
    ),

    //Body
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
