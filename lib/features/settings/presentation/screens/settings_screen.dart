import 'package:fit_wallet/config/themes/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: const _SettingsScreenView(),
    );
  }
}

class _SettingsScreenView extends StatelessWidget {
  const _SettingsScreenView();

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Consumer(builder: (_, ref, __) {
          final isDark = ref.watch(themeModeProvider) == ThemeMode.dark;
          return ListTile(
            leading: isDark
                ? const Icon(Icons.dark_mode_rounded)
                : const Icon(Icons.light_mode_rounded),
            title: const Text('Dark Theme'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(width: 20),
                Switch.adaptive(
                  value: isDark,
                  onChanged: (v) {
                    ref.read(themeModeProvider.notifier).changeMode(
                          isDark ? ThemeMode.light : ThemeMode.dark,
                        );
                  },
                ),
              ],
            ),
          );
        })
      ],
    );
  }
}
