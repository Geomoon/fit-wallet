import 'package:fit_wallet/config/themes/dark_theme.dart';
import 'package:fit_wallet/features/home/presentation/presentation.dart';
import 'package:fit_wallet/features/money_accounts/presentation/providers/providers.dart';
import 'package:fit_wallet/features/money_accounts/presentation/widgets/widgets.dart';
import 'package:fit_wallet/features/shared/domain/domain.dart';
import 'package:fit_wallet/features/shared/presentation/presentation.dart';
import 'package:fit_wallet/features/shared/presentation/providers/date_filter_provider.dart';
import 'package:fit_wallet/features/shared/presentation/providers/transaction_type_filter_provider.dart';
import 'package:fit_wallet/features/transactions/presentation/providers/transactions_by_money_account_provider.dart';
import 'package:fit_wallet/features/transactions/presentation/providers/transactions_repository_provider.dart';
import 'package:fit_wallet/features/transactions/presentation/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
  _DetailView({required this.maccId});

  final String maccId;

  final EdgeInsets _cardMargin = const EdgeInsets.symmetric(
    vertical: 16,
    horizontal: 28,
  );

  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: scrollController,
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
        SliverPersistentHeader(
          pinned: true,
          delegate: MyHeaderDelegate(),
        ),
        MoneyAccountTransactionsList(
          scrollController: scrollController,
          maccId: maccId,
        ),
        LoadingMoreTransactions(maccId: maccId),
      ],
    );
  }
}

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

class MyHeaderDelegate extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final colors = Theme.of(context).colorScheme.background;
    return Container(
      color: colors,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: const Row(
        children: [
          SizedBox(width: 20),
          FilterButton(),
          SizedBox(width: 10),
          TransactionTypeFilterButton(),
          Spacer(),
          ClearFiltersButton(),
          SizedBox(width: 20),
        ],
      ),
    );
  }

  @override
  double get maxExtent => 68;

  @override
  double get minExtent => 68;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}

class MoneyAccountTransactionsList extends ConsumerWidget {
  const MoneyAccountTransactionsList({
    super.key,
    required this.scrollController,
    required this.maccId,
  });

  final ScrollController scrollController;
  final String maccId;

  Future<bool?> onDissmissTile(
      BuildContext context, WidgetRef ref, String id) async {
    final deleted = await showDialog<bool?>(
      context: context,
      builder: (context) {
        return ConfirmDialog(
          onConfirm: () => ref.read(transactionsRepositoryProvider).delete(id),
          title: 'Delete transaction',
          description: 'Are you sure to delete this transaction?',
        );
      },
    );

    if (deleted == true) {
      if (context.mounted) {
        const SnackBarContent(
          title: 'Transactions deleted',
          tinted: true,
          type: SnackBarType.success,
        ).show(context);
        ref.read(getTransactionsFilterProvider(maccId).notifier).removeItem(id);
      }
    } else if (deleted == false) {
      if (context.mounted) {
        const SnackBarContent(
          title: 'Error at delete',
          tinted: true,
          type: SnackBarType.error,
        ).show(context);
      }
    }

    return deleted;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactions = ref.watch(getTransactionsFilterProvider(maccId));

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
              const Text('No transactions'),
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
        transaction: transactions.items[index],
        isDissmisable: true,
        confirmDismiss: (_) =>
            onDissmissTile(context, ref, transactions.items[index].id),
      ),
    );
  }
}

class ClearFiltersButton extends ConsumerWidget {
  const ClearFiltersButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      onPressed: () {
        ref
            .read(transactionTypeFilterProvider.notifier)
            .update((state) => TransactionTypeFilter.all);
        ref.read(dateFilterValueProvider.notifier).setType(DateFilter.empty);
      },
      icon: const Icon(Icons.filter_alt_off_rounded),
    );
  }
}

class FilterButton extends ConsumerWidget {
  const FilterButton({
    super.key,
  });

  void _showDialogFilter(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      builder: (context) {
        return BottomSheet(
          onClosing: () {},
          showDragHandle: false,
          enableDrag: false,
          builder: (context) {
            return DatePickerBottomDialog(onPickDate: () {
              context.pop();
              _showDatePickerDialog(context);
            });
          },
        );
      },
    );
  }

  void _showDatePickerDialog(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      builder: (context) {
        return Consumer(builder: (context, ref, _) {
          return CalendarPickerBottomDialog(
            title: 'By date',
            onDateChanged: (d) => ref
                .read(dateFilterValueProvider.notifier)
                .setType(DateFilter.date, d),
          );
        });
      },
    );
  }

  String title(DateFilter type) {
    switch (type) {
      case DateFilter.empty:
        return 'By date';
      case DateFilter.today:
        return 'Today';
      case DateFilter.week:
        return 'This week';
      case DateFilter.month:
        return 'This month';
      case DateFilter.date:
        return 'Select a date';
      default:
        return 'By date';
    }
  }

  IconData icon(DateFilter type) {
    switch (type) {
      case DateFilter.empty:
        return Icons.calendar_view_day_rounded;
      case DateFilter.today:
        return Icons.calendar_today_rounded;
      case DateFilter.week:
        return Icons.calendar_view_week_rounded;
      case DateFilter.month:
        return Icons.calendar_month_rounded;
      default:
        return Icons.calendar_view_day_rounded;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final style = DarkTheme.primaryFilterStyle;

    final filter = ref.watch(dateFilterValueProvider);

    return ElevatedButton(
      style: style,
      onPressed: () => _showDialogFilter(context),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title(filter.type)),
          if (filter.type != DateFilter.date) const SizedBox(width: 10),
          if (filter.type != DateFilter.date) Icon(icon(filter.type), size: 18),
        ],
      ),
    );
  }
}

class DatePickerBottomDialog extends ConsumerWidget {
  const DatePickerBottomDialog({
    super.key,
    required this.onPickDate,
  });

  final void Function() onPickDate;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).primaryTextTheme;

    return Padding(
      padding: const EdgeInsets.only(
        top: 20.0,
        bottom: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Text(
                  'By date',
                  style: textTheme.titleLarge,
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          ListTile(
            leading: const Icon(Icons.calendar_today_rounded),
            title: const Text('Today'),
            onTap: () {
              ref
                  .read(dateFilterValueProvider.notifier)
                  .setType(DateFilter.today);
              context.pop();
            },
          ),
          ListTile(
            leading: const Icon(Icons.calendar_view_week_rounded),
            title: const Text('This week'),
            onTap: () {
              ref
                  .read(dateFilterValueProvider.notifier)
                  .setType(DateFilter.week);
              context.pop();
            },
          ),
          ListTile(
            leading: const Icon(Icons.calendar_month_rounded),
            title: const Text('This month'),
            onTap: () {
              ref
                  .read(dateFilterValueProvider.notifier)
                  .setType(DateFilter.month);
              context.pop();
            },
          ),
          ListTile(
            leading: const Icon(Icons.calendar_view_day_rounded),
            title: const Text('Pick date'),
            onTap: () {
              onPickDate();
            },
            trailing: const Icon(Icons.arrow_forward_rounded),
          ),
        ],
      ),
    );
  }
}

class CalendarPickerBottomDialog extends StatelessWidget {
  const CalendarPickerBottomDialog({
    super.key,
    required this.title,
    required this.onDateChanged,
    this.initialDate,
    this.firstDate,
    this.lastDate,
  });

  final String title;

  final void Function(DateTime) onDateChanged;

  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).primaryTextTheme;

    return Padding(
      padding: const EdgeInsets.only(
        top: 20.0,
        bottom: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Text(
                  title,
                  style: textTheme.titleLarge,
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          CalendarDatePicker(
            onDateChanged: (date) async {
              await Future.delayed(const Duration(milliseconds: 200)).then(
                (value) => context.pop(),
              );
              onDateChanged(date);
            },
            initialDate: initialDate ?? DateTime.now(),
            firstDate: firstDate ?? DateTime(2000),
            lastDate: lastDate ?? DateTime.now(),
          ),
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
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Row(
              children: [
                Text(
                  'Transaction Type',
                  style: textTheme.titleLarge,
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
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
