import 'package:fit_wallet/features/payments/domain/entities/entities.dart';
import 'package:fit_wallet/features/payments/presentation/providers/payments_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final paymentsProvider =
    FutureProvider.family<List<PaymentEntity>, GetPaymentParams>(
  (ref, params) {
    final repository = ref.watch(paymentsRepositoryProvider);

    return repository.getAll(params);
  },
);
