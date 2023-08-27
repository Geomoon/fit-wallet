import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final darkTheme = Provider((ref) => DarkTheme.theme);

class DarkTheme {
  // primary => 436DFF
  static const Color _primary = Color(0xFF436DFF);
  static const Color _primaryFg = Color(0xFFF1F1F1);
  static const Color _secondaryFg = Color(0xFF7F7F7F);
  static const Color _primaryBg = Color(0xFF111111);
  static const Color _secondaryBg = Color(0xFF1C1C1C);
  static const Color _outline = Color(0xFF313131);

  static ThemeData get theme => ThemeData.dark(useMaterial3: true).copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: _primary,
          brightness: Brightness.dark,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: _primary,
          foregroundColor: _primaryFg,
        ),
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            foregroundColor:
                MaterialStateColor.resolveWith((states) => _primaryFg),
          ),
        ),
        textTheme: const TextTheme(
          bodySmall: TextStyle(
            color: _secondaryFg,
            fontSize: 12,
          ),
          headlineLarge: TextStyle(fontWeight: FontWeight.bold),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(borderSide: BorderSide(color: _outline)),
          hintStyle: TextStyle(color: _secondaryFg),
          iconColor: _primaryFg,
          prefixIconColor: _primaryFg,
        ),
        scaffoldBackgroundColor: _primaryBg,
        dividerTheme: const DividerThemeData(color: _outline, thickness: 1),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor:
                MaterialStateColor.resolveWith((states) => _secondaryBg),
            foregroundColor:
                MaterialStateColor.resolveWith((states) => _primaryFg),
          ),
        ),
        datePickerTheme: DatePickerThemeData(
          backgroundColor: _secondaryBg,
          surfaceTintColor: _secondaryBg,
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
