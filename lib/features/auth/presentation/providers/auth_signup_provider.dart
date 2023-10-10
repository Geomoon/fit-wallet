import 'package:fit_wallet/features/auth/domain/domain.dart';
import 'package:fit_wallet/features/auth/presentation/providers/auth_repository_provider.dart';
import 'package:fit_wallet/features/auth/presentation/providers/auth_state_provider.dart';
import 'package:fit_wallet/features/shared/infrastructure/exceptions/server_exception.dart';
import 'package:fit_wallet/features/shared/infrastructure/inputs/inputs.dart';
import 'package:fit_wallet/features/shared/infrastructure/utils/utils.dart';
import 'package:fit_wallet/features/shared/presentation/presentation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';

final signupProvider = StateNotifierProvider<_StateNotifier, _State>((ref) {
  final authRepo = ref.watch(authRepositoryProvider);
  final storage = ref.watch(localStorageProvider);
  return _StateNotifier(authRepo, storage, ref);
});

class _StateNotifier extends StateNotifier<_State> {
  _StateNotifier(
    this._authRepository,
    this._storage,
    this.ref,
  ) : super(_State());

  final AuthRepository _authRepository;
  final LocalStorageService _storage;

  final dynamic ref;

  void onChangeUsername(String value) {
    bool? isValid;
    final input = TextInput.dirty(value: value, min: 2);

    if (state.isPosted) {
      isValid = Formz.validate([input]);
      state = state.copyWith(username: input, isValid: isValid);
      return;
    }

    state = state.copyWith(username: input);
  }

  void onChangePassword(String value) {
    state = state.copyWith(password: PasswordInput.dirty(value: value));
  }

  void onChangeEmail(String email) {
    state = state.copyWith(email: EmailInput.dirty(value: email));
  }

  void onChangeBirthdate(DateTime date) {
    state = state.copyWith(birthdate: DateInput.dirty(date: date));
  }

  void _touchInputs() {
    final username = TextInput.dirty(value: state.username.value);
    final email = EmailInput.dirty(value: state.email.value);
    final password = PasswordInput.dirty(value: state.password.value);
    final birthdate = DateInput.dirty(date: state.birthdate.value);

    state = state.copyWith(
      username: username,
      email: email,
      password: password,
      birthdate: birthdate,
    );
  }

  Future<void> onSubmit() async {
    try {
      _touchInputs();

      final isValid = Formz.validate([
        state.username,
        state.email,
        state.password,
        state.birthdate,
      ]);

      state = state.copyWith(isValid: isValid, isPosting: true, isPosted: true);

      if (!isValid) {
        state = state.copyWith(
          isValid: isValid,
          isPosting: false,
          isPosted: true,
        );
        return;
      }

      final request = SignUpEntity(
        username: state.username.value,
        email: state.email.value,
        password: state.password.value,
        birthdate: state.birthdate.value!,
      );

      final response = await _authRepository.signUp(request);

      await _storage.setValue('accessToken', response.accessToken);
      await _storage.setValue('refreshToken', response.refreshToken);
      state = state.copyWith(error: '', isPosting: false);
      await ref.read(authStatusProvider.notifier).checkStatus();

      state = state.copyWith(isPosting: false);
    } on ServerException {
      state = state.copyWith(error: 'Network Error', isPosting: false);
    } catch (e) {
      state = state.copyWith(error: 'Error', isPosting: false);
    }
  }
}

class _State {
  final String error;
  final bool isValid;
  final bool isPosting;
  final bool isPosted;
  final EmailInput email;
  final PasswordInput password;
  final TextInput username;
  final DateInput birthdate;

  _State({
    this.error = '',
    this.isValid = false,
    this.isPosting = false,
    this.isPosted = false,
    this.email = const EmailInput.pure(),
    this.password = const PasswordInput.pure(),
    this.username = const TextInput.pure(min: 3),
    this.birthdate = const DateInput.pure(),
  });

  _State copyWith({
    String? error,
    bool? isValid,
    bool? isPosting,
    bool? isPosted,
    EmailInput? email,
    PasswordInput? password,
    TextInput? username,
    DateInput? birthdate,
  }) =>
      _State(
        error: error ?? this.error,
        isValid: isValid ?? this.isValid,
        isPosting: isPosting ?? this.isPosting,
        isPosted: isPosted ?? this.isPosted,
        email: email ?? this.email,
        password: password ?? this.password,
        username: username ?? this.username,
        birthdate: birthdate ?? this.birthdate,
      );

  String get birthdateTxt {
    if (birthdate.value != null) {
      return Utils.formatYYYYMMDD(birthdate.value!);
    }
    return '';
  }
}
