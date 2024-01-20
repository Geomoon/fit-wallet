import 'package:fit_wallet/features/payments/presentation/providers/payments_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final paymentsPendingProvider = FutureProvider((ref) {
  final repo = ref.watch(paymentsRepositoryProvider);
  return repo.getPendings();
});
