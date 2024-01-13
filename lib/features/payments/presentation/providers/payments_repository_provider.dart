import 'package:fit_wallet/features/payments/infrastructure/datasources/datasources.dart';
import 'package:fit_wallet/features/payments/infrastructure/repositories/repositories.dart';
import 'package:fit_wallet/features/shared/presentation/providers/db_provider.dart';
import 'package:fit_wallet/features/transactions/presentation/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final paymentsRepositoryProvider = Provider((ref) {
  final db = ref.watch(dbProvider);
  final datasource = PaymentDatasourceDb(db.db);

  final transactionsRepository = ref.watch(transactionsRepositoryProvider);

  return PaymentRepositoryImpl(datasource, transactionsRepository);
});
