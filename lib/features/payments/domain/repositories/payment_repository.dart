import 'package:fit_wallet/features/payments/domain/entities/payment_entity.dart';

abstract class PaymentRepository {
  Future<PaymentEntity> getAll();
  Future<bool> create(PaymentEntity entity);
  Future<bool> update(PaymentEntity entity);
  Future<void> delete(String id);
}
