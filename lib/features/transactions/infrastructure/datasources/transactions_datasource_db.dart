import 'package:fit_wallet/features/shared/domain/entities/pagination_entity.dart';
import 'package:fit_wallet/features/shared/infrastructure/infrastructure.dart';
import 'package:fit_wallet/features/transactions/domain/domain.dart';
import 'package:fit_wallet/features/transactions/infrastructure/mappers/mappers.dart';
import 'package:sqflite/sqflite.dart';

class TransactionsDatasourceDb implements TransactionsDatasource {
  TransactionsDatasourceDb(this._db);

  final Database _db;

  static const String table = 'transactions';

  @override
  Future<void> create(CreateTransactionEntity entity) async {
    final transaction = TransactionsMapper.createToJsonDb(entity);

    transaction['tran_id'] = Utils.uuid;
    transaction['tran_created_at'] = Utils.now;

    await _db.insert(table, transaction);
  }

  @override
  Future<bool> delete(String id) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<PaginationEntity<TransactionEntity>> getAll(
      GetTransactionsParams params) {
    // TODO: implement getAll
    throw UnimplementedError();
  }

  @override
  Future<BalanceEntity> getBalance() {
    // TODO: implement getBalance
    throw UnimplementedError();
  }

  @override
  Future<TransactionEntity> getById(String id) {
    // TODO: implement getById
    throw UnimplementedError();
  }
}
