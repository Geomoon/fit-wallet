import 'package:fit_wallet/config/themes/dark_theme.dart';
import 'package:fit_wallet/features/money_accounts/presentation/providers/providers.dart';
import 'package:fit_wallet/features/money_accounts/presentation/widgets/widgets.dart';
import 'package:fit_wallet/features/shared/domain/domain.dart';
import 'package:fit_wallet/features/shared/presentation/providers/transaction_type_filter_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class MoneyAccountsDetailScreen extends StatelessWidget {
  const MoneyAccountsDetailScreen({super.key, required this.maccId});

  final String maccId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: _DetailView(maccId: maccId),
    );
  }
}

class _DetailView extends StatelessWidget {
  const _DetailView({required this.maccId});

  final String maccId;

  final EdgeInsets _cardMargin = const EdgeInsets.symmetric(
    vertical: 16,
    horizontal: 28,
  );

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Consumer(
            builder: (context, ref, child) {
              final accountProvider =
                  ref.watch(moneyAccountByIdProvider(maccId));

              return accountProvider.when(
                data: (account) {
                  return Hero(
                    tag: account.id,
                    child:
                        MoneyAccountCard(account: account, margin: _cardMargin),
                  );
                },
                error: (_, __) => Container(),
                loading: () => Container(),
              );
            },
          ),
        ),
        SliverToBoxAdapter(
          child: Row(
            children: [
              const SizedBox(width: 20),
              const FilterButton(
                text: 'By date',
                icon: Icons.arrow_downward_rounded,
                isPrimary: true,
              ),
              const SizedBox(width: 10),
              // const FilterButton(
              //     text: 'By type', icon: Icons.merge_type_rounded),
              const TransactionTypeFilterButton(),
              const Spacer(),
              IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.filter_alt_off_rounded)),
              const SizedBox(width: 20),
            ],
          ),
        )
      ],
    );
  }
}

class FilterButton extends StatelessWidget {
  const FilterButton({
    super.key,
    required this.text,
    required this.icon,
    this.isPrimary = false,
  });

  final String text;
  final IconData icon;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    final style = (isPrimary) ? DarkTheme.primaryFilterStyle : null;

    return ElevatedButton(
      style: style,
      onPressed: () {},
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(text),
          const SizedBox(width: 10),
          Icon(icon, size: 18),
        ],
      ),
    );
  }
}

class TransactionTypeFilterButton extends ConsumerWidget {
  const TransactionTypeFilterButton({
    super.key,
  });

  String title(TransactionTypeFilter type) {
    switch (type) {
      case TransactionTypeFilter.all:
        return 'All';
      case TransactionTypeFilter.income:
        return 'Income';
      case TransactionTypeFilter.expense:
        return 'Expense';
      case TransactionTypeFilter.transfer:
        return 'Transfer';
      default:
        return 'By type';
    }
  }

  IconData icon(TransactionTypeFilter type) {
    switch (type) {
      case TransactionTypeFilter.all:
        return Icons.merge_rounded;
      case TransactionTypeFilter.income:
        return Icons.arrow_upward_rounded;
      case TransactionTypeFilter.expense:
        return Icons.arrow_downward_rounded;
      case TransactionTypeFilter.transfer:
        return CupertinoIcons.arrow_right_arrow_left;
      default:
        return Icons.merge_rounded;
    }
  }

  void _showDialogFilter(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      builder: (context) {
        return BottomSheet(
          onClosing: () {},
          showDragHandle: false,
          enableDrag: false,
          builder: (context) {
            return const TransactionTypeDialog();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(transactionTypeFilterProvider);

    return ElevatedButton(
      onPressed: () => _showDialogFilter(context),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title(filter)),
          const SizedBox(width: 10),
          Icon(icon(filter), size: 18),
        ],
      ),
    );
  }
}

class TransactionTypeDialog extends ConsumerWidget {
  const TransactionTypeDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).primaryTextTheme;
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: Row(
              children: [
                Text(
                  'Transaction Type',
                  style: textTheme.titleLarge,
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.merge_rounded),
            title: const Text('All'),
            onTap: () {
              ref
                  .read(transactionTypeFilterProvider.notifier)
                  .update((state) => TransactionTypeFilter.all);
              context.pop();
            },
          ),
          ListTile(
            leading: const Icon(Icons.arrow_upward_rounded),
            title: const Text('Income'),
            onTap: () {
              ref
                  .read(transactionTypeFilterProvider.notifier)
                  .update((state) => TransactionTypeFilter.income);
              context.pop();
            },
          ),
          ListTile(
            leading: const Icon(Icons.arrow_downward_rounded),
            title: const Text('Expense'),
            onTap: () {
              ref
                  .read(transactionTypeFilterProvider.notifier)
                  .update((state) => TransactionTypeFilter.expense);
              context.pop();
            },
          ),
          ListTile(
            leading: const Icon(CupertinoIcons.arrow_right_arrow_left),
            title: const Text('Transfer'),
            onTap: () {
              ref
                  .read(transactionTypeFilterProvider.notifier)
                  .update((state) => TransactionTypeFilter.transfer);
              context.pop();
            },
          ),
        ],
      ),
    );
  }
}
