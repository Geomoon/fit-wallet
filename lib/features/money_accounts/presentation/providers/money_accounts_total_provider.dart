import 'package:fit_wallet/features/money_accounts/presentation/providers/providers.dart';
import 'package:fit_wallet/features/shared/infrastructure/infrastructure.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final moneyAccountsTotalProvider = Provider((ref) {
  final accounts = ref.watch(moneyAccountsProvider).value;

  final total = accounts?.fold<double>(.0, (prev, e) => prev + e.amount);

  return Utils.currencyFormat(total ?? 0);
});
