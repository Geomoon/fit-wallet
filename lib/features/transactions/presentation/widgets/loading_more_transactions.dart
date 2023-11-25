import 'package:fit_wallet/features/transactions/presentation/providers/transactions_by_money_account_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoadingMoreTransactions extends StatelessWidget {
  const LoadingMoreTransactions({
    super.key,
    this.maccId,
  });

  final String? maccId;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final transaction = ref.watch(getTransactionsFilterProvider(maccId)
            .select((value) => value.isLoadingMore));

        if (transaction) {
          return const SliverToBoxAdapter(
            child: LinearProgressIndicator(),
          );
        }

        return const SliverToBoxAdapter(child: SizedBox.shrink());
      },
    );
  }
}
