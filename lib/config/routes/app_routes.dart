import 'dart:developer';

import 'package:fit_wallet/features/auth/presentation/presentation.dart';
import 'package:fit_wallet/features/auth/presentation/providers/providers.dart';
import 'package:fit_wallet/features/debts/presentation/screens/screens.dart';
import 'package:fit_wallet/features/home/presentation/presentation.dart';
import 'package:fit_wallet/features/money_accounts/presentation/presentation.dart';
import 'package:fit_wallet/features/transactions/presentation/presentation.dart';
import 'package:fit_wallet/features/welcome/presentation/presentation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final routerProvider = Provider((ref) {
  final authStatus = ref.watch(authStatusProvider);
  log('${authStatus.status}');

  return GoRouter(
    initialLocation: authStatus.route,
    routes: [
      GoRoute(path: '/loading', builder: (_, __) => const LoadingScreen()),
      GoRoute(path: '/welcome', builder: (_, __) => const WelcomeScreen()),
      GoRoute(path: '/login', builder: (_, __) => const AuthScreen()),
      GoRoute(path: '/signup', builder: (_, __) => const SignupScreen()),
      GoRoute(
        path: '/',
        builder: (_, __) => const HomeScreen(),
      ),
      GoRoute(
        path: '/money-accounts',
        builder: (_, __) => const MoneyAccountsScreen(),
      ),
      GoRoute(
        path: '/money-accounts/:id',
        builder: (_, state) {
          final maccId = state.pathParameters['id'];

          return MoneyAccountsDetailScreen(maccId: maccId!);
        },
      ),
      GoRoute(
        path: '/debts',
        builder: (_, __) => const DebtsScreen(),
      ),
      GoRoute(
        path: '/transactions',
        builder: (_, __) => const TransactionsScreen(),
      ),
      GoRoute(
        path: '/transactions/form',
        builder: (context, state) => const TransactionFormScreen(),
      ),
    ],
    redirect: (context, state) {
      if (authStatus.status == AuthStatus.notAuthenticated) {
        if (authStatus.route == '/' || authStatus.route == '/login')
          return null;
        return authStatus.route;
      }
      return null;
    },
  );
});
