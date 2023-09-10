import 'package:formz/formz.dart';

enum NumberInputError { badFormat, empty }

class NumberInput extends FormzInput<double, NumberInputError> {
  const NumberInput.pure() : super.pure(0);

  const NumberInput.dirty({double value = 0}) : super.dirty(value);

  @override
  NumberInputError? validator(double value) {
    return null;
  }

  String? get errorMessage {
    if (isValid || isPure) return null;

    return null;
  }
}
