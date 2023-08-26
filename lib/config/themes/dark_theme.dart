import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final darkTheme = Provider((ref) => DarkTheme.theme);

class DarkTheme {
  static const Color _primary = Color(0xFF3569FC);
  static const Color _primaryFg = Color(0xFFF1F1F1);
  static ThemeData get theme => ThemeData.dark(useMaterial3: true).copyWith(
        colorScheme: ColorScheme.fromSeed(seedColor: _primary),
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
      );
}
