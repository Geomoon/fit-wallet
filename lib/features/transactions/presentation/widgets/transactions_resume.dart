import 'package:fit_wallet/config/themes/themes.dart';
import 'package:fit_wallet/features/transactions/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransactionsResume extends ConsumerWidget {
  const TransactionsResume({super.key});

  final EdgeInsetsGeometry _padding = const EdgeInsets.all(10);
  final SliverGridDelegate _delegate =
      const SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    childAspectRatio: 1.4,
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final balance = ref.watch(balanceProvider);
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).primaryTextTheme;

    return balance.when(
      data: (data) => GridView(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: _delegate,
        children: [
          Card(
            child: Padding(
              padding: _padding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Incomes',
                        style: textTheme.labelLarge,
                      ),
                      CircleAvatar(
                        backgroundColor: DarkTheme.green,
                        foregroundColor: colors.background,
                        child: const Icon(Icons.arrow_upward_rounded),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        data.incomes.valueTxt,
                        style: textTheme.titleLarge,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Card(
            child: Padding(
              padding: _padding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Expenses',
                        style: textTheme.labelLarge,
                      ),
                      CircleAvatar(
                        backgroundColor: colors.error,
                        foregroundColor: colors.onError,
                        child: const Icon(Icons.arrow_downward_rounded),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        data.expenses.valueTxt,
                        style: textTheme.titleLarge,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      error: (error, stackTrace) => Container(),
      loading: () => Container(),
    );
  }
}
