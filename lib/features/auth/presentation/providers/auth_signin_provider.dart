import 'package:fit_wallet/features/auth/domain/domain.dart';
import 'package:fit_wallet/features/auth/presentation/providers/auth_repository_provider.dart';
import 'package:fit_wallet/features/auth/presentation/providers/providers.dart';
import 'package:fit_wallet/features/shared/infrastructure/infrastructure.dart';
import 'package:fit_wallet/features/shared/presentation/presentation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authSignInProvider =
    StateNotifierProvider<AuthSignInNotifier, AuthSignInState>((ref) {
  final authRepo = ref.watch(authRepositoryProvider);
  final storage = ref.watch(localStorageProvider);

  return AuthSignInNotifier(authRepo, storage, ref);
});

class AuthSignInNotifier extends StateNotifier<AuthSignInState> {
  AuthSignInNotifier(this._authRepository, this._storage, this.ref)
      : super(AuthSignInState());

  final AuthRepository _authRepository;
  final LocalStorageService _storage;
  final dynamic ref;

  void onChangeEmail(String email) {
    state = state.copyWith(email: EmailInput.dirty(value: email));
  }

  void onChangePassword(String password) {
    state = state.copyWith(password: PasswordInput.dirty(value: password));
  }

  Future<void> onSubmit() async {
    try {
      if (state.email.value == '' || state.password.value == '') {
        return;
      }

      state = state.copyWith(
          isPosting: true, isPosted: true, isValid: true, error: '');

      final request = SignInEntity(
        email: state.email.value,
        password: state.password.value,
      );
      final response = await _authRepository.signIn(request);

      await _storage.setValue('accessToken', response.accessToken);
      await _storage.setValue('refreshToken', response.refreshToken);
      state = state.copyWith(error: '', isPosting: false);
      await ref.read(authStatusProvider.notifier).checkStatus();
    } on AppException catch (e) {
      state = state.copyWith(error: e.message, isPosting: false);
    } catch (e) {
      state = state.copyWith(error: 'Error', isPosting: false);
    }
  }
}

class AuthSignInState {
  final String error;
  final bool isValid;
  final bool isPosting;
  final bool isPosted;
  final EmailInput email;
  final PasswordInput password;

  AuthSignInState({
    this.error = '',
    this.isValid = false,
    this.isPosting = false,
    this.isPosted = false,
    this.email = const EmailInput.pure(),
    this.password = const PasswordInput.pure(),
  });

  AuthSignInState copyWith({
    String? error,
    bool? isValid,
    bool? isPosting,
    bool? isPosted,
    EmailInput? email,
    PasswordInput? password,
  }) =>
      AuthSignInState(
        error: error ?? this.error,
        isValid: isValid ?? this.isValid,
        isPosting: isPosting ?? this.isPosting,
        isPosted: isPosted ?? this.isPosted,
        email: email ?? this.email,
        password: password ?? this.password,
      );
}
