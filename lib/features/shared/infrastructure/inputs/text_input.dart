import 'package:formz/formz.dart';

enum TextInputError { empty, minLength }

class TextInput extends FormzInput<String, TextInputError> {
  const TextInput.pure({this.min = 0}) : super.pure('');

  const TextInput.dirty({String value = '', this.min = 0}) : super.dirty(value);

  final int min;

  @override
  TextInputError? validator(String value) {
    if (value.isEmpty) return TextInputError.empty;
    if (value.length < min) return TextInputError.minLength;
    return null;
  }

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == TextInputError.empty) return 'Required';
    if (displayError == TextInputError.minLength) return 'Min $min characteres';

    return null;
  }
}
