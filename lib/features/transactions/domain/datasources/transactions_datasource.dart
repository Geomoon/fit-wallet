import 'package:fit_wallet/features/shared/domain/domain.dart';
import 'package:fit_wallet/features/transactions/domain/entities/entities.dart';

abstract class TransactionsDatasource {
  Future<PaginationEntity<TransactionEntity>> getAll(
    GetTransactionsParams params,
  );
  Future<TransactionEntity> getById(String id);
  Future<void> create(CreateTransactionEntity entity);
  Future<void> delete(String id);
}
