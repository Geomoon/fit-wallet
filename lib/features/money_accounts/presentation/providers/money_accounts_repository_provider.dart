import 'package:fit_wallet/features/money_accounts/infrastructure/infrastructure.dart';
import 'package:fit_wallet/features/shared/presentation/presentation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final moneyAccountsRepositoryProvider = Provider((ref) {
  final api = ref.watch(apiProvider);
  final datasource = MoneyAccountDatasourceImpl(api.dio);

  return MoneyAccountRepositoryImpl(datasource);
});
