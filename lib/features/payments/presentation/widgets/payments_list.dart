import 'package:fit_wallet/config/themes/dark_theme.dart';
import 'package:fit_wallet/features/money_accounts/domain/entities/entities.dart';
import 'package:fit_wallet/features/money_accounts/presentation/providers/money_account_by_id_provider.dart';
import 'package:fit_wallet/features/money_accounts/presentation/providers/money_accounts_get_all_provider.dart';
import 'package:fit_wallet/features/payments/domain/entities/entities.dart';
import 'package:fit_wallet/features/payments/presentation/providers/payments_pay_form_provider.dart';
import 'package:fit_wallet/features/payments/presentation/providers/payments_provider.dart';
import 'package:fit_wallet/features/shared/infrastructure/formatters/number_formatter.dart';
import 'package:fit_wallet/features/shared/presentation/presentation.dart';
import 'package:fit_wallet/features/transactions/presentation/providers/get_transactions_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class PaymentsList extends StatelessWidget {
  const PaymentsList({super.key, required this.payments});

  final List<PaymentEntity> payments;

  void _showPayDialog(BuildContext context, String id) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return BottomSheet(
          onClosing: () {},
          showDragHandle: false,
          enableDrag: false,
          builder: (context) {
            return PayDialog(id: id);
          },
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context, WidgetRef ref, String id) async {
    final deleted = await showDialog(
      context: context,
      builder: (context) {
        return ConfirmDialog(
          onConfirm: () => ref.read(paymentsProvider.notifier).delete(id),
          title: 'Delete payment',
          description: 'Are you sure to delete this payment?',
        );
      },
    );

    if (deleted == false) {
      if (context.mounted) {
        const SnackBarContent(
          title: 'Error at delete',
          tinted: true,
          type: SnackBarType.error,
        ).show(context);
      }
    }

    if (deleted == true) {
      if (context.mounted) {
        const SnackBarContent(
          title: 'Payment deleted',
          tinted: true,
          type: SnackBarType.success,
        ).show(context);
        ref.read(paymentsProvider.notifier).refetch();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    if (payments.isEmpty) {
      return SizedBox(
        height: height - 360,
        child: const Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('No payments'),
              SizedBox(width: 20),
              Icon(Icons.payment_rounded),
            ],
          ),
        ),
      );
    }

    return Consumer(builder: (context, ref, child) {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: payments.length,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) => PaymentCard(
          payment: payments[index],
          onPay: (id) => _showPayDialog(context, payments[index].id),
          onDelete: (id) => _showDeleteDialog(context, ref, id),
        ),
      );
    });
  }
}

class PaymentCard extends StatelessWidget {
  const PaymentCard({
    super.key,
    required this.payment,
    required this.onPay,
    required this.onDelete,
  });

  final Function(String id) onPay;
  final Function(String id) onDelete;

  final PaymentEntity payment;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).primaryTextTheme;
    final theme = Theme.of(context).colorScheme;
    final cardColor = Theme.of(context).cardTheme;

    return ExpansionTile(
      controlAffinity: ListTileControlAffinity.trailing,
      tilePadding: const EdgeInsets.only(right: 10),
      childrenPadding: EdgeInsets.zero,
      trailing: ElevatedButton(
        onPressed: payment.isCompleted ? null : () => onPay(payment.id),
        child: payment.isCompleted
            ? const Icon(Icons.done_rounded)
            : const Icon(Icons.credit_score_rounded),
      ),
      title: _PaymentCardContent(payment: payment, textTheme: textTheme),
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      expandedAlignment: Alignment.centerLeft,
      iconColor: theme.onBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Theme.of(context).colorScheme.outline),
      ),
      collapsedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(width: 1, color: Colors.transparent),
      ),
      backgroundColor: cardColor.surfaceTintColor,
      children: [
        Container(
          decoration: BoxDecoration(
            color: DarkTheme.barColor,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (payment.description.isNotEmpty) Text(payment.description),
              if (payment.description.isNotEmpty) const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  EditCardBackground(onDelete: () {}),
                  DeleteCardBackground(onDelete: () => onDelete(payment.id)),
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}

class _PaymentCardContent extends StatelessWidget {
  const _PaymentCardContent({
    required this.payment,
    required this.textTheme,
  });

  final PaymentEntity payment;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.only(top: 10, bottom: 10, left: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                payment.amountTxt,
                style: textTheme.titleLarge?.copyWith(
                    decoration: payment.isCompleted
                        ? TextDecoration.lineThrough
                        : null),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  if (payment.description.isNotEmpty)
                    const Icon(Icons.comment_outlined, size: 18),
                  if (payment.description.isNotEmpty) const SizedBox(width: 10),
                  if (payment.date != null)
                    const Icon(Icons.access_time_rounded, size: 18),
                  if (payment.date != null) const SizedBox(width: 10),
                  if (payment.date != null)
                    if (payment.hasPriority)
                      Badge(
                        backgroundColor: theme.error,
                        label: Text(payment.dateTxt,
                            style: textTheme.bodyLarge
                                ?.copyWith(color: theme.onError)),
                        textColor: theme.onError,
                        largeSize: 20,
                      )
                    else
                      Text(payment.dateTxt, style: textTheme.bodyLarge),
                ],
              ),
            ],
          ),
          const Spacer(),
        ],
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      elevation: 0,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onDelete,
        child: SizedBox(
          height: 36,
          width: 100,
          child: Icon(
            Icons.drive_file_rename_outline_rounded,
            color: theme.onSurface,
          ),
        ),
      ),
    );
  }
}

class DeleteCardBackground extends StatelessWidget {
  const DeleteCardBackground({super.key, required this.onDelete});

  final Function() onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      color: theme.error,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onDelete,
        child: SizedBox(
          height: 36,
          width: 100,
          child: Icon(
            Icons.backspace_rounded,
            color: theme.onError,
          ),
        ),
      ),
    );
  }
}

class PayDialog extends ConsumerWidget {
  const PayDialog({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final color = Theme.of(context).colorScheme.onBackground;
    final size = MediaQuery.of(context).viewInsets.bottom;

    final textTheme = Theme.of(context).primaryTextTheme;

    final payProvider = ref.watch(paymentsPayFormProvider(id));

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: 10,
            bottom: 20,
            left: 10,
            right: 20,
          ),
          child: Row(
            children: [
              CloseButton(color: color),
              const SizedBox(width: 10),
              Text(
                'Pay',
                style: textTheme.headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              AsyncButton(
                isLoading: payProvider.isSaving,
                callback: () async {
                  final saved = await ref
                      .read(paymentsPayFormProvider(id).notifier)
                      .save();

                  if (saved && context.mounted) {
                    ref.invalidate(paymentsProvider);
                    ref.invalidate(moneyAccountsProvider);
                    ref.invalidate(getTransactionsProvider);
                    if (payProvider.account != null) {
                      ref.invalidate(
                          moneyAccountByIdProvider(payProvider.account!.id));
                    }
                    const SnackBarContent(
                      title: 'Saved',
                      tinted: true,
                      type: SnackBarType.success,
                    ).show(context);
                    context.pop();
                  } else if (context.mounted) {
                    const SnackBarContent(
                      title: 'Something went wrong...',
                      tinted: true,
                      type: SnackBarType.error,
                    ).show(context);
                    context.pop();
                  }
                },
                child: const Icon(Icons.done_rounded),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            top: 10,
            bottom: size + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (payProvider.payment != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _ValueInput(
                    initialValue: payProvider.payment?.amount ?? 0,
                    onChanged: ref
                        .read(paymentsPayFormProvider(id).notifier)
                        .changeValue,
                    errorMessage: payProvider.value.errorMessage,
                  ),
                ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.only(left: 20, bottom: 10),
                child: Text('Select an account'),
              ),
              MoneyAccountsSelector(
                id: id,
                onSelect: ref
                    .read(paymentsPayFormProvider(id).notifier)
                    .changeAccount,
              ),
              // if (payProvider.payment != null)
              //   _ValueInput(
              //     initialValue: payProvider.payment?.amount ?? 0,
              //     onChanged: ref
              //         .read(paymentsPayFormProvider(id).notifier)
              //         .changeValue,
              //     errorMessage: payProvider.value.errorMessage,
              //   ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ValueInput extends StatelessWidget {
  const _ValueInput({
    required this.initialValue,
    this.errorMessage,
    this.onChanged,
  });

  final double initialValue;
  final String? errorMessage;

  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).primaryTextTheme;

    return TextFormField(
      initialValue: initialValue == 0 ? null : initialValue.toString(),
      keyboardType: TextInputType.number,
      textAlign: TextAlign.end,
      inputFormatters: [
        FilteringTextInputFormatter.deny('-'),
        FilteringTextInputFormatter.deny(' '),
        FilteringTextInputFormatter.deny(
          '..',
          replacementString: '.',
        ),
        CurrencyNumberFormatter(),
      ],
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: textTheme.bodyMedium?.color,
      ),
      decoration: const InputDecoration(
        hintText: '0.00',
        icon: Icon(Icons.attach_money_rounded),
        errorText: null,
      ),
      textInputAction: TextInputAction.next,
      onChanged: onChanged,
    );
  }
}

class MoneyAccountsSelector extends ConsumerWidget {
  const MoneyAccountsSelector({
    super.key,
    required this.id,
    required this.onSelect,
  });

  final String id;
  final void Function(MoneyAccountLastTransactionEntity) onSelect;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accounts = ref.watch(moneyAccountsProvider);

    final selected =
        ref.watch(paymentsPayFormProvider(id).select((value) => value.account));

    return accounts.when(
      data: (data) {
        return SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(right: 20, left: 10),
            itemCount: data.length,
            itemBuilder: (context, index) {
              return _MoneyAccountCardSelector(
                account: data[index],
                isSelected: selected?.id == data[index].id,
                onSelect: onSelect,
              );
            },
          ),
        );
      },
      error: (error, stackTrace) => const Center(
        child: Text('Error loading accounts'),
      ),
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class _MoneyAccountCardSelector extends StatelessWidget {
  const _MoneyAccountCardSelector({
    required this.account,
    required this.onSelect,
    this.isSelected = false,
  });

  final MoneyAccountLastTransactionEntity account;
  final bool isSelected;
  final void Function(MoneyAccountLastTransactionEntity) onSelect;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).primaryTextTheme;

    return Card(
      margin: const EdgeInsets.only(left: 12),
      elevation: 0,
      shape: isSelected
          ? RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(width: 2, color: theme.primary),
            )
          : RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(width: 1, color: theme.outline),
            ),
      color: Colors.transparent,
      surfaceTintColor: theme.secondaryContainer,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => onSelect(account),
        child: SizedBox(
          height: 100,
          width: 160,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  account.amountTxt,
                  style: textTheme.titleMedium,
                ),
                const SizedBox(height: 10),
                Text(
                  account.name,
                  style: textTheme.labelLarge?.copyWith(
                      fontWeight: isSelected ? FontWeight.bold : null),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
