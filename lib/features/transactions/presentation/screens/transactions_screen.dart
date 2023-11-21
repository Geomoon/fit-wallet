import 'package:fit_wallet/config/themes/themes.dart';
import 'package:fit_wallet/features/home/presentation/presentation.dart';
import 'package:fit_wallet/features/money_accounts/presentation/presentation.dart';
import 'package:fit_wallet/features/transactions/presentation/providers/providers.dart';
import 'package:fit_wallet/features/transactions/presentation/providers/transactions_by_money_account_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All transactions'),
      ),
      body: _TransactionsScreenView(),
    );
  }
}

class _TransactionsScreenView extends StatelessWidget {
  _TransactionsScreenView();

  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: scrollController,
      slivers: [
        const SliverToBoxAdapter(
          child: TransactionsResume(),
        ),
        SliverPersistentHeader(
          pinned: true,
          delegate: MyHeaderDelegate(),
        ),
        TransactionsList(scrollController: scrollController),
        const LoadingMoreTransactions(),
      ],
    );
  }
}

class TransactionsList extends ConsumerWidget {
  const TransactionsList({
    super.key,
    required this.scrollController,
  });

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactions = ref.watch(getTransactionsFilterProvider(null));

    scrollController.addListener(
      () {
        if (transactions.isLoading || transactions.isLoadingMore) return;
        final maxScroll = scrollController.position.maxScrollExtent;
        final currentScroll = scrollController.position.pixels;
        final delta = MediaQuery.of(context).size.height * .5;
        if (maxScroll - currentScroll <= delta) {
          ref.read(getTransactionsFilterProvider(null).notifier).fetchNext();
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
      ),
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
          SizedBox(width: 10),
          FilterButton(),
          SizedBox(width: 10),
          TransactionTypeFilterButton(),
          Spacer(),
          ClearFiltersButton(),
          SizedBox(width: 10),
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
