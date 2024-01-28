import 'package:fit_wallet/config/themes/ligth_theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fit_wallet/config/themes/colorschemes/color_schemes.g.dart';
import 'package:fit_wallet/config/themes/dark_theme.dart';
import 'package:fit_wallet/features/shared/infrastructure/utils/utils.dart';
import 'package:fit_wallet/features/transactions/domain/domain.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TransactionListTile extends StatelessWidget {
  const TransactionListTile({
    super.key,
    required this.transaction,
    this.isDissmisable = false,
    this.confirmDismiss,
    this.showDetails = false,
  });

  final TransactionEntity transaction;
  final bool isDissmisable;
  final bool showDetails;
  final Future<bool?> Function(DismissDirection)? confirmDismiss;

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

  Color iconColor(bool isDark) {
    switch (transaction.type) {
      case 'TRANSFER':
        return isDark ? DarkTheme.primaryFg : LightTheme.primaryFg;
      case 'EXPENSE':
        return isDark ? DarkTheme.red : LightTheme.red;
      case 'INCOME':
        return isDark ? DarkTheme.green : LightTheme.green;

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

  Icon icon(bool isDark) {
    switch (transaction.type) {
      case 'TRANSFER':
        return Icon(
          CupertinoIcons.arrow_right_arrow_left,
          size: 18,
          color: iconColor(isDark),
        );
      case 'EXPENSE':
        return Icon(
          Icons.arrow_downward_rounded,
          size: 18,
          color: iconColor(isDark),
        );
      case 'INCOME':
        return Icon(
          Icons.arrow_upward_rounded,
          size: 18,
          color: iconColor(isDark),
        );
      default:
        return Icon(
          Icons.arrow_upward_rounded,
          size: 18,
          color: iconColor(isDark),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).primaryTextTheme;
    final isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;

    if (isDissmisable) {
      return Dismissible(
        key: Key(transaction.id),
        direction: DismissDirection.endToStart,
        background: const _ListTileBg(),
        confirmDismiss: confirmDismiss,
        child: ExpansionTile(
          controlAffinity: ListTileControlAffinity.trailing,
          collapsedShape:
              Border.all(width: 0, color: Colors.transparent, strokeAlign: 0),
          shape:
              Border.all(width: 0, color: Colors.transparent, strokeAlign: 0),
          childrenPadding: EdgeInsets.zero,
          tilePadding: const EdgeInsets.only(right: 20),
          leading: null,
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
              if (transaction.moneyAccountTransfer == null)
                Text(
                  transaction.moneyAccount.name,
                  style: textTheme.bodyLarge,
                )
              else
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      transaction.moneyAccount.shortNameTxt,
                      style: textTheme.bodyLarge,
                    ),
                    const Icon(Icons.arrow_right_alt_rounded),
                    Text(
                      transaction.moneyAccountTransfer?.shortNameTxt ?? '',
                      style: textTheme.bodyLarge,
                    ),
                  ],
                )
            ],
          ),
          title: _ListTile(
            color: color,
            transaction: transaction,
            iconColorCategory: iconColorCategory,
            icon: icon(isDark),
            textTheme: textTheme,
            showValue: false,
          ),
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: isDark ? DarkTheme.barColor : LightTheme.barColor,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          transaction.description ??
                              AppLocalizations.of(context)!.noDetails,
                          softWrap: true,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      );
    }

    return _ListTile(
      color: color,
      transaction: transaction,
      iconColorCategory: iconColorCategory,
      icon: icon(isDark),
      textTheme: textTheme,
    );
  }
}

class _ListTileBg extends StatelessWidget {
  const _ListTileBg();

  final EdgeInsetsGeometry _padding = const EdgeInsets.only(right: 20);

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: _padding,
      color: colors.error,
      child: Align(
        alignment: Alignment.centerRight,
        child: Icon(Icons.backspace_rounded, color: colors.onError),
      ),
    );
  }
}

class _ListTile extends StatelessWidget {
  const _ListTile({
    required this.color,
    required this.transaction,
    required this.iconColorCategory,
    required this.icon,
    required this.textTheme,
    this.showValue = true,
  });

  final Color color;
  final TransactionEntity transaction;
  final Color iconColorCategory;
  final Icon icon;
  final TextTheme textTheme;
  final bool showValue;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      visualDensity: !showValue ? VisualDensity.compact : null,
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
      trailing: showValue
          ? Column(
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
                if (transaction.moneyAccountTransfer == null)
                  Text(
                    transaction.moneyAccount.name,
                    style: textTheme.bodyLarge,
                  )
                else
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        transaction.moneyAccount.shortNameTxt,
                        style: textTheme.bodyLarge,
                      ),
                      const Icon(Icons.arrow_right_alt_rounded),
                      Text(
                        transaction.moneyAccountTransfer?.shortNameTxt ?? '',
                        style: textTheme.bodyLarge,
                      ),
                    ],
                  )
              ],
            )
          : null,
    );
  }
}
