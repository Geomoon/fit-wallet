import 'package:fit_wallet/features/money_accounts/domain/entities/entities.dart';

abstract class MoneyAccountRepository {
  Future<bool> create(CreateMoneyAccountEntity entity);
  Future<bool> update(String id, CreateMoneyAccountEntity entity);
  Future<List<MoneyAccountLastTransactionEntity>> getAll();
  Future<MoneyAccountLastTransactionEntity> getById(String id);
  Future<bool> deleteById(String id);
}
