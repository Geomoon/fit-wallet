import 'dart:developer';

import 'package:fit_wallet/features/auth/domain/domain.dart';
import 'package:fit_wallet/features/shared/infrastructure/infrastructure.dart';
import 'package:fit_wallet/features/shared/presentation/presentation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AuthStatus { authenticated, notAuthenticated, empty, checking }

class AuthState {
  final AuthStatus status;
  final JwtEntity? entity;
  final String route;

  AuthState({
    this.status = AuthStatus.checking,
    this.entity,
    this.route = '/loading',
  });

  AuthState copyWith({
    AuthStatus? status,
    JwtEntity? entity,
    String? route,
  }) =>
      AuthState(
        status: status ?? this.status,
        entity: entity,
        route: route ?? this.route,
      );
}

class AuthStateNotifier extends StateNotifier<AuthState> {
  AuthStateNotifier(this._storageService, this._ref) : super(AuthState()) {
    checkStatus();
  }

  final LocalStorageService _storageService;

  final StateNotifierProviderRef<AuthStateNotifier, AuthState> _ref;

  Future<void> checkStatus() async {
    final hasPassedWelcome = await _storageService.getValue('passedWelcome');
    if (hasPassedWelcome == null) {
      _ref.invalidate(apiProvider);
      print('INVALIDATED API');

      state = state.copyWith(status: AuthStatus.empty, route: '/welcome');
      return;
    }

    final token = await _storageService.getValue('accessToken');

    if (token != null && token != '') {
      final decodedJwt = Utils.parseJwt(token);
      final jwToken = JwtEntity.fromJson(decodedJwt);

      log('JWT: ${jwToken.toJson()}');

      state = state.copyWith(
        status: AuthStatus.authenticated,
        entity: jwToken,
        route: '/',
      );
    } else {
      state = state.copyWith(
        status: AuthStatus.notAuthenticated,
        route: '/login',
      );
    }
    _ref.invalidate(apiProvider);
    print('INVALIDATED API');
  }

  Future<void> toPassedWelcome() async {
    await _storageService.setValue('passedWelcome', 'PASSED');
    state =
        state.copyWith(status: AuthStatus.notAuthenticated, route: '/login');
  }

  Future<void> setRoute(String route) async {
    state = state.copyWith(route: route);
  }

  Future<void> logout() async {
    await _storageService.delete('accessToken');
    await _storageService.delete('refreshToken');
    state = state.copyWith(
      status: AuthStatus.notAuthenticated,
      route: '/login',
    );
  }
}

final authStatusProvider = StateNotifierProvider<AuthStateNotifier, AuthState>(
  (ref) {
    final storage = ref.watch(localStorageProvider);
    return AuthStateNotifier(storage, ref);
  },
);
