import 'dart:developer';

import 'package:fit_wallet/features/payments/domain/entities/entities.dart';
import 'package:fit_wallet/features/payments/domain/repositories/repositories.dart';
import 'package:fit_wallet/features/payments/presentation/providers/payments_repository_provider.dart';
import 'package:fit_wallet/features/shared/infrastructure/inputs/inputs.dart';
import 'package:fit_wallet/features/shared/infrastructure/utils/utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final paymentFormProvider =
    StateNotifierProvider.autoDispose.family<_StateNotifier, _State, String?>(
  (ref, id) {
    final repository = ref.watch(paymentsRepositoryProvider);
    return _StateNotifier(repository, id);
  },
);

class _StateNotifier extends StateNotifier<_State> {
  _StateNotifier(this._repository, this.id) : super(_State()) {
    init();
  }

  final PaymentRepository _repository;
  final String? id;

  void init() async {
    if (id == null) return;

    final payment = await _repository.getById(id!);

    state = state.copyWith(
      amount: NumberInput.dirty(value: payment.amount),
      description: TextInput.dirty(value: payment.description),
      dueDate: payment.date,
    );
  }

  void changeDescription(String value) {
    final desc = TextInput.dirty(value: value);
    state = state.copyWith(description: desc);
  }

  void changeAmount(String value) {
    final num = double.tryParse(value);
    if (num == null) return;

    final amount = NumberInput.dirty(value: num);
    state = state.copyWith(amount: amount);
  }

  void changeDueDate(DateTime? value) => state = state.copyWith(dueDate: value);

  void clearDueDate() => state = state.copyWithoutDueDate();

  Future<bool> submit() async {
    state = state.copyWith(isSaving: true);
    try {
      final payment = PaymentEntity(
        id: Utils.uuid,
        description: state.description.value,
        amount: state.amount.value,
        date: state.dueDate,
        createdAt: DateTime.now(),
      );
      await _repository.create(payment);
      return true;
    } catch (e) {
      log('ERROR save payment', error: e);
      return false;
    } finally {
      state = state.copyWith(isSaving: false);
    }
  }
}

class _State {
  final bool isSaving;
  final TextInput description;
  final NumberInput amount;
  final DateTime? dueDate;

  _State({
    this.isSaving = false,
    this.description = const TextInput.pure(),
    this.amount = const NumberInput.pure(),
    this.dueDate,
  });

  _State copyWith({
    bool? isSaving,
    TextInput? description,
    NumberInput? amount,
    DateTime? dueDate,
  }) =>
      _State(
        isSaving: isSaving ?? this.isSaving,
        description: description ?? this.description,
        amount: amount ?? this.amount,
        dueDate: dueDate ?? this.dueDate,
      );

  _State copyWithoutDueDate() => _State(
        isSaving: isSaving,
        amount: amount,
        description: description,
        dueDate: null,
      );

  String get dueDateTxt {
    if (dueDate == null) return '';
    return Utils.formatYYYDDMM(dueDate!);
  }
}
