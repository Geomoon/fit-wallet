import 'package:formz/formz.dart';

enum IntInputError { badFormat, empty }

class IntInput extends FormzInput<int?, IntInputError> {
  const IntInput.pure() : super.pure(null);

  const IntInput.dirty({int value = 0}) : super.dirty(value);

  @override
  IntInputError? validator(int? value) {
    return null;
  }

  String? get errorMessage {
    if (isValid || isPure) return null;

    return null;
  }
}
