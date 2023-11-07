// final moneyAccountSelectorProvider = StateProvider((ref) {
//   final accounts = ref.watch(moneyAccountsProvider).value;

//   final account = accounts?.where((account) => account.order == 0).first;

//   ref.read(transactionFormProvider.notifier).changeAccount(account!);

//   return account;
// });
