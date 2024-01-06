import 'package:fit_wallet/features/home/presentation/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final screenTitleProvider = Provider((ref) {
  final actualPageIndex = ref.watch(homeNavigationProvider);

  return ['FitWallet', 'Money Accounts', 'Pending Payments'][actualPageIndex];
});
