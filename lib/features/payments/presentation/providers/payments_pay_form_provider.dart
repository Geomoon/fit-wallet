import 'package:fit_wallet/features/money_accounts/domain/entities/entities.dart';
import 'package:fit_wallet/features/payments/domain/entities/entities.dart';
import 'package:fit_wallet/features/shared/infrastructure/inputs/inputs.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class _StateNotifier extends StateNotifier<_State> {
  _StateNotifier(PaymentEntity payment) : super(_State(payment: payment));

  void changeAccount(MoneyAccountLastTransactionEntity account) {
    state = state.copyWithAccount(account: account);
  }

  void changeValue(String value) {
    final amount = double.parse(value);
    state = state.copyWith(value: NumberInput.dirty(value: amount));
  }

  void save() async {
    try {} catch (e) {}
  }
}

class _State {
  final bool isSaving;
  final bool isValid;
  final MoneyAccountLastTransactionEntity? account;
  final NumberInput value;
  final PaymentEntity payment;

  _State({
    required this.payment,
    this.isSaving = false,
    this.isValid = false,
    this.account,
    this.value = const NumberInput.dirty(),
  });

  _State copyWith({
    bool? isSaving,
    bool? isValid,
    NumberInput? value,
    PaymentEntity? payment,
  }) =>
      _State(
        payment: payment ?? this.payment,
        isSaving: isSaving ?? this.isSaving,
        isValid: isValid ?? this.isValid,
        value: value ?? this.value,
      );

  _State copyWithAccount({MoneyAccountLastTransactionEntity? account}) =>
      _State(payment: payment, account: account);
}
