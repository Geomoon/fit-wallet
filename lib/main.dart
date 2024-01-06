import 'package:fit_wallet/config/env/env.dart';
import 'package:fit_wallet/config/routes/routes.dart';
import 'package:fit_wallet/config/themes/themes.dart';
import 'package:fit_wallet/features/shared/infrastructure/datasources/sqlite_datasource.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  await Env.init();
  WidgetsFlutterBinding.ensureInitialized();
  await SQLiteDatasource.initDB();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final themeMode = ref.watch(themeModeProvider);
        return MaterialApp.router(
          title: 'FitWallet',
          theme: LightTheme.theme,
          darkTheme: DarkTheme.theme,
          themeMode: themeMode,
          routerConfig: ref.watch(routerProvider),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
