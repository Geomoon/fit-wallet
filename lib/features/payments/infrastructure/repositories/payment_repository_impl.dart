import 'package:fit_wallet/features/payments/domain/datasources/datasources.dart';
import 'package:fit_wallet/features/payments/domain/entities/entities.dart';
import 'package:fit_wallet/features/payments/domain/repositories/repositories.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  PaymentRepositoryImpl(this.datasource);

  final PaymentDatasource datasource;

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
    return await datasource.update(entity);
  }

  @override
  Future<PaymentEntity> getById(String id) async {
    return await datasource.getById(id);
  }
}
