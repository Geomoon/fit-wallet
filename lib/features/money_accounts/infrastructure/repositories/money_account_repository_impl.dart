import 'package:fit_wallet/features/money_accounts/domain/datasources/datasources.dart';
import 'package:fit_wallet/features/money_accounts/domain/entities/create_money_account_entity.dart';
import 'package:fit_wallet/features/money_accounts/domain/entities/money_account_last_transaction_entity.dart';
import 'package:fit_wallet/features/money_accounts/domain/repositories/repositories.dart';
import 'package:fit_wallet/features/shared/domain/domain.dart';
import 'package:fit_wallet/features/transactions/domain/domain.dart';

class MoneyAccountRepositoryImpl implements MoneyAccountRepository {
  MoneyAccountRepositoryImpl(
    this._datasource, {
    required this.transactionsRepository,
  });

  final MoneyAccountDatasource _datasource;

  final TransactionsRepository transactionsRepository;

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
  Future<MoneyAccountLastTransactionEntity> getById(String id) {
    return _datasource.getById(id);
  }

  @override
  Future<bool> update(String id, CreateMoneyAccountEntity entity) async {
    final account = await getById(id);

    final diffAmount = account.amount - entity.value;

    if (diffAmount != 0) {
      final isExpense = diffAmount > 0;
      final transaction = CreateTransactionEntity(
        amount: isExpense ? diffAmount : diffAmount * -1,
        type: isExpense ? TransactionType.expense : TransactionType.income,
        maccId: account.id,
        cateId: '0aefa50a-6b10-4836-9337-470b379825ca',
      );

      await transactionsRepository.create(transaction);
    }

    return await _datasource.update(id, entity);
  }

  @override
  Future<bool> archiveById(String id) {
    return _datasource.archiveById(id);
  }
}
