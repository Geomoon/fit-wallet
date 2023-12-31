import 'package:fit_wallet/features/payments/domain/datasources/datasources.dart';
import 'package:fit_wallet/features/payments/domain/entities/payment_entity.dart';

class PaymentDatasourceDb implements PaymentDatasource {
  @override
  Future<bool> create(PaymentEntity entity) {
    // TODO: implement create
    throw UnimplementedError();
  }

  @override
  Future<void> delete(String id) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<PaymentEntity> getAll() {
    // TODO: implement getAll
    throw UnimplementedError();
  }

  @override
  Future<bool> update(PaymentEntity entity) {
    // TODO: implement update
    throw UnimplementedError();
  }
}
