import 'package:flutter_riverpod/flutter_riverpod.dart';

final keyboarValueProvider = StateNotifierProvider<_StateNotifier, _State>(
  (ref) => _StateNotifier(),
);

class _StateNotifier extends StateNotifier<_State> {
  _StateNotifier() : super(_State());

  void addValue(int value) {
    final arr = state.valueTxt.split('.');
    if (arr.length == 2 && arr[1].length == 4) return;

    String strValue = '';

    if (state.valueTxt == '0.00') {
      strValue = '$value';
    } else {
      strValue = '${state.valueTxt}$value';
    }

    final doubleValue = double.parse(strValue);
    state = state.copyWith(value: doubleValue, valueTxt: strValue);
    print(state.valueTxt);
    print(state.value);
  }

  void addPoint() {
    if (state.valueTxt.contains('.')) return;

    final strValue = '${state.valueTxt}.';
    state = state.copyWith(valueTxt: strValue);
  }

  void removeDigit() {
    if (state.valueTxt == '0.00') return;

    String strValue = '';
    if (state.valueTxt.length == 1) {
      strValue = '0.00';
    } else {
      strValue = state.valueTxt.substring(0, state.valueTxt.length - 1);
    }
    final value = double.parse(strValue);
    state = state.copyWith(valueTxt: strValue, value: value);
  }
}

class _State {
  final String valueTxt;
  final double value;

  _State({
    this.value = .0,
    this.valueTxt = '0.00',
  });

  _State copyWith({
    String? valueTxt,
    double? value,
  }) =>
      _State(
        value: value ?? this.value,
        valueTxt: valueTxt ?? this.valueTxt,
      );

  String? get decimalTxt {
    final value = valueTxt.split('.');
    if (value.length == 1) return null;
    return '.${value[1]}';
  }

  String? get intTxt {
    final value = valueTxt.split('.');
    return value[0];
  }
}
