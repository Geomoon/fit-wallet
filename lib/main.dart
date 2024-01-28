import 'package:fit_wallet/config/env/env.dart';
import 'package:fit_wallet/config/routes/routes.dart';
import 'package:fit_wallet/config/themes/themes.dart';
import 'package:fit_wallet/features/shared/infrastructure/datasources/sqlite_datasource.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  await Env.init();
  WidgetsFlutterBinding.ensureInitialized();
  await SQLiteDatasource.initDB();
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle.light.copyWith(
      systemNavigationBarColor: LightTheme.barColor,
    ),
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;

    if (isDark) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle.dark.copyWith(
          systemNavigationBarColor: const Color(0xff1e1e21),
        ),
      );
    } else {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle.light.copyWith(
          systemNavigationBarColor: LightTheme.barColor,
        ),
      );
    }
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return Consumer(
      builder: (context, ref, _) {
        return MaterialApp.router(
          title: 'FitWallet',
          darkTheme: DarkTheme.theme,
          theme: LightTheme.theme,
          themeMode: ThemeMode.system,
          routerConfig: ref.watch(routerProvider),
          debugShowCheckedModeBanner: false,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        );
      },
    );
  }
}
