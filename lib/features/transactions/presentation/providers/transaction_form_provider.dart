import 'package:fit_wallet/features/shared/domain/domain.dart';
import 'package:fit_wallet/features/shared/infrastructure/inputs/number_input.dart';
import 'package:fit_wallet/features/transactions/domain/domain.dart';
import 'package:fit_wallet/features/transactions/presentation/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final transactionFormProvider =
    StateNotifierProvider.autoDispose<_StateNotifier, _State>((ref) {
  final repository = ref.watch(transactionsRepositoryProvider);

  return _StateNotifier(repository: repository);
});

class _StateNotifier extends StateNotifier<_State> {
  _StateNotifier({required this.repository}) : super(_State());

  final TransactionsRepository repository;

  void changeAmount(double value) {
    state = state.copyWith(amount: NumberInput.dirty(value: value));
  }

  void changeMaccId(String id) {
    state = state.copyWith(maccId: id);
  }

  void changeCateId(String id) {
    state = state.copyWith(cateId: id);
  }

  void changeDescription(String value) {
    state = state.copyWith(description: value);
  }

  void changeType(TransactionType type) {
    state = state.copyWith(type: type);
  }

  void changeMaccIdTransfer(String id) {
    state = state.copyWith(maccIdTransfer: id);
  }

  void changeDebtId(String id) {
    state = state.copyWith(debtId: id);
  }

  void clearErrors() {
    state = state.copyWith(error: '');
  }

  Future<bool> onSubmit() async {
    state = state.copyWith(isLoading: true);

    if (state.amount.value == 0) {
      state = state.copyWith(error: 'Enter a value', isLoading: false);
      return false;
    }

    final transaction = CreateTransactionEntity(
      amount: state.amount.value,
      type: state.type,
      maccId: state.maccId,
      cateId: state.cateId,
      debtId: state.debtId,
      description: state.description,
      maccIdTransfer: state.maccIdTransfer,
    );

    try {
      await repository.create(transaction);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
      return false;
    }

    state = state.copyWith(isLoading: false);

    return true;
  }
}

final class _State {
  final String? description;
  final NumberInput amount;
  final TransactionType type;
  final String maccId;
  final String cateId;
  final String? debtId;
  final String? maccIdTransfer;

  final String error;
  final bool isLoading;

  _State({
    this.description,
    this.amount = const NumberInput.pure(),
    this.type = TransactionType.expense,
    this.maccId = '',
    this.cateId = '',
    this.debtId,
    this.maccIdTransfer,
    this.error = '',
    this.isLoading = false,
  });

  _State copyWith({
    String? description,
    NumberInput? amount,
    TransactionType? type,
    String? maccId,
    String? cateId,
    String? debtId,
    String? maccIdTransfer,
    String? error,
    bool? isLoading,
  }) =>
      _State(
        description: description ?? this.description,
        amount: amount ?? this.amount,
        type: type ?? this.type,
        maccId: maccId ?? this.maccId,
        cateId: cateId ?? this.cateId,
        debtId: debtId ?? this.debtId,
        maccIdTransfer: maccIdTransfer ?? this.maccIdTransfer,
        error: error ?? this.error,
        isLoading: isLoading ?? this.isLoading,
      );
}
