import 'package:fit_wallet/config/themes/dark_theme.dart';
import 'package:fit_wallet/features/money_accounts/domain/entities/entities.dart';
import 'package:fit_wallet/features/money_accounts/presentation/providers/money_accounts_get_all_provider.dart';
import 'package:fit_wallet/features/payments/domain/entities/entities.dart';
import 'package:fit_wallet/features/payments/presentation/widgets/widgets.dart';
import 'package:fit_wallet/features/shared/presentation/presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PaymentsList extends StatelessWidget {
  const PaymentsList({super.key, required this.payments});

  final List<PaymentEntity> payments;

  void _showPayDialog(BuildContext context, String id) async {
    await showModalBottomSheet(
      context: context,
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

    return ListView.builder(
      shrinkWrap: true,
      itemCount: payments.length,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) => PaymentCard(
        payment: payments[index],
        onPay: (id) => _showPayDialog(context, payments[index].id),
      ),
    );
  }
}

class PaymentCard extends StatelessWidget {
  const PaymentCard({
    super.key,
    required this.payment,
    required this.onPay,
  });

  final Function(String id) onPay;

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
        onPressed: () => onPay(payment.id),
        child: const Icon(Icons.credit_score_rounded),
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
                  DeleteCardBackground(onDelete: () {}),
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
    return Container(
      padding: const EdgeInsets.only(top: 10, bottom: 10, left: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(payment.amountTxt, style: textTheme.titleLarge),
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

class PayDialog extends StatelessWidget {
  const PayDialog({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.onBackground;
    final size = MediaQuery.of(context).viewInsets.bottom;
    final textTheme = Theme.of(context).primaryTextTheme;

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
              CloseButton(color: color),
              const SizedBox(width: 10),
              Text(
                'Pay',
                style: textTheme.headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              AsyncButton(
                isLoading: false,
                callback: () {},
                child: const Icon(Icons.done_rounded),
              ),
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
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ValueInput(initialValue: 10),
              SizedBox(height: 20),
              MoneyAccountsSelector(),
            ],
          ),
        ),
      ],
    );
  }
}

class MoneyAccountsSelector extends ConsumerWidget {
  const MoneyAccountsSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accounts = ref.watch(moneyAccountsProvider);

    return accounts.when(
      data: (data) {
        return SizedBox(
          height: 140,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: data.length,
            itemBuilder: (context, index) {
              return _MoneyAccountCardSelector(account: data[index]);
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
  });

  final MoneyAccountLastTransactionEntity account;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(account.name),
            const SizedBox(height: 10),
            Text(account.amountTxt),
          ],
        ),
      ),
    );
  }
}
