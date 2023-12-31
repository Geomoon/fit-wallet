import 'package:fit_wallet/features/debts/presentation/screens/screens.dart';
import 'package:fit_wallet/features/home/presentation/providers/providers.dart';
import 'package:fit_wallet/features/money_accounts/presentation/providers/providers.dart';
import 'package:fit_wallet/features/money_accounts/presentation/screens/money_accounts_screen.dart';
import 'package:fit_wallet/features/money_accounts/presentation/widgets/widgets.dart';
import 'package:fit_wallet/features/shared/presentation/presentation.dart';
import 'package:fit_wallet/features/transactions/presentation/providers/providers.dart';
import 'package:fit_wallet/features/transactions/presentation/widgets/transaction_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class ScreenTitle extends ConsumerWidget {
  const ScreenTitle({super.key});

  final TextStyle _textStyle = const TextStyle(fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final title = ref.watch(screenTitleProvider);
    return Text(title, style: _textStyle);
  }
}

class AppBarActions extends ConsumerWidget {
  const AppBarActions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actualPage = ref.watch(homeNavigationProvider);

    switch (actualPage) {
      case 0:
        return const HomeScreenAppBarActions();
      case 1:
        return const MoneyAccountsAppBarActions();
      default:
        return Container();
    }
  }
}

class MoneyAccountsAppBarActions extends StatelessWidget {
  const MoneyAccountsAppBarActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return IconButton(
          onPressed: () =>
              ref.read(isEditModeProvider.notifier).update((state) => !state),
          icon: const Icon(Icons.edit_rounded),
        );
      },
    );
  }
}

class HomeScreenAppBarActions extends StatelessWidget {
  const HomeScreenAppBarActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          height: 36,
          width: 36,
          child: IconButton(
            onPressed: () {
              context.push('/settings');
            },
            icon: const Icon(Icons.settings_rounded),
          ),
        ),
        const SizedBox(width: 10),
      ],
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  final List<Widget> _screens = const [
    _HomeScreenView(),
    MoneyAccountsScreen(),
    DebtsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        title: const ScreenTitle(),
        actions: const [AppBarActions()],
      ),
      body: _HomeView(screens: _screens),
      bottomNavigationBar: const BottomAppBar(
        height: 80,
        padding: EdgeInsets.symmetric(vertical: 2, horizontal: 20),
        child: Row(
          children: [
            NavigationButton(
              index: 0,
              icon: Icons.vertical_split_outlined,
              activeIcon: Icons.vertical_split_rounded,
              title: 'Home',
            ),
            SizedBox(width: 24),
            NavigationButton(
              index: 1,
              icon: Icons.account_balance_outlined,
              activeIcon: Icons.account_balance_rounded,
              title: 'Accounts',
            ),
            SizedBox(width: 24),
            NavigationButton(
              index: 2,
              icon: Icons.payment_outlined,
              activeIcon: Icons.payment_rounded,
              title: 'Payments',
            ),
          ],
        ),
      ),
      floatingActionButton: const FAButtons(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}

class FAButtons extends ConsumerWidget {
  const FAButtons({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actualPage = ref.watch(homeNavigationProvider);

    final accounts = ref.watch(moneyAccountsProvider);

    switch (actualPage) {
      case 0:
        return accounts.when(
          data: (data) {
            return FloatingActionButton(
              onPressed: () {
                if (data.isEmpty) {
                  const SnackBarContent(
                    title: 'Create an account first',
                    tinted: true,
                    type: SnackBarType.error,
                  ).show(context);
                  return;
                }

                context.push('/transactions/form');
              },
              child: const Icon(Icons.add_rounded),
            );
          },
          loading: () => Container(),
          error: (error, stackTrace) => Container(),
        );
      case 1:
        return const FABMoneyAccount();
      default:
        return Container();
    }
  }
}

class AccountsAppBar extends StatelessWidget {
  const AccountsAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        'Money Accounts',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      actions: [
        Consumer(
          builder: (context, ref, child) {
            return IconButton(
              onPressed: () => ref
                  .read(isEditModeProvider.notifier)
                  .update((state) => !state),
              icon: const Icon(Icons.edit_rounded),
            );
          },
        ),
      ],
    );
  }
}

class _HomeView extends ConsumerWidget {
  const _HomeView({required this.screens});

  final List<Widget> screens;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actualIndex = ref.watch(homeNavigationProvider);
    return IndexedStack(
      index: actualIndex,
      children: screens,
    );
  }
}

class NavigationButton extends ConsumerWidget {
  const NavigationButton({
    super.key,
    required this.icon,
    required this.activeIcon,
    required this.index,
    this.title,
  });

  final IconData icon;
  final IconData activeIcon;
  final int index;
  final String? title;

  final BoxConstraints _boxConstraints =
      const BoxConstraints(minWidth: 64, maxHeight: 32);

  final EdgeInsetsGeometry _padding =
      const EdgeInsets.symmetric(vertical: 4, horizontal: 20);

  void _onTap(WidgetRef ref) {
    ref.read(homeNavigationProvider.notifier).update((state) => index);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actualIndex = ref.watch(homeNavigationProvider);
    final textStyle = Theme.of(context).primaryTextTheme.labelMedium;
    final textStyleBold = Theme.of(context)
        .primaryTextTheme
        .labelMedium
        ?.copyWith(fontWeight: FontWeight.bold);

    if (index == actualIndex) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton.filledTonal(
            padding: _padding,
            constraints: _boxConstraints,
            onPressed: () => _onTap(ref),
            icon: Icon(activeIcon),
          ),
          if (title != null) Text(title!, style: textStyleBold),
        ],
      );
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          padding: _padding,
          constraints: _boxConstraints,
          onPressed: () => _onTap(ref),
          icon: Icon(icon),
        ),
        if (title != null) Text(title!, style: textStyle),
      ],
    );
  }
}

class _HomeScreenView extends StatelessWidget {
  const _HomeScreenView();

  final padding = const EdgeInsets.symmetric(horizontal: 20.0);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).primaryTextTheme;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(
          top: 10.0,
          bottom: 20.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: padding,
              child: Text('TOTAL', style: textTheme.bodyLarge),
            ),
            const SizedBox(height: 10),
            Consumer(builder: (_, ref, ___) {
              final total = ref.watch(moneyAccountsTotalProvider);

              return Padding(
                padding: padding,
                child: Text(total, style: textTheme.headlineLarge),
              );
            }),
            const SizedBox(height: 20),
            const AccountCardsViewer(),
            const SizedBox(height: 14),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('LAST TRANSACTIONS', style: textTheme.bodyLarge),
                  IconButton(
                    onPressed: () => context.push('/transactions'),
                    icon: const Icon(Icons.arrow_forward_rounded),
                  ),
                ],
              ),
            ),
            const LastTransactionsCard(),
            const SizedBox(height: 32.0),
          ],
        ),
      ),
    );
  }
}

class LastTransactionsCard extends ConsumerWidget {
  const LastTransactionsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final list = ref.watch(getTransactionsProvider);
    final textTheme = Theme.of(context).primaryTextTheme;

    return list.when(
      data: (data) {
        if (data.totalItems == 0) {
          return SizedBox(
            height: 300,
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/images/empty_list.svg',
                ),
                Text('No transactions', style: textTheme.bodyMedium),
              ],
            ),
          );
        }

        return ListView.builder(
          itemCount: data.total > 10 ? 10 : data.total,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return TransactionListTile(transaction: data.items[index]);
          },
        );
      },
      error: (_, __) => Container(),
      loading: () {
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}

class AccountCardsViewer extends ConsumerWidget {
  const AccountCardsViewer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final moneyAccounts = ref.watch(moneyAccountsProvider);

    return moneyAccounts.when(
      data: (accounts) {
        if (accounts.isEmpty) {
          return const SizedBox(
            height: 120,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('No accounts'),
                  SizedBox(width: 20),
                  Icon(Icons.account_balance_rounded),
                ],
              ),
            ),
          );
        }

        return SizedBox(
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: accounts.length,
            itemBuilder: (context, index) {
              final account = accounts[index];
              return Hero(
                tag: account.id,
                flightShuttleBuilder: (_, __, ___, ____, toHeroContext) {
                  // this fix overflow
                  return SingleChildScrollView(child: toHeroContext.widget);
                },
                child: SizedBox(
                  width: 260,
                  child: MoneyAccountCard(
                    isTwoLines: true,
                    account: account,
                    onTap: () => context.push('/money-accounts/${account.id}'),
                  ),
                ),
              );
            },
          ),
        );
      },
      error: (_, __) => Container(),
      loading: () => Container(),
    );
  }
}
