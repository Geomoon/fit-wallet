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
  });

  final TransactionEntity transaction;
  final bool isDissmisable;
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

  Color get iconColor {
    switch (transaction.type) {
      case 'TRANSFER':
        return DarkTheme.primaryFg;
      case 'EXPENSE':
        return DarkTheme.red;
      case 'INCOME':
        return DarkTheme.green;

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

  Icon get icon {
    switch (transaction.type) {
      case 'TRANSFER':
        return Icon(
          CupertinoIcons.arrow_right_arrow_left,
          size: 18,
          color: iconColor,
        );
      case 'EXPENSE':
        return Icon(
          Icons.arrow_downward_rounded,
          size: 18,
          color: iconColor,
        );
      case 'INCOME':
        return Icon(
          Icons.arrow_upward_rounded,
          size: 18,
          color: iconColor,
        );
      default:
        return Icon(
          Icons.arrow_upward_rounded,
          size: 18,
          color: iconColor,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).primaryTextTheme;

    if (isDissmisable) {
      return Dismissible(
        key: Key(transaction.id),
        direction: DismissDirection.endToStart,
        background: const _ListTileBg(),
        confirmDismiss: confirmDismiss,
        child: _ListTile(
          color: color,
          transaction: transaction,
          iconColorCategory: iconColorCategory,
          icon: icon,
          textTheme: textTheme,
        ),
      );
    }

    return _ListTile(
      color: color,
      transaction: transaction,
      iconColorCategory: iconColorCategory,
      icon: icon,
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
  });

  final Color color;
  final TransactionEntity transaction;
  final Color iconColorCategory;
  final Icon icon;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      // visualDensity: VisualDensity.comfortable,
      onTap: () {},
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
          Text(
            transaction.moneyAccount.name,
            style: textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}
