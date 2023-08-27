import 'package:fit_wallet/config/routes/routes.dart';
import 'package:fit_wallet/config/themes/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) => MaterialApp.router(
        title: 'FitWallet',
        theme: ref.watch(lightTheme),
        darkTheme: DarkTheme.theme,
        themeMode: ref.watch(themeMode),
        routerConfig: ref.watch(routerProvider),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
