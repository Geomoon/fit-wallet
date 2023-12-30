import 'package:fit_wallet/features/money_accounts/domain/entities/entities.dart';
import 'package:fit_wallet/features/money_accounts/presentation/providers/money_accounts_repository_provider.dart';
import 'package:fit_wallet/features/money_accounts/presentation/providers/providers.dart';
import 'package:fit_wallet/features/money_accounts/presentation/widgets/widgets.dart';
import 'package:fit_wallet/features/shared/presentation/providers/providers.dart';
import 'package:fit_wallet/features/shared/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FABMoneyAccount extends StatelessWidget {
  const FABMoneyAccount({super.key});

  void _showFormDialog(BuildContext context) async {
    final saved = await showModalBottomSheet<bool?>(
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

    if (saved == true) {
      if (context.mounted) {
        const SnackBarContent(
          title: 'Account saved',
          type: SnackBarType.success,
          tinted: true,
        ).show(context);
      }
    }
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

class MoneyAccountsScreen extends ConsumerWidget {
  const MoneyAccountsScreen({Key? key}) : super(key: key);

  final padding = const EdgeInsets.symmetric(horizontal: 20.0);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).primaryTextTheme;

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
                child: Text('TOTAL', style: textTheme.bodyLarge),
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
    BuildContext context,
    WidgetRef ref,
    String maccId,
  ) async {
    final confirmDelete = await showDialog<bool?>(
      context: context,
      builder: (context) {
        return ConfirmDialog(
          onConfirm: () =>
              ref.read(moneyAccountsRepositoryProvider).deleteById(maccId),
          title: 'Delete Account',
          description:
              'All transactions related to this account will be deleted',
        );
      },
    );

    if (confirmDelete == true) {
      if (context.mounted) {
        const SnackBarContent(
          title: 'Deleted',
          type: SnackBarType.success,
          tinted: true,
        ).show(context);
        ref.invalidate(moneyAccountsProvider);
        return true;
      }
    }
    return false;
  }

  void _showFormDialog(BuildContext context, String id) async {
    final saved = await showModalBottomSheet<bool?>(
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

    if (saved == true) {
      if (context.mounted) {
        const SnackBarContent(
          title: 'Account saved',
          type: SnackBarType.success,
          tinted: true,
        ).show(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
