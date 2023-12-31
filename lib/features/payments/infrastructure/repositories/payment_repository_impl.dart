import 'package:fit_wallet/features/payments/domain/datasources/datasources.dart';
import 'package:fit_wallet/features/payments/domain/entities/payment_entity.dart';
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
    datasource.delete(id);
  }

  @override
  Future<PaymentEntity> getAll() async {
    return await datasource.getAll();
  }

  @override
  Future<bool> update(PaymentEntity entity) async {
    return datasource.update(entity);
  }
}
