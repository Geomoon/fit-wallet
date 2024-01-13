import 'dart:developer';

import 'package:fit_wallet/features/money_accounts/domain/entities/entities.dart';
import 'package:fit_wallet/features/payments/domain/entities/entities.dart';
import 'package:fit_wallet/features/payments/domain/repositories/repositories.dart';
import 'package:fit_wallet/features/payments/presentation/providers/payments_repository_provider.dart';
import 'package:fit_wallet/features/shared/infrastructure/inputs/inputs.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final paymentsPayFormProvider =
    StateNotifierProvider.autoDispose.family<_StateNotifier, _State, String>(
  (ref, id) {
    final repository = ref.watch(paymentsRepositoryProvider);
    return _StateNotifier(id: id, paymentRepository: repository);
  },
);

class _StateNotifier extends StateNotifier<_State> {
  _StateNotifier({
    required String id,
    required this.paymentRepository,
  }) : super(_State()) {
    loadPayment(id);
  }

  final PaymentRepository paymentRepository;

  void loadPayment(String id) async {
    final payment = await paymentRepository.getById(id);
    state = state.copyWith(payment: payment);
  }

  void changeAccount(MoneyAccountLastTransactionEntity account) {
    state = state.copyWithAccount(account: account);
  }

  void changeValue(String value) {
    double? amount = double.tryParse(value);

    amount ??= 0;

    bool isCompleted = false;
    if (amount >= state.payment!.amount) isCompleted = true;
    state = state.copyWith(
      value: NumberInput.dirty(value: amount),
      payment: state.payment!
        ..isCompleted = isCompleted
        ..amountPaid = amount,
    );
  }

  Future<bool> save() async {
    try {
      final payment = state.payment;

      if (state.account != null) {
        payment!.account = MoneyAccountEntity(
          id: state.account!.id,
          name: state.account!.name,
          amount: state.account!.amount,
        );
      }

      payment!.amountPaid = state.value.value;
      if (state.value.isPure) {
        payment.amountPaid = state.payment!.pendingAmount;
      }

      await paymentRepository.update(payment);
      return true;
    } catch (e) {
      log('ERROR saving payment', error: e);
      return false;
    }
  }
}

class _State {
  final bool isSaving;
  final bool isValid;
  final MoneyAccountLastTransactionEntity? account;
  final NumberInput value;
  final PaymentEntity? payment;

  _State({
    this.payment,
    this.isSaving = false,
    this.isValid = false,
    this.account,
    this.value = const NumberInput.pure(),
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
