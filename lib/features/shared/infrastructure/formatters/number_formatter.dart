import 'package:flutter/services.dart';

class CurrencyNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll(',', '.');
    final hasManyPoints = text.indexOf('.') != text.lastIndexOf('.');

    if (hasManyPoints) {
      return oldValue;
    }

    return newValue;
  }
}
