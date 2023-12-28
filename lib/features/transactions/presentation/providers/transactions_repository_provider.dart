import 'package:fit_wallet/features/shared/presentation/providers/db_provider.dart';
import 'package:fit_wallet/features/transactions/infrastructure/datasources/transactions_datasource_db.dart';
import 'package:fit_wallet/features/transactions/infrastructure/repositories/repositories.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final transactionsRepositoryProvider = Provider((ref) {
  // final api = ref.watch(apiProvider);
  // final datasource = TransactionsDatasourceImpl(api.dio);

  final db = ref.watch(dbProvider);
  final datasource = TransactionsDatasourceDb(db.db);
  return TransactionsRepositoryImpl(datasource);
});
