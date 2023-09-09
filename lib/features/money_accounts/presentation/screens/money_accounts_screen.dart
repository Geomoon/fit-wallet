import 'package:fit_wallet/features/money_accounts/domain/entities/entities.dart';
import 'package:fit_wallet/features/money_accounts/presentation/providers/money_accounts_repository_provider.dart';
import 'package:fit_wallet/features/money_accounts/presentation/providers/providers.dart';
import 'package:fit_wallet/features/money_accounts/presentation/widgets/widgets.dart';
import 'package:fit_wallet/features/shared/infrastructure/infrastructure.dart';
import 'package:fit_wallet/features/shared/presentation/providers/providers.dart';
import 'package:fit_wallet/features/shared/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MoneyAccountsScreen extends StatelessWidget {
  const MoneyAccountsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      ),
      body: const _MoneyAccountsScreenView(),
      floatingActionButton: const FABMoneyAccount(),
    );
  }
}

class FABMoneyAccount extends StatelessWidget {
  const FABMoneyAccount({super.key});

  void _showFormDialog(BuildContext context) async {
    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return BottomSheet(
            onClosing: () {},
            showDragHandle: false,
            enableDrag: false,
            builder: (context) {
              return MoneyAccountForm();
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () => _showFormDialog(context),
      label: const Text('Add'),
      icon: const Icon(Icons.account_balance_rounded),
    );
  }
}

class MoneyAccountForm extends StatelessWidget {
  const MoneyAccountForm({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).primaryTextTheme;
    final size = MediaQuery.of(context).viewInsets.bottom;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: 10,
            bottom: 10,
            left: 10,
            right: 20,
          ),
          child: Row(
            children: [
              CloseButton(),
              const SizedBox(width: 10),
              Text(
                'New Account',
                style: textTheme.headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              Spacer(),
              FilledButton(onPressed: () {}, child: const Text('Save')),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            top: 10,
            bottom: 40 + size,
            left: 20,
            right: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Account Name',
                  icon: Icon(Icons.account_balance_rounded),
                ),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 20),
              const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 30),
                  Text('Ammount'),
                ],
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                textAlign: TextAlign.end,
                inputFormatters: [
                  FilteringTextInputFormatter.deny('-'),
                  FilteringTextInputFormatter.deny(' '),
                  FilteringTextInputFormatter.deny('..',
                      replacementString: '.'),
                  CurrencyNumberFormatter(),
                ],
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  hintText: '0.00',
                  prefixIcon: Icon(Icons.attach_money_rounded),
                  // errorText: service.value.errorMessage,
                ),
                textInputAction: TextInputAction.done,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MoneyAccountsScreenView extends ConsumerWidget {
  const _MoneyAccountsScreenView();

  final padding = const EdgeInsets.symmetric(horizontal: 20.0);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;

    final moneyAccounts = ref.watch(moneyAccountsProvider);
    final total = ref.watch(moneyAccountsTotalProvider);
    final isEditMode = ref.watch(isEditModeProvider);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(
          top: 10.0,
          bottom: 20.0,
        ),
        child: moneyAccounts.when(
          error: (error, stackTrace) => Center(
            child: Text(error.toString()),
          ),
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          data: (data) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: padding,
                child: Text('Total', style: textTheme.bodyLarge),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: padding,
                child: Text(total, style: textTheme.headlineLarge),
              ),
              const SizedBox(height: 20),
              MoneyAccountsList(
                accounts: data,
                isEditMode: isEditMode,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MoneyAccountsList extends StatelessWidget {
  const MoneyAccountsList({
    super.key,
    required this.accounts,
    required this.isEditMode,
  });

  final List<MoneyAccountLastTransactionEntity> accounts;
  final bool isEditMode;

  final EdgeInsets _cardMargin =
      const EdgeInsets.symmetric(vertical: 8, horizontal: 16);

  Widget _buildCard(
      BuildContext context, MoneyAccountLastTransactionEntity account) {
    return Row(
      children: [
        Expanded(
          child: MoneyAccountCard(
            account: account,
            margin: _cardMargin,
          ),
        ),
        if (isEditMode)
          Consumer(
            builder: (context, ref, child) => DeletedCardBackground(
              onDelete: () => _onDeleteAccount(context, ref, account.id),
            ),
          ),
      ],
    );
  }

  Future<bool> _onDeleteAccount(
      BuildContext context, WidgetRef ref, String maccId) async {
    final confirmDelete = await showDialog<bool?>(
      context: context,
      builder: (context) {
        return ConfirmDialog(
          onConfirm: () =>
              ref.read(moneyAccountsRepositoryProvider).deleteById(maccId),
          title: 'Delete Account',
        );
      },
    );

    if (confirmDelete == true) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Deleted')),
        );
        ref.invalidate(moneyAccountsProvider);
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: accounts.length,
      itemBuilder: (context, index) => _buildCard(context, accounts[index]),
    );
  }
}

class DeletedCardBackground extends StatelessWidget {
  const DeletedCardBackground({super.key, required this.onDelete});

  final Function() onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Card(
      color: theme.error,
      margin: const EdgeInsets.only(top: 8, bottom: 8, right: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(10.0),
        onTap: onDelete,
        child: SizedBox(
          height: 140,
          width: 40,
          child: Icon(
            Icons.backspace_rounded,
            color: theme.onError,
          ),
        ),
      ),
    );
  }
}
