import 'package:fit_wallet/features/shared/domain/entities/pagination_entity.dart';
import 'package:fit_wallet/features/transactions/domain/domain.dart';

class TransactionsRepositoryImpl extends TransactionsRepository {
  TransactionsRepositoryImpl(this._datasource);

  final TransactionsDatasource _datasource;

  @override
  Future<void> create(CreateTransactionEntity entity) {
    return _datasource.create(entity);
  }

  @override
  Future<bool> delete(String id) {
    return _datasource.delete(id);
  }

  @override
  Future<PaginationEntity<TransactionEntity>> getAll(
      GetTransactionsParams params) {
    return _datasource.getAll(params);
  }

  @override
  Future<TransactionEntity> getById(String id) {
    return _datasource.getById(id);
  }

  @override
  Future<BalanceEntity> getBalance() {
    return _datasource.getBalance();
  }
}
