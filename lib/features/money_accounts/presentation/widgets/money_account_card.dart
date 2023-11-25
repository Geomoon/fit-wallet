import 'package:fit_wallet/features/money_accounts/domain/entities/entities.dart';
import 'package:fit_wallet/features/shared/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';

class MoneyAccountCard extends StatelessWidget {
  const MoneyAccountCard({
    super.key,
    required this.account,
    this.onTap,
    this.margin = const EdgeInsets.only(right: 8, left: 12),
    this.isTwoLines = false,
  });

  final EdgeInsets margin;
  final Function()? onTap;
  final bool isTwoLines;

  final MoneyAccountLastTransactionEntity account;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).primaryTextTheme;
    final theme = Theme.of(context).colorScheme;

    return Card(
      margin: margin,
      color: (account.order == 0) ? theme.primary : null,
      child: InkWell(
        onTap: onTap,
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
                  Text(account.amountTxt, style: textTheme.headlineSmall),
                  Container(
                    height: 36,
                    width: 36,
                    decoration: BoxDecoration(
                      color: (account.order == 0)
                          ? theme.onPrimary
                          : theme.primary,
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    child: Center(
                        child: Text(
                      account.shortNameTxt,
                      style: TextStyle(
                        color: (account.order == 0)
                            ? theme.background
                            : theme.onPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    )),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: DashedLine(
                color: (account.order == 0) ? theme.onPrimary : theme.outline,
                height: 2,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    account.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20.0),
                  if (isTwoLines && account.lastTransaction != null)
                    const Text('Last transaction'),
                  Text(
                    isTwoLines
                        ? account.lastTransactionTxt
                        : (account.lastTransaction != null)
                            ? 'Last transaction - ${account.lastTransactionTxt}'
                            : account.lastTransactionTxt,
                    style: (account.order == 0)
                        ? TextStyle(color: theme.onPrimary)
                        : textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
