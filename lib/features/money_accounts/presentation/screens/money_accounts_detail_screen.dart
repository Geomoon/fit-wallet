import 'package:fit_wallet/config/themes/dark_theme.dart';
import 'package:fit_wallet/features/money_accounts/presentation/providers/providers.dart';
import 'package:fit_wallet/features/money_accounts/presentation/widgets/widgets.dart';
import 'package:fit_wallet/features/shared/domain/domain.dart';
import 'package:fit_wallet/features/shared/presentation/providers/date_filter_provider.dart';
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
        const SliverToBoxAdapter(
          child: Row(
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
        )
      ],
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
        ref
            .read(dateFilterProvider.notifier)
            .update((state) => DateFilter.empty);
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
        return const CalendarPickerBottomDialog();
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

    final filter = ref.watch(dateFilterProvider);

    return ElevatedButton(
      style: style,
      onPressed: () => _showDialogFilter(context),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title(filter)),
          if (filter != DateFilter.date) const SizedBox(width: 10),
          if (filter != DateFilter.date) Icon(icon(filter), size: 18),
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
                  .read(dateFilterProvider.notifier)
                  .update((state) => DateFilter.today);
              context.pop();
            },
          ),
          ListTile(
            leading: const Icon(Icons.calendar_view_week_rounded),
            title: const Text('This week'),
            onTap: () {
              ref
                  .read(dateFilterProvider.notifier)
                  .update((state) => DateFilter.week);
              context.pop();
            },
          ),
          ListTile(
            leading: const Icon(Icons.calendar_month_rounded),
            title: const Text('This month'),
            onTap: () {
              ref
                  .read(dateFilterProvider.notifier)
                  .update((state) => DateFilter.month);
              context.pop();
            },
          ),
          ListTile(
            leading: const Icon(Icons.calendar_view_day_rounded),
            title: const Text('Pick date'),
            onTap: () {
              ref
                  .read(dateFilterProvider.notifier)
                  .update((state) => DateFilter.date);
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
  const CalendarPickerBottomDialog({super.key});

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
                  'By date',
                  style: textTheme.titleLarge,
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          CalendarDatePicker(
            onDateChanged: (d) {},
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime.now(),
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
