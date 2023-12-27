import 'package:fit_wallet/features/money_accounts/presentation/providers/money_account_repository_db_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final moneyAccountsProvider = FutureProvider((ref) {
  // final repo = ref.watch(moneyAccountsRepositoryProvider);
  final repo = ref.watch(moneyAccountRepositoryDbProvider);

  return repo.getAll();
});
