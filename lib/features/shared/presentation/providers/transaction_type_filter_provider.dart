import 'package:fit_wallet/features/shared/domain/domain.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final transactionTypeFilterProvider = StateProvider.autoDispose((ref) {
  return TransactionTypeFilter.all;
});
