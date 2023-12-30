import 'package:fit_wallet/features/shared/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final themeModeProvider = StateNotifierProvider<_Notifier, ThemeMode>((ref) {
  final locaStorage = ref.watch(localStorageProvider);
  return _Notifier(locaStorage);
});

class _Notifier extends StateNotifier<ThemeMode> {
  _Notifier(this._storageService) : super(ThemeMode.system) {
    theme.then((value) => state = value);
  }

  final LocalStorageService _storageService;

  void changeMode(ThemeMode mode) async {
    await _storageService.setValue('themeMode', mode.name);
    state = mode;
  }

  Future<ThemeMode> get theme async {
    final theme = await _storageService.getValue('themeMode');

    return switch (theme) {
      'dark' => ThemeMode.dark,
      'light' => ThemeMode.light,
      'system' => ThemeMode.system,
      _ => ThemeMode.system,
    };
  }
}
