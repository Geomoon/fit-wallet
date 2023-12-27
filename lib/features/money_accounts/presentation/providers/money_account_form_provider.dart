import 'package:fit_wallet/features/money_accounts/domain/entities/entities.dart';
import 'package:fit_wallet/features/money_accounts/presentation/providers/money_account_repository_db_provider.dart';
import 'package:fit_wallet/features/money_accounts/presentation/providers/providers.dart';
import 'package:fit_wallet/features/shared/infrastructure/inputs/inputs.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';

final moneyAccountFormProvider = StateNotifierProvider.autoDispose
    .family<_FormNotifier, _FormState, String?>(
  (ref, id) {
    // final repo = ref.watch(moneyAccountsRepositoryProvider);
    final repo = ref.watch(moneyAccountRepositoryDbProvider);
    if (id != null) {
      // final account = ref.watch(moneyAccountByIdProvider(id)).asData?.value;

      final account = ref
          .watch(moneyAccountsProvider)
          .value
          ?.where((element) => element.id == id)
          .first;
      return _FormNotifier(
        account: account,
        onSubmit: (entity) => repo.update(id, entity),
      );
    }
    return _FormNotifier(onSubmit: repo.create);
  },
);

class _FormNotifier extends StateNotifier<_FormState> {
  _FormNotifier({
    required this.onSubmit,
    this.account,
  }) : super(_FormState()) {
    if (account != null) {
      state = state.copyWith(
        name: TextInput.dirty(value: account!.name),
        value: NumberInput.dirty(value: account!.amount),
        order: IntInput.dirty(value: account!.order),
      );
    }
  }

  final Future<void> Function(CreateMoneyAccountEntity) onSubmit;
  final MoneyAccountLastTransactionEntity? account;

  void onNameChange(String value) {
    state = state.copyWith(name: TextInput.dirty(value: value.trim(), min: 2));
  }

  void onValueChange(String value) {
    final parsedValue = double.tryParse(value.trim());

    if (parsedValue != null) {
      state = state.copyWith(value: NumberInput.dirty(value: parsedValue));
    }
  }

  void onOrderChange(int? order) {
    state = state.copyWith(order: IntInput.dirty(value: order ?? 1));
  }

  Future<void> submit() async {
    state = state.copyWith(
      isValid: Formz.validate([state.name, state.value]),
      isPosted: true,
      isPosting: true,
    );

    try {
      final account = CreateMoneyAccountEntity(
        name: state.name.value,
        value: state.value.value,
        order: state.order.value ?? 1,
      );
      await onSubmit(account);
      state = state.copyWith(isPosting: false);
    } catch (e) {
      state = state.copyWith(isPosting: false, errorMessage: e.toString());
    }
  }
}

class _FormState {
  final bool isValid;
  final bool isPosted;
  final bool isPosting;
  final TextInput name;
  final NumberInput value;
  final IntInput order;
  final String errorMessage;

  _FormState({
    this.isValid = false,
    this.isPosted = false,
    this.isPosting = false,
    this.name = const TextInput.pure(min: 2),
    this.value = const NumberInput.pure(),
    this.order = const IntInput.pure(),
    this.errorMessage = '',
  });

  _FormState copyWith({
    bool? isValid,
    bool? isPosted,
    bool? isPosting,
    TextInput? name,
    NumberInput? value,
    String? errorMessage,
    IntInput? order,
  }) =>
      _FormState(
        isValid: isValid ?? this.isValid,
        isPosted: isPosted ?? this.isPosted,
        isPosting: isPosting ?? this.isPosting,
        name: name ?? this.name,
        value: value ?? this.value,
        errorMessage: errorMessage ?? this.errorMessage,
        order: order ?? this.order,
      );
}
