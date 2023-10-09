import 'package:fit_wallet/features/money_accounts/presentation/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final moneyAccountSelectorProvider = StateProvider((ref) {
  final accounts = ref.watch(moneyAccountsProvider).value;

  return accounts?.where((account) => account.order == 0).first;
});
