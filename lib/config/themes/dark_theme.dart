import 'package:fit_wallet/config/themes/colorschemes/color_schemes.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final darkTheme = Provider((ref) => DarkTheme.theme);

class DarkTheme {
  static const Color primary = Color(0xFF2a85ff);
  static const Color primaryFg = Color(0xFFeaebed);
  static const Color _secondaryFg = Color(0xFF868b90);
  static const Color primaryBg = Color(0xFF111315);
  static const Color secondaryBg = Color(0xFF1f2022);

  static const Color green = Color(0xFFb5e4ca);
  static const Color red = Color(0xFFf59062);
  static const Color orange = Color(0xFFf59062);

  // static const Color transfer = Color(0xFF2a85ff);
  // static const Color expense = Color(0xFF313131);
  // static const Color income = Color(0xFF1C1C1C);

  static Color get transfer => darkColorScheme.primaryContainer;
  static Color get expense => const Color(0xff1e1e21);
  static Color get income => darkColorScheme.secondaryContainer;

  static Color get barColor => const Color(0xff1e1e21);

  static ThemeData get theme {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.dark.copyWith(
        systemNavigationBarColor: const Color(0xff1e1e21),
      ),
    );
    return ThemeData.dark(useMaterial3: true).copyWith(
      colorScheme: darkColorScheme,
      scaffoldBackgroundColor: const Color(0xff161616),
      primaryTextTheme: const TextTheme(
        bodySmall: TextStyle(
          color: _secondaryFg,
          fontSize: 12,
        ),
        bodyLarge: TextStyle(
          color: _secondaryFg,
          fontSize: 14,
        ),
        headlineLarge: TextStyle(fontWeight: FontWeight.bold),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateColor.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return darkColorScheme.onPrimary;
            }
            return Colors.transparent;
          }),
          foregroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return darkColorScheme.background;
            }
            return darkColorScheme.onPrimary;
          }),
        ),
      ),
      dividerColor: darkColorScheme.outline,
      appBarTheme: AppBarTheme(
        surfaceTintColor: darkColorScheme.background,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
        // hintStyle: TextStyle(color: _secondaryFg),
        iconColor: primaryFg,
        prefixIconColor: primaryFg,
      ),
      bottomAppBarTheme: const BottomAppBarTheme(
        color: Color(0xff1e1e21),
        surfaceTintColor: Color(0xff1e1e21),
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          foregroundColor: MaterialStateColor.resolveWith(
              (states) => darkColorScheme.onPrimary),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          textStyle: MaterialStateProperty.resolveWith(
              (states) => const TextStyle(fontWeight: FontWeight.bold)),
          foregroundColor: MaterialStateColor.resolveWith(
              (states) => darkColorScheme.onPrimary),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: darkColorScheme.background,
        contentTextStyle: TextStyle(color: darkColorScheme.onBackground),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(60),
        ),
      ),
    );
  }
/*
  static ThemeData get theme => ThemeData.dark(useMaterial3: true).copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: primary,
          brightness: Brightness.dark,
          // surfaceTint: primaryBg,
          background: primaryBg,
        ),

        visualDensity: VisualDensity.comfortable,
        // colorScheme: darkColorScheme,
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: primary,
          // foregroundColor: _onPrimaryFg,
        ),

        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            foregroundColor:
                MaterialStateColor.resolveWith((states) => primaryFg),
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: primaryBg,
          foregroundColor: primaryFg,
          actionsIconTheme: IconThemeData(size: 20, color: primaryFg),
          toolbarHeight: 64,
        ),
        primaryTextTheme: const TextTheme(
          bodySmall: TextStyle(
            color: _secondaryFg,
            fontSize: 12,
          ),
          bodyLarge: TextStyle(
            color: _secondaryFg,
            fontSize: 14,
          ),
          headlineLarge: TextStyle(fontWeight: FontWeight.bold),
        ),
        snackBarTheme: const SnackBarThemeData(
          insetPadding: EdgeInsets.all(20),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
        ),
        // iconButtonTheme: IconButtonThemeData(
        //   style: ButtonStyle(
        //     backgroundColor:
        //         MaterialStateColor.resolveWith((states) => secondaryBg),
        //   ),
        // ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(borderSide: BorderSide(color: _outline)),
          hintStyle: TextStyle(color: _secondaryFg),
          iconColor: primaryFg,
          prefixIconColor: primaryFg,
        ),
        scaffoldBackgroundColor: primaryBg,
        dividerTheme: const DividerThemeData(color: _outline, thickness: 1),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor:
                MaterialStateColor.resolveWith((states) => secondaryBg),
            foregroundColor:
                MaterialStateColor.resolveWith((states) => primaryFg),
          ),
        ),
        datePickerTheme: DatePickerThemeData(
          backgroundColor: secondaryBg,
          surfaceTintColor: secondaryBg,
          dayForegroundColor:
              MaterialStateColor.resolveWith((states) => _secondaryFg),
          headerForegroundColor:
              MaterialStateColor.resolveWith((states) => primaryFg),
          yearForegroundColor:
              MaterialStateColor.resolveWith((states) => _secondaryFg),
          rangePickerHeaderForegroundColor:
              MaterialStateColor.resolveWith((states) => _secondaryFg),
          dividerColor: _outline,
          headerHelpStyle: const TextStyle(color: _secondaryFg),
        ),
        menuButtonTheme: MenuButtonThemeData(
          style: ButtonStyle(
            foregroundColor:
                MaterialStateColor.resolveWith((states) => _secondaryFg),
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: ButtonStyle(
            textStyle: MaterialStateProperty.resolveWith(
              (states) => const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      );*/

  static ButtonStyle primaryFilterStyle = ButtonStyle(
    backgroundColor: MaterialStateColor.resolveWith((states) => primaryFg),
    foregroundColor: MaterialStateColor.resolveWith((states) => primaryBg),
    iconColor: MaterialStateColor.resolveWith((states) => primaryBg),
    surfaceTintColor: MaterialStateColor.resolveWith((states) => primaryFg),
  );
}
