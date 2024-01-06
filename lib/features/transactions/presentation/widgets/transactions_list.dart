import 'package:fit_wallet/features/money_accounts/presentation/providers/providers.dart';
import 'package:fit_wallet/features/shared/presentation/presentation.dart';
import 'package:fit_wallet/features/transactions/presentation/providers/providers.dart';
import 'package:fit_wallet/features/transactions/presentation/providers/transactions_by_money_account_provider.dart';
import 'package:fit_wallet/features/transactions/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TransactionsList extends ConsumerWidget {
  const TransactionsList({
    super.key,
    required this.scrollController,
    this.maccId,
  });

  final ScrollController scrollController;
  final String? maccId;

  Future<bool?> onDissmissTile(
      BuildContext context, WidgetRef ref, String id) async {
    final deleted = await showDialog(
      context: context,
      builder: (context) {
        return ConfirmDialog(
          onConfirm: () => ref.read(transactionsRepositoryProvider).delete(id),
          title: 'Delete transaction',
          description: 'Are you sure to delete this transaction?',
        );
      },
    );

    if (deleted == false) {
      if (context.mounted) {
        const SnackBarContent(
          title: 'Error at delete',
          tinted: true,
          type: SnackBarType.error,
        ).show(context);
      }
    }

    if (deleted == true) {
      if (context.mounted) {
        const SnackBarContent(
          title: 'Transactions deleted',
          tinted: true,
          type: SnackBarType.success,
        ).show(context);
        ref.read(getTransactionsFilterProvider(maccId).notifier).removeItem(id);
        ref.invalidate(balanceProvider);
        ref.invalidate(moneyAccountByIdProvider);
        ref.invalidate(moneyAccountsProvider);
        ref.invalidate(getTransactionsProvider);
      }
    }

    return deleted;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactions = ref.watch(getTransactionsFilterProvider(maccId));
    final textTheme = Theme.of(context).primaryTextTheme;

    scrollController.addListener(
      () {
        if (transactions.isLoading || transactions.isLoadingMore) return;
        final maxScroll = scrollController.position.maxScrollExtent;
        final currentScroll = scrollController.position.pixels;
        final delta = MediaQuery.of(context).size.height * .5;
        if (maxScroll - currentScroll <= delta) {
          ref.read(getTransactionsFilterProvider(maccId).notifier).fetchNext();
        }
      },
    );

    if (transactions.isLoading) {
      return const SliverToBoxAdapter(
        child: SizedBox(
          height: 300,
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    if (transactions.items.isEmpty) {
      return SliverToBoxAdapter(
        child: SizedBox(
          height: 420,
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/images/empty_list.svg',
              ),
              const SizedBox(height: 20),
              Text('No transactions', style: textTheme.bodyMedium),
            ],
          ),
        ),
      );
    }

    if (transactions.errorLoading != '') {
      return SliverToBoxAdapter(
        child: Center(child: Text(transactions.errorLoading)),
      );
    }

    return SliverList.builder(
      itemCount: transactions.items.length,
      itemBuilder: (context, index) => TransactionListTile(
        isDissmisable: true,
        transaction: transactions.items[index],
        confirmDismiss: (_) =>
            onDissmissTile(context, ref, transactions.items[index].id),
      ),
    );
  }
}
