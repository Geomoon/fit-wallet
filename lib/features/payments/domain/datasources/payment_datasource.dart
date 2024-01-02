import 'package:fit_wallet/features/payments/domain/entities/entities.dart';

abstract class PaymentDatasource {
  Future<List<PaymentEntity>> getAll(GetPaymentParams params);
  Future<bool> create(PaymentEntity entity);
  Future<bool> update(PaymentEntity entity);
  Future<void> delete(String id);
}
