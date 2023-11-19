import 'package:fit_wallet/config/themes/colorschemes/color_schemes.g.dart';
import 'package:fit_wallet/config/themes/dark_theme.dart';
import 'package:fit_wallet/features/auth/presentation/providers/auth_state_provider.dart';
import 'package:fit_wallet/features/home/presentation/providers/providers.dart';
import 'package:fit_wallet/features/money_accounts/presentation/providers/providers.dart';
import 'package:fit_wallet/features/money_accounts/presentation/screens/money_accounts_screen.dart';
import 'package:fit_wallet/features/money_accounts/presentation/widgets/widgets.dart';
import 'package:fit_wallet/features/shared/infrastructure/infrastructure.dart';
import 'package:fit_wallet/features/shared/presentation/presentation.dart';
import 'package:fit_wallet/features/transactions/domain/domain.dart';
import 'package:fit_wallet/features/transactions/presentation/providers/providers.dart';
import 'package:flutter/cupertino.dart';
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
          child: Consumer(builder: (_, ref, __) {
            return IconButton(
              onPressed: () {
                ref.read(authStatusProvider.notifier).logout();
              },
              icon: const Icon(Icons.settings_rounded),
            );
          }),
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
        child: Row(
          children: [
            NavigationButton(
              index: 0,
              icon: Icons.vertical_split_outlined,
              activeIcon: Icons.vertical_split_rounded,
            ),
            SizedBox(width: 10),
            NavigationButton(
              index: 1,
              icon: Icons.account_balance_outlined,
              activeIcon: Icons.account_balance_rounded,
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

    switch (actualPage) {
      case 0:
        return FloatingActionButton(
          onPressed: () {
            context.push('/transactions/form');
          },
          child: const Icon(Icons.add_rounded),
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
  });

  final IconData icon;
  final IconData activeIcon;
  final int index;

  final BoxConstraints _boxConstraints = const BoxConstraints(minWidth: 76);

  void _onTap(WidgetRef ref) {
    ref.read(homeNavigationProvider.notifier).update((state) => index);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actualIndex = ref.watch(homeNavigationProvider);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      child: (index == actualIndex)
          ? IconButton.filledTonal(
              constraints: _boxConstraints,
              onPressed: () => _onTap(ref),
              icon: Icon(activeIcon),
            )
          : IconButton(
              constraints: _boxConstraints,
              onPressed: () => _onTap(ref),
              icon: Icon(icon)),
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
                const Text('No transactions'),
              ],
            ),
          );
        }

        return ListView.builder(
          itemCount: data.total,
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

class TransactionListTile extends StatelessWidget {
  const TransactionListTile({
    super.key,
    required this.transaction,
  });

  final TransactionEntity transaction;

  Color get color {
    switch (transaction.type) {
      case 'TRANSFER':
        return darkColorScheme.primary;
      case 'EXPENSE':
        return DarkTheme.expense;
      case 'INCOME':
        return DarkTheme.income;

      default:
        return DarkTheme.expense;
    }
  }

  Color get iconColor {
    switch (transaction.type) {
      case 'TRANSFER':
        return DarkTheme.primaryFg;
      case 'EXPENSE':
        return DarkTheme.red;
      case 'INCOME':
        return DarkTheme.green;

      default:
        return DarkTheme.primaryFg;
    }
  }

  Color get iconColorCategory {
    switch (transaction.type) {
      case 'TRANSFER':
        return darkColorScheme.onPrimary;

      default:
        return DarkTheme.primaryFg;
    }
  }

  Icon get icon {
    switch (transaction.type) {
      case 'TRANSFER':
        return Icon(
          CupertinoIcons.arrow_right_arrow_left,
          size: 18,
          color: iconColor,
        );
      case 'EXPENSE':
        return Icon(
          Icons.arrow_downward_rounded,
          size: 18,
          color: iconColor,
        );
      case 'INCOME':
        return Icon(
          Icons.arrow_upward_rounded,
          size: 18,
          color: iconColor,
        );
      default:
        return Icon(
          Icons.arrow_upward_rounded,
          size: 18,
          color: iconColor,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).primaryTextTheme;

    return ListTile(
      // visualDensity: VisualDensity.comfortable,
      onTap: () {},
      leading: Container(
        height: 44,
        width: 44,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Icon(
            Utils.iconFromCategory(transaction.category.name),
            color: iconColorCategory,
          ),
        ),
      ),
      title: Row(
        children: [
          Text(transaction.category.nameTxt),
          const SizedBox(width: 10),
          icon,
        ],
      ),
      subtitle: Text(
        transaction.dateTxt,
        style: textTheme.bodyLarge,
      ),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            transaction.amountTxt,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          Text(
            transaction.moneyAccount.name,
            style: textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}

// class AccountCardsViewer extends ConsumerWidget {
//   const AccountCardsViewer({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final controller = PageController(viewportFraction: .9);
//     final moneyAccounts = ref.watch(moneyAccountsProvider);

//     return moneyAccounts.when(
//       data: (accounts) {
//         return SizedBox(
//           height: 192,
//           child: PageView.builder(
//             controller: controller,
//             itemCount: accounts.length,
//             itemBuilder: (context, index) {
//               final account = accounts[index];
//               return Hero(
//                 tag: account.id,
//                 flightShuttleBuilder: (_, __, ___, ____, toHeroContext) {
//                   // this fix overflow
//                   return SingleChildScrollView(child: toHeroContext.widget);
//                 },
//                 child: MoneyAccountCard(
//                   account: account,
//                   onTap: () => context.push('/money-accounts/${account.id}'),
//                 ),
//               );
//             },
//           ),
//         );
//       },
//       error: (_, __) => Container(),
//       loading: () => Container(),
//     );
//   }
// }

class AccountCardsViewer extends ConsumerWidget {
  const AccountCardsViewer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final moneyAccounts = ref.watch(moneyAccountsProvider);

    return moneyAccounts.when(
      data: (accounts) {
        return SizedBox(
          height: 240,
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

class AccountCard extends StatelessWidget {
  const AccountCard({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final theme = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.only(right: 16),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('\$170.23', style: textTheme.headlineSmall),
                  Container(
                    height: 36,
                    width: 36,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    child: Center(
                        child: Text(
                      'IB',
                      style: TextStyle(
                        color: theme.onPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    )),
                  ),
                ],
              ),
            ),
            DashedLine(color: theme.onPrimaryContainer),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('International Bank'),
                  const SizedBox(height: 20.0),
                  Text(
                    'Last transaction - yesterday',
                    style: textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
