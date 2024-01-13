import 'package:fit_wallet/features/payments/domain/datasources/datasources.dart';
import 'package:fit_wallet/features/payments/domain/entities/entities.dart';
import 'package:fit_wallet/features/payments/domain/repositories/repositories.dart';
import 'package:fit_wallet/features/shared/domain/domain.dart';
import 'package:fit_wallet/features/transactions/domain/domain.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  PaymentRepositoryImpl(this.datasource, this.transactionsRepository);

  final PaymentDatasource datasource;
  final TransactionsRepository transactionsRepository;

  @override
  Future<bool> create(PaymentEntity entity) async {
    return await datasource.create(entity);
  }

  @override
  Future<void> delete(String id) async {
    await datasource.delete(id);
  }

  @override
  Future<List<PaymentEntity>> getAll(GetPaymentParams params) async {
    return await datasource.getAll(params);
  }

  @override
  Future<bool> update(PaymentEntity entity) async {
    final isCompleted = entity.amount <= entity.amountPaid;
    entity.isCompleted = isCompleted;

    if (entity.account != null) {
      final transaction = CreateTransactionEntity(
        amount: entity.amountPaid,
        type: TransactionType.expense,
        maccId: entity.account?.id,
        paymId: entity.id,
        cateId: '37431c78-a65e-450f-8aec-1a13977db5fa', // pay category
      );

      await transactionsRepository.create(transaction);
    }

    return await datasource.update(entity);
  }

  @override
  Future<PaymentEntity> getById(String id) async {
    return await datasource.getById(id);
  }
}
