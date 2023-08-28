import 'dart:developer';

import 'package:fit_wallet/features/auth/presentation/presentation.dart';
import 'package:fit_wallet/features/auth/presentation/providers/providers.dart';
import 'package:fit_wallet/features/home/presentation/presentation.dart';
import 'package:fit_wallet/features/welcome/presentation/presentation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final routerProvider = Provider((ref) {
  return GoRouter(
    initialLocation: '/loading',
    routes: [
      GoRoute(path: '/loading', builder: (_, __) => const LoadingScreen()),
      GoRoute(path: '/welcome', builder: (_, __) => const WelcomeScreen()),
      GoRoute(path: '/login', builder: (_, __) => const AuthScreen()),
      GoRoute(path: '/signup', builder: (_, __) => const SignupScreen()),
      GoRoute(path: '/', builder: (_, __) => const HomeScreen()),
    ],
    redirect: (context, state) async {
      final authStatus = ref.watch(authStatusProvider);

      log('${authStatus.status}');

      if (authStatus.status == AuthStatus.checking) {
        return '/loading';
      }

      if (authStatus.status == AuthStatus.empty) {
        return '/welcome';
      }

      if (authStatus.status == AuthStatus.notAuthenticated) {
        return '/login';
      }

      if (authStatus.status == AuthStatus.authenticated) {
        return '/';
      }

      return state.path;
    },
  );
});
