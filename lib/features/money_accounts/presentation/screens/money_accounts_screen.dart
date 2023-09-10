import 'package:fit_wallet/features/money_accounts/domain/entities/entities.dart';
import 'package:fit_wallet/features/money_accounts/presentation/providers/money_accounts_repository_provider.dart';
import 'package:fit_wallet/features/money_accounts/presentation/providers/providers.dart';
import 'package:fit_wallet/features/money_accounts/presentation/widgets/widgets.dart';
import 'package:fit_wallet/features/shared/presentation/providers/providers.dart';
import 'package:fit_wallet/features/shared/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
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
            return const MoneyAccountForm();
          },
        );
      },
    );
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
      physics: const AlwaysScrollableScrollPhysics(),
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
            mainAxisSize: MainAxisSize.min,
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
              const SizedBox(height: 60),
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
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Consumer(
                builder: (context, ref, child) => EditCardBackground(
                  onDelete: () => _showFormDialog(context, account.id),
                ),
              ),
              Consumer(
                builder: (context, ref, child) => DeletedCardBackground(
                  onDelete: () => _onDeleteAccount(context, ref, account.id),
                ),
              ),
            ],
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

  void _showFormDialog(BuildContext context, String id) async {
    await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return BottomSheet(
          onClosing: () {},
          showDragHandle: false,
          enableDrag: false,
          builder: (context) {
            return MoneyAccountForm(id: id);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: accounts.length,
      physics: const NeverScrollableScrollPhysics(),
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
          height: 40,
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

class EditCardBackground extends StatelessWidget {
  const EditCardBackground({super.key, required this.onDelete});

  final Function() onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Card(
      color: theme.surface,
      margin: const EdgeInsets.only(top: 8, bottom: 8, right: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(10.0),
        onTap: onDelete,
        child: SizedBox(
          height: 120,
          width: 40,
          child: Icon(
            Icons.drive_file_rename_outline_rounded,
            color: theme.onSurface,
          ),
        ),
      ),
    );
  }
}
