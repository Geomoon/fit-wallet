import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fit_wallet/features/money_accounts/presentation/providers/providers.dart';
import 'package:fit_wallet/features/money_accounts/presentation/widgets/widgets.dart';
import 'package:fit_wallet/features/shared/domain/domain.dart';
import 'package:fit_wallet/features/shared/infrastructure/utils/utils.dart';
import 'package:fit_wallet/features/shared/presentation/presentation.dart';
import 'package:fit_wallet/features/transactions/presentation/widgets/widgets.dart';
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
          delegate: FilterButtonsDelegate(),
        ),
        TransactionsList(
          scrollController: scrollController,
          maccId: maccId,
        ),
        LoadingMoreTransactions(maccId: maccId),
      ],
    );
  }
}

class DatePickerBottomDialog extends ConsumerWidget {
  const DatePickerBottomDialog({
    super.key,
    required this.onPickDate,
  });

  final void Function(bool) onPickDate;

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
                  AppLocalizations.of(context)!.byDate,
                  style: textTheme.titleLarge,
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          ListTile(
            leading: const Icon(Icons.calendar_today_rounded),
            title: Text(AppLocalizations.of(context)!.today),
            onTap: () {
              ref
                  .read(dateFilterValueProvider.notifier)
                  .setType(DateFilter.today);
              context.pop();
            },
          ),
          ListTile(
            leading: const Icon(Icons.calendar_view_week_rounded),
            title: Text(AppLocalizations.of(context)!.thisWeek),
            onTap: () {
              ref
                  .read(dateFilterValueProvider.notifier)
                  .setType(DateFilter.week);
              context.pop();
            },
          ),
          ListTile(
            leading: const Icon(Icons.calendar_month_rounded),
            title: Text(AppLocalizations.of(context)!.thisMonth),
            onTap: () {
              ref
                  .read(dateFilterValueProvider.notifier)
                  .setType(DateFilter.month);
              context.pop();
            },
          ),
          ListTile(
            leading: const Icon(Icons.calendar_view_day_rounded),
            title: Text(AppLocalizations.of(context)!.pickADate),
            onTap: () => onPickDate(false),
            trailing: const Icon(Icons.arrow_forward_rounded),
          ),
          ListTile(
            leading: const Icon(Icons.date_range_rounded),
            title: Text(AppLocalizations.of(context)!.pickRange),
            onTap: () => onPickDate(true),
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

  String title(BuildContext context, TransactionTypeFilter type) {
    switch (type) {
      case TransactionTypeFilter.all:
        return AppLocalizations.of(context)!.all;
      case TransactionTypeFilter.income:
        return AppLocalizations.of(context)!.income;
      case TransactionTypeFilter.expense:
        return AppLocalizations.of(context)!.expense;
      case TransactionTypeFilter.transfer:
        return AppLocalizations.of(context)!.transfer;
      default:
        return AppLocalizations.of(context)!.byType;
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
          Text(title(context, filter)),
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
                  AppLocalizations.of(context)!.transactionType,
                  style: textTheme.titleLarge,
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          ListTile(
            leading: const Icon(Icons.merge_rounded),
            title: Text(AppLocalizations.of(context)!.all),
            onTap: () {
              ref
                  .read(transactionTypeFilterProvider.notifier)
                  .update((state) => TransactionTypeFilter.all);
              context.pop();
            },
          ),
          ListTile(
            leading: const Icon(Icons.arrow_upward_rounded),
            title: Text(AppLocalizations.of(context)!.income),
            onTap: () {
              ref
                  .read(transactionTypeFilterProvider.notifier)
                  .update((state) => TransactionTypeFilter.income);
              context.pop();
            },
          ),
          ListTile(
            leading: const Icon(Icons.arrow_downward_rounded),
            title: Text(AppLocalizations.of(context)!.expense),
            onTap: () {
              ref
                  .read(transactionTypeFilterProvider.notifier)
                  .update((state) => TransactionTypeFilter.expense);
              context.pop();
            },
          ),
          ListTile(
            leading: const Icon(CupertinoIcons.arrow_right_arrow_left),
            title: Text(AppLocalizations.of(context)!.transfer),
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

class CalendarRangePickerBottomDialog extends ConsumerWidget {
  const CalendarRangePickerBottomDialog({
    super.key,
    required this.title,
    this.onStartDateChanged,
    this.onEndDateChanged,
    this.firstDate,
    this.lastDate,
  });

  final String title;

  final void Function(DateTime)? onStartDateChanged;
  final void Function(DateTime)? onEndDateChanged;

  final DateTime? firstDate;
  final DateTime? lastDate;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).primaryTextTheme;
    final color = Theme.of(context).colorScheme.primary;

    final position = ref.watch(positionProvider);

    return Padding(
      padding: const EdgeInsets.only(
        top: 10.0,
        bottom: 0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: textTheme.titleLarge,
                ),
                AsyncButton(
                  callback: context.pop,
                  child: const Icon(Icons.done_rounded),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: InkWell(
                    onTap: () => ref
                        .read(positionProvider.notifier)
                        .update((state) => 0),
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 12),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            firstDate == null
                                ? AppLocalizations.of(context)!.selectStartDate
                                : Utils.formatYYYDDMM(firstDate!),
                            style: position == 0
                                ? const TextStyle(fontWeight: FontWeight.bold)
                                : null,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (position == 0)
                                Icon(Icons.circle, size: 12, color: color),
                              if (position == 0) const SizedBox(width: 10),
                              Text(
                                AppLocalizations.of(context)!
                                    .from
                                    .toUpperCase(),
                                style: textTheme.bodyLarge,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 1,
                  child: InkWell(
                    onTap: () => ref
                        .read(positionProvider.notifier)
                        .update((state) => 1),
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 12),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            lastDate == null
                                ? AppLocalizations.of(context)!.selectEndDate
                                : Utils.formatYYYDDMM(lastDate!),
                            style: position == 1
                                ? const TextStyle(fontWeight: FontWeight.bold)
                                : null,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (position == 1)
                                Icon(Icons.circle, size: 12, color: color),
                              if (position == 1) const SizedBox(width: 10),
                              Text(
                                AppLocalizations.of(context)!.to.toUpperCase(),
                                style: textTheme.bodyLarge,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          CalendarDatePicker(
            onDateChanged: (date) async {
              if (position == 0) {
                onStartDateChanged!(date);
              } else {
                onEndDateChanged!(date);
              }
            },
            initialDate:
                (position == 0 ? firstDate : lastDate) ?? DateTime.now(),
            currentDate:
                (position == 0 ? firstDate : lastDate) ?? DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime.now(),
          ),
        ],
      ),
    );
  }
}
