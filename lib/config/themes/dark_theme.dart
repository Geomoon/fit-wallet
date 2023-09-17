import 'package:fit_wallet/config/themes/colorschemes/color_schemes.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final darkTheme = Provider((ref) => DarkTheme.theme);

class DarkTheme {
  // primary => 436DFF
  // static const Color _primary = Color(0xFF436DFF);
  static const Color primary = Color(0xFF2a85ff);
  static const Color _primaryDark = Color(0xFF111315);
  // static const Color primaryFg = Color(0xFFF1F1F1);
  static const Color primaryFg = Color(0xFFeaebed);
  static const Color _onPrimaryFg = Color(0xFF002583);
  static const Color _secondaryFg = Color(0xFF868b90);
  // static const Color primaryBg = Color(0xFF111111);
  static const Color primaryBg = Color(0xFF111315);
  // static const Color primaryBg = Color(0xFF1b1b1d);
  // static const Color secondaryBg = Color(0xFF1C1C1C);
  static const Color secondaryBg = Color(0xFF1f2022);
  static const Color _outline = Color(0xFF383d44);

  // bg: 1b1b1d
  // bg2: 28282a
  // green: 72b67a

  // dark: 17181a
  // dark2: 1f2022
  // primary: 4e7ffc
  // fg: eaebed

  static const Color green = Color(0xFFb5e4ca);
  static const Color red = Color(0xFFffd1b0);

  static const Color transfer = Color(0xFF2a85ff);
  static const Color expense = Color(0xFF313131);
  static const Color income = Color(0xFF1C1C1C);

  static ThemeData get theme => ThemeData.dark(useMaterial3: true).copyWith(
        colorScheme: darkColorScheme,
        scaffoldBackgroundColor: Color(0xff161616),
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
        dividerColor: darkColorScheme.outline,
        appBarTheme: AppBarTheme(surfaceTintColor: darkColorScheme.background),
        bottomAppBarTheme: BottomAppBarTheme(
          color: darkColorScheme.background,
          surfaceTintColor: darkColorScheme.background,
        ),
      );
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
