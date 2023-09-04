import 'package:fit_wallet/features/money_accounts/presentation/providers/money_accounts_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final moneyAccountsProvider = FutureProvider((ref) {
  final repo = ref.watch(moneyAccountsRepositoryProvider);
  return repo.getAll();
});
