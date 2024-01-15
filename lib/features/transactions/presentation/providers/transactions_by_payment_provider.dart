import 'package:fit_wallet/features/shared/domain/domain.dart';
import 'package:fit_wallet/features/transactions/domain/domain.dart';
import 'package:fit_wallet/features/transactions/presentation/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final transactionsByPaymentProvider = FutureProvider.family
    .autoDispose<PaginationEntity<TransactionEntity>, String>((ref, paymId) {
  final repo = ref.watch(transactionsRepositoryProvider);

  return repo.getAll(GetTransactionsParams(
    type: TransactionTypeFilter.all,
    page: 1,
    limit: 10000,
    paymId: paymId,
  ));
});
