import 'package:fit_wallet/features/money_accounts/domain/entities/entities.dart';
import 'package:fit_wallet/features/money_accounts/presentation/providers/money_account_repository_db_provider.dart';
import 'package:fit_wallet/features/shared/infrastructure/inputs/inputs.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';

final firstMoneyAccountFormProvider =
    StateNotifierProvider.autoDispose.family<_FormNotifier, _FormState, String>(
  (ref, name) {
    final repo = ref.watch(moneyAccountRepositoryDbProvider);
    return _FormNotifier(
      account: null,
      name: name,
      onSubmit: repo.create,
    );
  },
);

class _FormNotifier extends StateNotifier<_FormState> {
  _FormNotifier({
    required this.onSubmit,
    required this.name,
    this.account,
  }) : super(_FormState()) {
    if (account != null) {
      state = state.copyWith(
        name: TextInput.dirty(value: account!.name),
        value: NumberInput.dirty(value: account!.amount),
        order: IntInput.dirty(value: account!.order),
      );
    } else {
      state = state.copyWith(
        name: TextInput.dirty(value: name),
        value: const NumberInput.dirty(value: 0),
      );
    }
  }

  final String name;

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

  Future<bool> submit() async {
    if (!state.name.isValid || state.name.value == '' || state.name.isPure) {
      final nameInput = TextInput.dirty(value: state.name.value.trim(), min: 2);
      state = state.copyWith(
        name: nameInput,
        isValid: Formz.validate([nameInput, state.value]),
      );
      return false;
    }

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
      return true;
    } catch (e) {
      state = state.copyWith(isPosting: false, errorMessage: e.toString());
      return false;
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
