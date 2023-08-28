import 'dart:developer';

import 'package:fit_wallet/features/auth/domain/domain.dart';
import 'package:fit_wallet/features/shared/infrastructure/infrastructure.dart';
import 'package:fit_wallet/features/shared/presentation/presentation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AuthStatus { authenticated, notAuthenticated, empty, checking }

class AuthState {
  final AuthStatus status;
  final JwtEntity? entity;

  AuthState({
    this.status = AuthStatus.checking,
    this.entity,
  });

  AuthState copyWith({AuthStatus? status, JwtEntity? entity}) => AuthState(
        status: status ?? this.status,
        entity: entity,
      );
}

class AuthStateNotifier extends StateNotifier<AuthState> {
  AuthStateNotifier(this._storageService) : super(AuthState()) {
    checkStatus();
  }

  final LocalStorageService _storageService;

  Future<void> checkStatus() async {
    final hasPassedWelcome = await _storageService.getValue('passedWelcome');
    if (hasPassedWelcome == null) {
      state = state.copyWith(status: AuthStatus.empty);
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
      );
    } else {
      state = state.copyWith(status: AuthStatus.notAuthenticated);
    }
  }

  Future<void> toPassedWelcome() async {
    await _storageService.setValue('passedWelcome', 'PASSED');
    state = state.copyWith(status: AuthStatus.notAuthenticated);
  }
}

final authStatusProvider = StateNotifierProvider<AuthStateNotifier, AuthState>(
  (ref) {
    final storage = ref.watch(localStorageProvider);
    return AuthStateNotifier(storage);
  },
);
