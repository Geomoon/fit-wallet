import 'package:fit_wallet/features/money_accounts/domain/datasources/datasources.dart';
import 'package:fit_wallet/features/money_accounts/domain/entities/create_money_account_entity.dart';
import 'package:fit_wallet/features/money_accounts/domain/entities/money_account_entity.dart';
import 'package:fit_wallet/features/money_accounts/domain/entities/money_account_last_transaction_entity.dart';
import 'package:fit_wallet/features/money_accounts/domain/repositories/repositories.dart';

class MoneyAccountRepositoryImpl implements MoneyAccountRepository {
  MoneyAccountRepositoryImpl(this._datasource);

  final MoneyAccountDatasource _datasource;

  @override
  Future<bool> create(CreateMoneyAccountEntity entity) {
    return _datasource.create(entity);
  }

  @override
  Future<bool> deleteById(String id) {
    return _datasource.deleteById(id);
  }

  @override
  Future<List<MoneyAccountLastTransactionEntity>> getAll() {
    return _datasource.getAll();
  }

  @override
  Future<List<MoneyAccountEntity>> getById(String id) {
    return _datasource.getById(id);
  }

  @override
  Future<bool> update(String id, CreateMoneyAccountEntity entity) {
    return _datasource.update(id, entity);
  }
}
