import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final lightTheme = Provider((ref) => LightTheme.theme);

class LightTheme {
  static ThemeData get theme => ThemeData.light(useMaterial3: true)
      .copyWith(appBarTheme: AppBarTheme(centerTitle: true));
}
