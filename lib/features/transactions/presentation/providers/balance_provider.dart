import 'package:fit_wallet/features/transactions/domain/domain.dart';
import 'package:fit_wallet/features/transactions/presentation/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final balanceProvider = FutureProvider.autoDispose<BalanceEntity>((ref) {
  final repo = ref.watch(transactionsRepositoryProvider);
  return repo.getBalance();
});
