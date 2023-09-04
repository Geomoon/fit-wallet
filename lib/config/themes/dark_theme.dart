import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final darkTheme = Provider((ref) => DarkTheme.theme);

class DarkTheme {
  // primary => 436DFF
  static const Color _primary = Color(0xFF436DFF);
  static const Color _primaryDark = Color(0xFFb7c4ff);
  static const Color _primaryFg = Color(0xFFF1F1F1);
  static const Color _onPrimaryFg = Color(0xFF002583);
  static const Color _secondaryFg = Color(0xFF7F7F7F);
  static const Color primaryBg = Color(0xFF111111);
  static const Color secondaryBg = Color(0xFF1C1C1C);
  static const Color _outline = Color(0xFF313131);

  static ThemeData get theme => ThemeData.dark(useMaterial3: true).copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: _primary,
          brightness: Brightness.dark,
          // surface: _secondaryBg,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: _primaryDark,
          foregroundColor: _onPrimaryFg,
        ),
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            foregroundColor:
                MaterialStateColor.resolveWith((states) => _primaryFg),
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: primaryBg,
          foregroundColor: _primaryFg,
          actionsIconTheme: IconThemeData(size: 20, color: _primaryFg),
          toolbarHeight: 64,
        ),
        textTheme: const TextTheme(
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
          iconColor: _primaryFg,
          prefixIconColor: _primaryFg,
        ),
        scaffoldBackgroundColor: primaryBg,
        dividerTheme: const DividerThemeData(color: _outline, thickness: 1),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor:
                MaterialStateColor.resolveWith((states) => secondaryBg),
            foregroundColor:
                MaterialStateColor.resolveWith((states) => _primaryFg),
          ),
        ),
        datePickerTheme: DatePickerThemeData(
          backgroundColor: secondaryBg,
          surfaceTintColor: secondaryBg,
          dayForegroundColor:
              MaterialStateColor.resolveWith((states) => _secondaryFg),
          headerForegroundColor:
              MaterialStateColor.resolveWith((states) => _primaryFg),
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
      );
}
