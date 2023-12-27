import 'package:fit_wallet/features/money_accounts/infrastructure/datasources/money_accounts_db_datasource.dart';
import 'package:fit_wallet/features/money_accounts/infrastructure/repositories/money_account_repository_impl.dart';
import 'package:fit_wallet/features/shared/presentation/providers/db_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final moneyAccountRepositoryDbProvider = Provider((ref) {
  final db = ref.watch(dbProvider);
  final datasource = MoneyAccountDbDatasource(db.db);
  return MoneyAccountRepositoryImpl(datasource);
});
