import 'package:fit_wallet/features/shared/presentation/presentation.dart';
import 'package:fit_wallet/features/transactions/infrastructure/datasources/datasouces.dart';
import 'package:fit_wallet/features/transactions/infrastructure/repositories/repositories.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final transactionsRepositoryProvider = Provider((ref) {
  final api = ref.watch(apiProvider);
  final datasource = TransactionsDatasourceImpl(api.dio);
  return TransactionsRepositoryImpl(datasource);
});
