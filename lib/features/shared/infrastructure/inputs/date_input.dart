import 'package:formz/formz.dart';

enum DateInputError { empty }

class DateInput extends FormzInput<DateTime?, DateInputError> {
  const DateInput.pure() : super.pure(null);

  const DateInput.dirty({DateTime? date}) : super.dirty(date);

  @override
  DateInputError? validator(DateTime? value) {
    if (value == null) return DateInputError.empty;
    return null;
  }

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == DateInputError.empty) return 'Required';

    return null;
  }
}
