import 'package:fit_wallet/features/payments/domain/entities/entities.dart';

abstract class PaymentRepository {
  Future<List<PaymentEntity>> getAll(GetPaymentParams params);
  Future<PaymentEntity> getById(String id);
  Future<bool> create(PaymentEntity entity);
  Future<bool> update(PaymentEntity entity);
  Future<bool> pay(PaymentEntity entity, double payAmount);
  Future<void> delete(String id);
}
