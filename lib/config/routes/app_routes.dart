import 'package:fit_wallet/features/auth/presentation/presentation.dart';
import 'package:fit_wallet/features/welcome/presentation/presentation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final routerProvider = Provider(
  (ref) => GoRouter(
    initialLocation: '/welcome',
    routes: [
      GoRoute(path: '/welcome', builder: (_, __) => const WelcomeScreen()),
      GoRoute(path: '/login', builder: (_, __) => const AuthScreen())
    ],
    // redirect: (context, state) {
    //   // if (state.path?.contains('login') ?? true) return '/login';
    //   return '/welcome';
    // },
  ),
);
