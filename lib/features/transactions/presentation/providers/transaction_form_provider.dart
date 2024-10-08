import 'package:fit_wallet/features/money_accounts/domain/entities/entities.dart';
import 'package:fit_wallet/features/money_accounts/presentation/providers/money_accounts_get_all_provider.dart';
import 'package:fit_wallet/features/shared/domain/domain.dart';
import 'package:fit_wallet/features/shared/infrastructure/inputs/number_input.dart';
import 'package:fit_wallet/features/shared/infrastructure/utils/utils.dart';
import 'package:fit_wallet/features/transactions/domain/domain.dart';
import 'package:fit_wallet/features/transactions/presentation/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final transactionFormProvider =
    StateNotifierProvider.autoDispose<_StateNotifier, _State>(
  (ref) {
    final repository = ref.watch(transactionsRepositoryProvider);
    final accounts = ref.watch(moneyAccountsProvider).value;
    final account = accounts?.first;

    return _StateNotifier(repository: repository, account: account!);
  },
);

class _StateNotifier extends StateNotifier<_State> {
  _StateNotifier({
    required this.repository,
    required MoneyAccountLastTransactionEntity account,
  }) : super(_State(account: account, maccId: account.id)) {
    _validateAmount();
  }

  final TransactionsRepository repository;

  void changeAmount(double value) {
    state = state.copyWith(
        amount: NumberInput.dirty(value: value), accountTo: state.accountTo);
    _validateAmount();
  }

  void changeMaccId(String id) {
    state = state.copyWith(maccId: id, accountTo: state.accountTo);
  }

  void changeAccount(MoneyAccountLastTransactionEntity account) {
    state = state.copyWith(
        account: account, maccId: account.id, accountTo: state.accountTo);
    _validateAmount();
  }

  void changeAccountTo(MoneyAccountLastTransactionEntity account) {
    state = state.copyWith(accountTo: account, maccIdTransfer: account.id);
    _validateAmount();
  }

  void changeCateId(String id) {
    state = state.copyWith(cateId: id, accountTo: state.accountTo);
  }

  void changeDescription(String value) {
    state = state.copyWith(description: value, accountTo: state.accountTo);
  }

  void changeType(TransactionType type) {
    state = state.copyWith(type: type, accountTo: null);
    _validateAmount();
  }

  void changeDebtId(String id) {
    state = state.copyWith(debtId: id, accountTo: state.accountTo);
  }

  void clearErrors() {
    state = state.copyWith(error: '', accountTo: state.accountTo);
  }

  void _validateAmount() {
    double diff = 0;

    if (state.type == TransactionType.income) {
      diff = state.account!.amount + state.amount.value;
    } else {
      diff = state.account!.amount - state.amount.value;
    }

    bool? error;

    if (diff <= 0) error = true;
    if (diff > state.account!.amount) error = false;

    state = state.copyWith(
      balanceError: error,
      accountDiffAmount: diff,
      accountTo: state.accountTo,
    );
  }

  Future<bool> onSubmit() async {
    state = state.copyWith(isLoading: true, accountTo: state.accountTo);

    if (state.amount.value == 0) {
      state = state.copyWith(
          error: 'Enter a value', isLoading: false, accountTo: state.accountTo);
      return false;
    }

    final transaction = CreateTransactionEntity(
      amount: state.amount.value,
      type: state.type,
      maccId: state.maccId,
      cateId: state.cateId,
      paymId: state.debtId,
      description: state.description,
      maccIdTransfer: state.maccIdTransfer,
    );

    try {
      await repository.create(transaction);
    } catch (e) {
      state = state.copyWith(
          error: e.toString(), isLoading: false, accountTo: state.accountTo);
      return false;
    }

    state = state.copyWith(isLoading: false, accountTo: state.accountTo);

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

  final double accountDiffAmount;

  final MoneyAccountLastTransactionEntity? account;
  final MoneyAccountLastTransactionEntity? accountTo;

  final String error;
  final bool isLoading;
  final bool? balanceError;

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
    this.balanceError,
    this.account,
    this.accountDiffAmount = 0,
    this.accountTo,
  });

  String get diffAmountTxt => Utils.currencyFormat(accountDiffAmount);

  String get descriptionTxt {
    if (description != null && description!.isNotEmpty) {
      if (description!.length > 20) {
        return '${description!.substring(0, 20)}...';
      }

      return description!;
    }

    return '';
  }

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
    bool? balanceError,
    MoneyAccountLastTransactionEntity? account,
    double? accountDiffAmount,
    MoneyAccountLastTransactionEntity? accountTo,
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
        balanceError: balanceError,
        account: account ?? this.account,
        accountDiffAmount: accountDiffAmount ?? this.accountDiffAmount,
        accountTo: accountTo,
      );
}
