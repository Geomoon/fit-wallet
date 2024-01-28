import 'package:fit_wallet/config/themes/ligth_theme.dart';
import 'package:fit_wallet/features/transactions/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
          systemNavigationBarColor: Theme.of(context).colorScheme.background),
    );

    return WillPopScope(
      onWillPop: () async {
        final isDark =
            MediaQuery.of(context).platformBrightness == Brightness.dark;

        if (isDark) {
          SystemChrome.setSystemUIOverlayStyle(
            SystemUiOverlayStyle.dark.copyWith(
              systemNavigationBarColor: const Color(0xff1e1e21),
            ),
          );
        } else {
          SystemChrome.setSystemUIOverlayStyle(
            SystemUiOverlayStyle.light.copyWith(
              systemNavigationBarColor: LightTheme.barColor,
            ),
          );
        }
        return true;
      },
      child: CustomScrollView(
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
      ),
    );
  }
}
