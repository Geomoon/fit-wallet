import 'package:fit_wallet/config/themes/themes.dart';
import 'package:fit_wallet/features/transactions/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All transactions'),
      ),
      body: const _TransactionsScreenView(),
    );
  }
}

class _TransactionsScreenView extends StatelessWidget {
  const _TransactionsScreenView();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: 4, left: 10, right: 10),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: TransactionsResume(),
          )
        ],
      ),
    );
  }
}

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
    final fontSize = Theme.of(context).primaryTextTheme.titleLarge!.fontSize;

    return balance.when(
      data: (data) => GridView(
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
                      const Text(
                        'Incomes',
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
                        style: TextStyle(fontSize: fontSize),
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
                      const Text('Expenses'),
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
                        style: TextStyle(fontSize: fontSize),
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
