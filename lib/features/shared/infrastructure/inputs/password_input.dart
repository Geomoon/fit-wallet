import 'package:formz/formz.dart';

enum PasswordInputError { empty, minLength }

class PasswordInput extends FormzInput<String, PasswordInputError> {
  const PasswordInput.pure() : super.pure('');

  const PasswordInput.dirty({String value = ''}) : super.dirty(value);

  @override
  PasswordInputError? validator(String value) {
    if (value.isEmpty) return PasswordInputError.empty;

    if (value.length < 6) return PasswordInputError.minLength;

    return null;
  }

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == PasswordInputError.empty) return 'Required';
    if (displayError == PasswordInputError.minLength) {
      return 'Min 6 characteres';
    }

    return null;
  }
}
