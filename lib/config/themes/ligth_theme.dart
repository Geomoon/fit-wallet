import 'package:fit_wallet/config/themes/colorschemes/color_schemes.g.dart';
import 'package:flutter/material.dart';

class LightTheme {
  static const Color primary = Color(0xFF2a85ff);
  static final Color primaryFg = lightColorScheme.onBackground;
  static const Color primaryBg = Color(0xFF111315);
  static const Color secondaryBg = Color(0xFF1f2022);

  static const Color green = Color(0xFF6A9C59);
  static const Color red = Color(0xFF9C4146);

  static Color get transfer => lightColorScheme.primaryContainer;
  static Color get expense => const Color(0xff1e1e21);
  static Color get income => lightColorScheme.secondaryContainer;

  static Color get barColor => const Color(0xFFEBEDFB);

  static ThemeData get theme {
    // SystemChrome.setSystemUIOverlayStyle(
    //   SystemUiOverlayStyle.light.copyWith(
    //     systemNavigationBarColor: barColor,
    //   ),
    // );
    return ThemeData.light(useMaterial3: true).copyWith(
      colorScheme: lightColorScheme,
      scaffoldBackgroundColor: lightColorScheme.background,
      primaryTextTheme: TextTheme(
        bodySmall: TextStyle(
          color: lightColorScheme.onBackground,
          fontSize: 12,
        ),
        bodyLarge: TextStyle(
          color: lightColorScheme.onBackground,
          fontSize: 14,
        ),
        labelLarge: TextStyle(
          color: lightColorScheme.onBackground,
          fontSize: 14,
        ),
        labelMedium: TextStyle(
          color: lightColorScheme.onBackground,
        ),
        bodyMedium: TextStyle(
          color: lightColorScheme.onBackground,
        ),
        titleMedium: TextStyle(
          color: lightColorScheme.onBackground,
        ),
        titleLarge: TextStyle(
          color: lightColorScheme.onBackground,
          fontSize: 20,
        ),
        headlineLarge: TextStyle(
            fontWeight: FontWeight.bold, color: lightColorScheme.onBackground),
        headlineSmall: TextStyle(
            fontWeight: FontWeight.bold, color: lightColorScheme.onBackground),
      ),
      iconButtonTheme: IconButtonThemeData(
          style: ButtonStyle(
        iconColor: MaterialStateColor.resolveWith(
            (states) => lightColorScheme.onBackground),
      )),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateColor.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return lightColorScheme.onBackground;
            }
            return Colors.transparent;
          }),
          foregroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return lightColorScheme.onPrimary;
            }
            return lightColorScheme.onBackground;
          }),
        ),
      ),
      dividerColor: lightColorScheme.outline,
      appBarTheme: AppBarTheme(
        surfaceTintColor: lightColorScheme.background,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: const OutlineInputBorder(),
        // hintStyle: TextStyle(color: _secondaryFg),

        iconColor: lightColorScheme.onBackground,
        prefixIconColor: lightColorScheme.onBackground,
      ),
      iconTheme: IconThemeData(color: lightColorScheme.onBackground),
      bottomAppBarTheme: const BottomAppBarTheme(
          // color: Color(0xff1e1e21),
          // surfaceTintColor: Color(0xff1e1e21),
          ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          foregroundColor: MaterialStateColor.resolveWith(
            (states) => lightColorScheme.onBackground,
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          textStyle: MaterialStateProperty.resolveWith(
              (states) => const TextStyle(fontWeight: FontWeight.bold)),
          foregroundColor: MaterialStateColor.resolveWith(
              (states) => lightColorScheme.onBackground),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: lightColorScheme.background,
        contentTextStyle: TextStyle(color: lightColorScheme.onBackground),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(60),
        ),
      ),
    );
  }

  static ButtonStyle primaryFilterStyle = ButtonStyle(
    backgroundColor: MaterialStateColor.resolveWith(
      (states) => lightColorScheme.onBackground,
    ),
    foregroundColor: MaterialStateColor.resolveWith((states) => primaryBg),
    iconColor: MaterialStateColor.resolveWith(
      (states) => lightColorScheme.onBackground,
    ),
    surfaceTintColor: MaterialStateColor.resolveWith((states) => primaryFg),
  );
}
