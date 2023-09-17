import 'package:fit_wallet/features/money_accounts/domain/entities/money_account_last_transaction_entity.dart';
import 'package:fit_wallet/features/money_accounts/presentation/providers/money_accounts_selector_provider.dart';
import 'package:fit_wallet/features/money_accounts/presentation/providers/providers.dart';
import 'package:fit_wallet/features/shared/domain/entities/transaction_type_entity.dart';
import 'package:fit_wallet/features/shared/presentation/widgets/widgets.dart';
import 'package:fit_wallet/features/transactions/presentation/providers/transaction_type_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class TransactionFormScreen extends StatelessWidget {
  const TransactionFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Transaction'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextFormField(
              initialValue: '0.00',
              keyboardType: TextInputType.none,
              textAlign: TextAlign.end,
              style: const TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.bold,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: '0.00',
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 1,
                  child: Selector(),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      CircleAvatar(),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Select Category'),
                          Text('Category'),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            const TransactionTypeSelector(),
            const SizedBox(height: 10),
            const Center(child: Keyboard()),
            const Divider(),
            Row(
              children: [
                const SizedBox(width: 10),
                Expanded(
                  child: SizedBox(
                    height: 40,
                    child: AsyncButton(callback: () {}, title: 'Save'),
                  ),
                ),
                const SizedBox(width: 10),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Selector extends ConsumerWidget {
  const Selector({super.key});

  void _showAccountsSelector(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return const Dialog.fullscreen(
          child: MoneyAccountsListSelector(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountSelected = ref.watch(moneyAccountSelectorProvider);

    return InkWell(
      onTap: () => _showAccountsSelector(context),
      borderRadius: BorderRadius.circular(90),
      child: Row(
        children: [
          CircleAvatar(
            child: accountSelected == null
                ? const Icon(Icons.balance_rounded)
                : Text(accountSelected.shortNameTxt),
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (accountSelected != null)
                  Flexible(
                    child: Text(
                      accountSelected.name,
                      softWrap: true,
                    ),
                  )
                else
                  const Text('Select Account'),
                const Text('Account'),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class MoneyAccountsListSelector extends ConsumerWidget {
  const MoneyAccountsListSelector({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accounts = ref.watch(moneyAccountsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(20),
          child: Text('Select an account'),
        ),
        Expanded(
          child: accounts.when(
            data: (data) {
              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (_, i) {
                  return MoneyAccountListTile(account: data[i]);
                },
              );
            },
            error: (_, __) => const Center(
              child: Text('Error'),
            ),
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ),
      ],
    );
  }
}

class MoneyAccountListTile extends ConsumerWidget {
  const MoneyAccountListTile({
    super.key,
    required this.account,
  });

  final MoneyAccountLastTransactionEntity account;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context).colorScheme;

    return ListTile(
      visualDensity: VisualDensity.standard,
      onTap: () {
        ref
            .read(moneyAccountSelectorProvider.notifier)
            .update((state) => account);
        context.pop();
      },
      leading: Container(
        height: 42,
        width: 42,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6.0),
        ),
        child: Center(
            child: Text(
          account.shortNameTxt,
          style: TextStyle(
            color: theme.onPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        )),
      ),
      title: Text(account.name),
    );
  }
}

class TransactionTypeSelector extends ConsumerWidget {
  const TransactionTypeSelector({super.key});

  Icon icon(TransactionType type) {
    switch (type) {
      case TransactionType.expense:
        return const Icon(Icons.arrow_downward_rounded);
      case TransactionType.income:
        return const Icon(Icons.arrow_upward_rounded);
      case TransactionType.transfer:
        return const Icon(CupertinoIcons.arrow_right_arrow_left);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionTypeSelected = ref.watch(transactionTypeProvider);
    return SegmentedButton(
      selectedIcon: icon(transactionTypeSelected),
      segments: const [
        ButtonSegment(value: TransactionType.income, label: Text('INCOME')),
        ButtonSegment(value: TransactionType.expense, label: Text('EXPENSE')),
        ButtonSegment(value: TransactionType.transfer, label: Text('TRANSFER')),
      ],
      selected: {transactionTypeSelected},
      onSelectionChanged: (v) {
        ref.read(transactionTypeProvider.notifier).update((state) => v.first);
      },
    );
  }
}

class Keyboard extends StatelessWidget {
  const Keyboard({super.key});

  final SliverGridDelegate _sliver =
      const SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 3,
    // crossAxisSpacing: 4,
    // mainAxisSpacing: 4,
    mainAxisExtent: 80,
  );

  @override
  Widget build(BuildContext context) {
    return GridView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: _sliver,
      children: const [
        KeyboardButton(title: '7'),
        KeyboardButton(title: '8'),
        KeyboardButton(title: '9'),
        KeyboardButton(title: '4'),
        KeyboardButton(title: '5'),
        KeyboardButton(title: '6'),
        KeyboardButton(title: '1'),
        KeyboardButton(title: '2'),
        KeyboardButton(title: '3'),
        KeyboardButton(title: '.'),
        KeyboardButton(title: '0'),
        KeyboardButton(
          child: const Icon(Icons.backspace_rounded),
        ),
      ],
    );
  }
}

class KeyboardButton extends StatelessWidget {
  const KeyboardButton({super.key, this.title, this.child});

  final String? title;
  final Widget? child;

  final TextStyle _textStyle = const TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Center(
      child: Container(
        height: 70,
        width: 110,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(90),
          color: theme.secondaryContainer,
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(90),
          onTap: () {},
          child: Center(
            child: (title != null) ? Text(title!, style: _textStyle) : child,
          ),
        ),
      ),
    );
  }
}
