import 'package:fit_wallet/features/money_accounts/domain/entities/entities.dart';
import 'package:fit_wallet/features/money_accounts/presentation/providers/money_accounts_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final moneyAccountByIdProvider =
    FutureProvider.family<MoneyAccountLastTransactionEntity, String>(
  (ref, id) {
    final repository = ref.watch(moneyAccountsRepositoryProvider);
    return repository.getById(id);
  },
);
