import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fit_wallet/config/themes/dark_theme.dart';
import 'package:fit_wallet/features/money_accounts/domain/entities/entities.dart';
import 'package:fit_wallet/features/money_accounts/presentation/providers/money_account_by_id_provider.dart';
import 'package:fit_wallet/features/money_accounts/presentation/providers/money_accounts_get_all_provider.dart';
import 'package:fit_wallet/features/payments/domain/entities/entities.dart';
import 'package:fit_wallet/features/payments/presentation/providers/payments_pay_form_provider.dart';
import 'package:fit_wallet/features/payments/presentation/providers/payments_provider.dart';
import 'package:fit_wallet/features/shared/infrastructure/formatters/number_formatter.dart';
import 'package:fit_wallet/features/shared/presentation/presentation.dart';
import 'package:fit_wallet/features/transactions/presentation/providers/providers.dart';
import 'package:fit_wallet/features/transactions/presentation/widgets/widgets.dart';
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

  void _showTransactionsDialog(BuildContext context, String id) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return BottomSheet(
          onClosing: () {},
          showDragHandle: false,
          enableDrag: false,
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          builder: (context) {
            return PaymentsDetailDialog(id: id);
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
          title: AppLocalizations.of(context)!.deletePayment,
          description: AppLocalizations.of(context)!.deletePaymentDesc,
        );
      },
    );

    if (deleted == false) {
      if (context.mounted) {
        SnackBarContent(
          title: AppLocalizations.of(context)!.error,
          tinted: true,
          type: SnackBarType.error,
        ).show(context);
      }
    }

    if (deleted == true) {
      if (context.mounted) {
        SnackBarContent(
          title: AppLocalizations.of(context)!.deleted,
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
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(AppLocalizations.of(context)!.noPayments),
              const SizedBox(width: 20),
              const Icon(Icons.payment_rounded),
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
          onPay: (id) => _showPayDialog(context, id),
          onDelete: (id) => _showDeleteDialog(context, ref, id),
          onShowDetails: (id) => _showTransactionsDialog(context, id),
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
    required this.onShowDetails,
  });

  final Function(String id) onPay;
  final Function(String id) onDelete;
  final Function(String id) onShowDetails;

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
      trailing: payment.isCompleted
          ? const SizedBox(
              width: 70,
              child: Icon(
                Icons.check_circle_rounded,
                color: DarkTheme.green,
              ))
          : ElevatedButton(
              onPressed: () => onPay(payment.id),
              child: Text(AppLocalizations.of(context)!.pay),
            ),
      title: _PaymentCardContent(payment: payment, textTheme: textTheme),
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      expandedAlignment: Alignment.centerLeft,
      iconColor: theme.onBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Colors.transparent),
      ),
      collapsedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(width: 1, color: Colors.transparent),
      ),
      backgroundColor: cardColor.surfaceTintColor,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
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
                  if (payment.hasDetails)
                    MoreInfoCardBackground(
                      onDelete: () => onShowDetails(payment.id),
                    ),
                  // if (!payment.isCompleted) EditCardBackground(onDelete: () {}),
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
                  fontWeight: FontWeight.bold,
                  decoration:
                      payment.isCompleted ? TextDecoration.lineThrough : null,
                ),
              ),
              if (payment.hasDiff) const SizedBox(height: 10),
              if (payment.hasDiff)
                Row(
                  children: [
                    Text(payment.pendingAmountTxt),
                    const SizedBox(width: 10),
                    Badge(
                      backgroundColor: Colors.amber.shade100,
                      label: Text(
                        AppLocalizations.of(context)!.pending,
                        style: textTheme.labelSmall
                            ?.copyWith(color: Colors.black87),
                      ),
                    )
                  ],
                ),
              const SizedBox(height: 10),
              Row(
                children: [
                  if (payment.description.isNotEmpty)
                    const Icon(Icons.comment_outlined, size: 18),
                  if (payment.description.isNotEmpty) const SizedBox(width: 10),
                  if (payment.date != null)
                    CircleAvatar(
                      maxRadius: 9,
                      backgroundColor: payment.hasPriority
                          ? theme.error
                          : Colors.transparent,
                      child: Icon(
                        Icons.access_time,
                        size: 18,
                        color: payment.hasPriority ? theme.onError : null,
                      ),
                    ),
                  if (payment.date != null) const SizedBox(width: 10),
                  if (payment.date != null)
                    // if (payment.hasPriority)
                    //   Badge(
                    //     backgroundColor: theme.error,
                    //     label: Text(payment.dateTxt,
                    //         style: textTheme.bodyLarge
                    //             ?.copyWith(color: theme.onError)),
                    //     textColor: theme.onError,
                    //     largeSize: 20,
                    //   )
                    // else
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

class MoreInfoCardBackground extends StatelessWidget {
  const MoreInfoCardBackground({super.key, required this.onDelete});

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
          width: 60,
          child: Icon(
            Icons.list_rounded,
            color: theme.onSurface,
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      elevation: 0,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onDelete,
        child: SizedBox(
          height: 36,
          width: 60,
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
                AppLocalizations.of(context)!.pay,
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
                    SnackBarContent(
                      title: AppLocalizations.of(context)!.saved,
                      tinted: true,
                      type: SnackBarType.success,
                    ).show(context);
                    context.pop();
                  } else if (context.mounted) {
                    SnackBarContent(
                      title: AppLocalizations.of(context)!.sWW,
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
                  child: payProvider.paymentType == 0
                      ? Text(
                          payProvider.payment?.pendingAmountTxt ?? '0',
                          style: textTheme.titleLarge,
                        )
                      : _ValueInput(
                          initialValue: payProvider.payment?.pendingAmount ?? 0,
                          onChanged: ref
                              .read(paymentsPayFormProvider(id).notifier)
                              .changeValue,
                          errorMessage: payProvider.value.errorMessage,
                        ),
                ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: SegmentedButton(
                        selectedIcon: payProvider.paymentType == 0
                            ? const Icon(Icons.payment_rounded)
                            : const Icon(Icons.payments_outlined),
                        segments: [
                          ButtonSegment(
                            value: 0,
                            label: Text(AppLocalizations.of(context)!.all),
                          ),
                          ButtonSegment(
                            value: 1,
                            label:
                                Text(AppLocalizations.of(context)!.installment),
                          ),
                        ],
                        selected: {payProvider.paymentType},
                        onSelectionChanged: (s) => ref
                            .read(paymentsPayFormProvider(id).notifier)
                            .changePaymentType(s.first),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 20, bottom: 10),
                child: Text(AppLocalizations.of(context)!.selectAccount),
              ),
              MoneyAccountsSelector(
                id: id,
                onSelect: ref
                    .read(paymentsPayFormProvider(id).notifier)
                    .changeAccount,
              ),
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
      decoration: InputDecoration(
        hintText: '0.00',
        prefixIcon: const Icon(Icons.attach_money_rounded),
        labelText: AppLocalizations.of(context)!.enterValue,
        errorText: null,
      ),
      textInputAction: TextInputAction.done,
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
  final void Function(MoneyAccountLastTransactionEntity?) onSelect;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accounts = ref.watch(moneyAccountsProvider);

    final selected =
        ref.watch(paymentsPayFormProvider(id).select((value) => value.account));
    final noFunds =
        ref.watch(paymentsPayFormProvider(id).select((value) => value.noFunds));

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
                noFunds: noFunds,
                onSelect: onSelect,
              );
            },
          ),
        );
      },
      error: (error, stackTrace) => Center(
        child: Text(AppLocalizations.of(context)!.error),
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
    this.noFunds = false,
  });

  final MoneyAccountLastTransactionEntity account;
  final bool isSelected;
  final bool noFunds;
  final void Function(MoneyAccountLastTransactionEntity?) onSelect;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).primaryTextTheme;

    final textStyle = isSelected
        ? (noFunds
            ? textTheme.titleMedium?.copyWith(color: theme.error)
            : textTheme.titleMedium)
        : textTheme.titleMedium;

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
        onTap: () => onSelect(isSelected ? null : account),
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
                  style: textStyle,
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

class PaymentsDetailDialog extends ConsumerWidget {
  const PaymentsDetailDialog({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final color = Theme.of(context).colorScheme.onBackground;
    final textTheme = Theme.of(context).primaryTextTheme;
    final payProvider = ref.watch(paymentsPayFormProvider(id));

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
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
                AppLocalizations.of(context)!.payDetail,
                style: textTheme.headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        Row(
          children: [
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('TOTAL', style: textTheme.bodyLarge),
                  const SizedBox(height: 10),
                  Text(
                    payProvider.payment?.amountTxt ?? '\$0.0',
                    style: textTheme.headlineLarge,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.pending.toUpperCase(),
                    style: textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    payProvider.payment?.pendingAmountTxt ?? '\$0.0',
                    style: textTheme.headlineLarge,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 20),
          ],
        ),
        const SizedBox(height: 20),
        if (payProvider.payment != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(AppLocalizations.of(context)!.payments,
                style: textTheme.bodyLarge),
          ),
        if (payProvider.payment != null)
          Expanded(
            child: PaymentTransactionsList(paymId: payProvider.payment!.id),
          ),
      ],
    );
  }
}

class PaymentTransactionsList extends ConsumerWidget {
  const PaymentTransactionsList({super.key, required this.paymId});

  final String paymId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactions = ref.watch(transactionsByPaymentProvider(paymId));

    return transactions.when(
      data: (data) {
        if (data.items.isEmpty) return Container();

        return ListView.builder(
          shrinkWrap: true,
          itemCount: data.items.length,
          itemBuilder: (context, index) {
            return TransactionListTile(
                transaction: data.items[index], isDissmisable: false);
          },
        );
      },
      error: (error, stackTrace) {
        return Center(child: Text(AppLocalizations.of(context)!.sWW));
      },
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}
