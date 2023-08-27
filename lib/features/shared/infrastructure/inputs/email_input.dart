import 'package:formz/formz.dart';

enum EmailInputError { badFormat, empty }

class EmailInput extends FormzInput<String, EmailInputError> {
  const EmailInput.pure() : super.pure('');

  const EmailInput.dirty({String value = ''}) : super.dirty(value);

  @override
  EmailInputError? validator(String value) {
    if (value.isEmpty) return EmailInputError.empty;

    final RegExp regex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$');
    if (!regex.hasMatch(value)) return EmailInputError.badFormat;

    return null;
  }

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == EmailInputError.empty) return 'Required';
    if (displayError == EmailInputError.badFormat) return 'Bad format';

    return null;
  }
}
