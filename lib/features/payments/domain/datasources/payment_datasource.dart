import 'package:fit_wallet/features/payments/domain/entities/entities.dart';

abstract class PaymentDatasource {
  Future<List<PaymentEntity>> getAll(GetPaymentParams params);
  Future<PaymentEntity> getById(String id);
  Future<bool> create(PaymentEntity entity);
  Future<bool> update(PaymentEntity entity);
  Future<void> delete(String id);
  Future<int> getPendings();
}
