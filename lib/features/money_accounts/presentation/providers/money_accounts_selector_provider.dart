import 'package:fit_wallet/features/money_accounts/presentation/providers/providers.dart';
import 'package:fit_wallet/features/transactions/presentation/providers/transaction_form_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// final moneyAccountSelectorProvider = StateProvider((ref) {
//   final accounts = ref.watch(moneyAccountsProvider).value;

//   final account = accounts?.where((account) => account.order == 0).first;

//   ref.read(transactionFormProvider.notifier).changeAccount(account!);

//   return account;
// });
