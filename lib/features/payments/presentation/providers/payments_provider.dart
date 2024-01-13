import 'dart:developer';

import 'package:fit_wallet/features/payments/domain/entities/entities.dart';
import 'package:fit_wallet/features/payments/domain/repositories/repositories.dart';
import 'package:fit_wallet/features/payments/presentation/providers/payments_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final paymentsProvider =
    StateNotifierProvider.autoDispose<_StateNotifier, _State>((ref) {
  final repository = ref.watch(paymentsRepositoryProvider);
  return _StateNotifier(repository);
});

class _StateNotifier extends StateNotifier<_State> {
  _StateNotifier(this._repository) : super(_State(params: GetPaymentParams())) {
    load(GetPaymentParams(isCompleted: false));
  }

  final PaymentRepository _repository;

  void load(GetPaymentParams params) async {
    state = state.copyWith(isLoading: true, error: '', params: params);
    try {
      final payments = await _repository.getAll(params);
      state = state.copyWith(isLoading: false, payments: payments);
    } catch (e) {
      log('ERROR', error: e);
      state = state.copyWith(isLoading: false, error: 'Error loading payments');
    }
  }

  void refetch() {
    load(state.params);
  }

  Future<bool> delete(String id) async {
    try {
      await _repository.delete(id);
      load(state.params);
      return true;
    } catch (e) {
      log('ERROR delete payment', error: e);
      return false;
    }
  }
}

class _State {
  final bool isLoading;
  final List<PaymentEntity> payments;
  final String error;
  final GetPaymentParams params;

  _State({
    this.isLoading = false,
    this.payments = const [],
    this.error = '',
    required this.params,
  });

  _State copyWith({
    bool? isLoading,
    List<PaymentEntity>? payments,
    String? error,
    GetPaymentParams? params,
  }) =>
      _State(
        isLoading: isLoading ?? this.isLoading,
        payments: payments ?? this.payments,
        error: error ?? this.error,
        params: params ?? this.params,
      );

  double get total {
    if (payments.isEmpty) return 0;
    return payments
        .map((e) => e.amount)
        .reduce((value, element) => value + element);
  }
}
