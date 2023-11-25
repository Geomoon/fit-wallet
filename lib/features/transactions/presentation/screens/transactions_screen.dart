import 'package:fit_wallet/features/transactions/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';

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
          delegate: FilterButtonsDelegate(),
        ),
        TransactionsList(scrollController: scrollController),
        const LoadingMoreTransactions(),
      ],
    );
  }
}
