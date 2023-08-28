import 'package:fit_wallet/config/themes/dark_theme.dart';
import 'package:fit_wallet/config/themes/theme_provider.dart';
import 'package:fit_wallet/features/shared/presentation/presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Wallet',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          SizedBox(
            height: 36,
            width: 36,
            child: IconButton.filledTonal(
              onPressed: () {},
              icon: const Icon(Icons.settings_rounded),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: const _HomeScreenView(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: const Text('Add'),
        icon: const Icon(Icons.add_rounded),
      ),
    );
  }
}

class _HomeScreenView extends StatelessWidget {
  const _HomeScreenView();

  final padding = const EdgeInsets.symmetric(horizontal: 20.0);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

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
              child: Text('Total', style: textTheme.bodyLarge),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: padding,
              child: Text('\$450.67', style: textTheme.headlineLarge),
            ),
            const SizedBox(height: 20),
            const AccountCardsViewer(),
            const SizedBox(height: 14),
            Padding(
              padding: padding,
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    child: const Icon(Icons.account_balance_rounded),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Icon(Icons.account_balance_rounded),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Icon(Icons.account_balance_rounded),
                  ),
                ],
              ),
            ),
            Padding(
              padding: padding,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Last transactions'),
                  IconButton(
                    onPressed: () {},
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
    final textTheme = Theme.of(context).textTheme;
    final theme = Theme.of(context).colorScheme;
    final themeMode = ref.watch(themeModeProvider);

    print(theme.secondary);

    return Card(
      surfaceTintColor: themeMode == ThemeMode.dark
          ? DarkTheme.primaryBg
          : Colors.white, // TODO: light mode
      color: themeMode == ThemeMode.dark ? DarkTheme.secondaryBg : Colors.white,
      margin: const EdgeInsets.symmetric(
        horizontal: 10.0,
        vertical: 4.0,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return ListTile(
              visualDensity: VisualDensity.comfortable,
              onTap: () {},
              leading: Container(
                height: 44,
                width: 44,
                decoration: BoxDecoration(
                  color: theme.background,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Icon(Icons.local_gas_station_rounded),
                ),
              ),
              title: const Text('Car gasoline'),
              subtitle: Text('Yesterday', style: textTheme.bodyLarge),
              trailing: const Text(
                '- \$45.00',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            );
          },
          separatorBuilder: (context, index) {
            return const Divider(indent: 68, height: 1);
          },
          itemCount: 4,
        ),
      ),
    );
  }
}

class AccountCardsViewer extends StatelessWidget {
  const AccountCardsViewer({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = PageController(viewportFraction: .9);

    return SizedBox(
      height: 180,
      child: PageView.builder(
        controller: controller,
        itemCount: 2,
        itemBuilder: (context, index) {
          return const AccountCard();
        },
      ),
    );
  }
}

class AccountCard extends StatelessWidget {
  const AccountCard({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final theme = Theme.of(context).colorScheme;

    print(theme.primary);
    print(theme.onPrimary);
    return Card(
      margin: const EdgeInsets.only(right: 20),
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
