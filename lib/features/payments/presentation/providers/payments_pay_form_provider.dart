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
    state = state.copyWith(
      payment: payment,
      value: NumberInput.dirty(value: payment.pendingAmount),
    );
  }

  void changeAccount(MoneyAccountLastTransactionEntity? account) {
    final noFunds = state.value.value > (account?.amount ?? 0);
    state = state.copyWith(account: account, noFunds: noFunds);
  }

  void changePaymentType(int value) {
    state = state.copyWith(
      paymentType: value,
      account: state.account,
    );
  }

  void changeValue(String value) {
    double? amount = double.tryParse(value);
    amount ??= 0;

    state = state.copyWith(
      value: NumberInput.dirty(value: amount),
      account: state.account,
      payment: state.payment,
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

      payment!.amountPaid = state.value.value + payment.amountPaid;

      await paymentRepository.pay(payment, state.value.value);
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
  final bool noFunds;

  /// 0 => ALL, 1 => INSTALLMENTS
  final int paymentType;

  _State({
    this.payment,
    this.isSaving = false,
    this.isValid = false,
    this.account,
    this.value = const NumberInput.pure(),
    this.paymentType = 0,
    this.noFunds = false,
  });

  _State copyWith({
    bool? isSaving,
    bool? isValid,
    NumberInput? value,
    PaymentEntity? payment,
    int? paymentType,
    MoneyAccountLastTransactionEntity? account,
    bool? noFunds,
  }) =>
      _State(
        payment: payment ?? this.payment,
        isSaving: isSaving ?? this.isSaving,
        isValid: isValid ?? this.isValid,
        value: value ?? this.value,
        paymentType: paymentType ?? this.paymentType,
        account: account,
        noFunds: noFunds ?? this.noFunds,
      );
}
