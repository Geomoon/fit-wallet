import 'package:fit_wallet/features/shared/presentation/presentation.dart';
import 'package:fit_wallet/features/transactions/domain/domain.dart';
import 'package:fit_wallet/features/transactions/presentation/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final balanceProvider = FutureProvider.autoDispose<BalanceEntity>((ref) {
  final repo = ref.watch(transactionsRepositoryProvider);
  final filter = ref.watch(dateFilterValueProvider);
  return repo.getBalance(
    BalanceParams(
      startDate: filter.startDate,
      endDate: filter.endDate,
      date: filter.date,
    ),
  );
});
