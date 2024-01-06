import 'package:fit_wallet/features/money_accounts/infrastructure/datasources/money_accounts_db_datasource.dart';
import 'package:fit_wallet/features/money_accounts/infrastructure/infrastructure.dart';
import 'package:fit_wallet/features/shared/presentation/providers/db_provider.dart';
import 'package:fit_wallet/features/transactions/presentation/providers/transactions_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final moneyAccountsRepositoryProvider = Provider((ref) {
  final db = ref.watch(dbProvider);
  // final api = ref.watch(apiProvider);
  final datasource = MoneyAccountDbDatasource(db.db);

  final transactionRepository = ref.watch(transactionsRepositoryProvider);

  return MoneyAccountRepositoryImpl(
    datasource,
    transactionsRepository: transactionRepository,
  );
});
