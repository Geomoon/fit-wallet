import 'package:fit_wallet/config/themes/colorschemes/color_schemes.g.dart';
import 'package:fit_wallet/config/themes/ligth_theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:fit_wallet/config/themes/dark_theme.dart';
import 'package:fit_wallet/features/categories/presentation/providers/providers.dart';
import 'package:fit_wallet/features/categories/presentation/widgets/widgets.dart';
import 'package:fit_wallet/features/money_accounts/domain/entities/money_account_last_transaction_entity.dart';
import 'package:fit_wallet/features/money_accounts/presentation/providers/providers.dart';
import 'package:fit_wallet/features/shared/domain/entities/transaction_type_entity.dart';
import 'package:fit_wallet/features/shared/presentation/widgets/widgets.dart';
import 'package:fit_wallet/features/transactions/presentation/providers/keyboard_value_provider.dart';
import 'package:fit_wallet/features/transactions/presentation/providers/providers.dart';
import 'package:fit_wallet/features/transactions/presentation/providers/transactions_by_money_account_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class TransactionFormScreen extends StatelessWidget {
  const TransactionFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _TransactionFormScreen();
  }
}

class _TransactionFormScreen extends ConsumerWidget {
  const _TransactionFormScreen();

  final TextStyle _textStyle = const TextStyle(fontWeight: FontWeight.bold);

  void submit(BuildContext context, WidgetRef ref) {
    final cateId = ref.read(categoriesSelectorProvider);
    final value = ref.watch(keyboarValueProvider).value;
    final form = ref.read(transactionFormProvider.notifier);

    form.changeAmount(value);
    form.changeCateId(cateId!.id);

    final account = ref.read(transactionFormProvider).account;

    ref.read(transactionFormProvider.notifier).onSubmit().then((value) {
      if (value) {
        ref.invalidate(moneyAccountsProvider);
        ref.invalidate(getTransactionsProvider);
        ref.invalidate(moneyAccountByIdProvider(account!.id));
        ref.invalidate(getTransactionsFilterProvider);
        final isDark =
            MediaQuery.of(context).platformBrightness == Brightness.dark;

        if (isDark) {
          SystemChrome.setSystemUIOverlayStyle(
            SystemUiOverlayStyle.dark.copyWith(
              systemNavigationBarColor: const Color(0xff1e1e21),
            ),
          );
        } else {
          SystemChrome.setSystemUIOverlayStyle(
            SystemUiOverlayStyle.light.copyWith(
              systemNavigationBarColor: LightTheme.barColor,
            ),
          );
        }

        SnackBarContent(
          title: AppLocalizations.of(context)!.saved,
          type: SnackBarType.success,
          tinted: true,
        ).show(context);
        context.pop();
      }
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionType =
        ref.watch(transactionFormProvider.select((value) => value.type));

    final isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;

    if (isDark) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle.dark.copyWith(
          systemNavigationBarColor: darkColorScheme.background,
        ),
      );
    } else {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle.light.copyWith(
          systemNavigationBarColor: lightColorScheme.background,
        ),
      );
    }
    ref.listen<String>(transactionFormProvider.select((value) => value.error),
        (previous, next) {
      if (next != '') {
        SnackBarContent(
          title: next,
          type: SnackBarType.error,
          tinted: true,
        ).show(context);
        ref.read(transactionFormProvider.notifier).clearErrors();
      }
    });

    return WillPopScope(
      onWillPop: () async {
        if (isDark) {
          SystemChrome.setSystemUIOverlayStyle(
            SystemUiOverlayStyle.dark.copyWith(
              systemNavigationBarColor: const Color(0xff1e1e21),
            ),
          );
        } else {
          SystemChrome.setSystemUIOverlayStyle(
            SystemUiOverlayStyle.light.copyWith(
              systemNavigationBarColor: LightTheme.barColor,
            ),
          );
        }
        return true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.newTransaction,
              style: _textStyle),
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextKeyboardValue(),
                    SizedBox(height: 10, width: double.infinity),
                    BalanceChecker(),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const AddCommentButton(),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Expanded(
                    child: MoneyAccountSelector(origin: OriginType.from),
                  ),
                  const SizedBox(width: 4),
                  if (transactionType == TransactionType.transfer)
                    const SizedBox(
                        height: 48, child: Icon(CupertinoIcons.arrow_right))
                  else
                    const SizedBox(
                      width: 10,
                      height: 48,
                      child: VerticalDivider(
                        thickness: 1,
                      ),
                    ),
                  Expanded(
                    child: transactionType == TransactionType.transfer
                        ? const MoneyAccountSelector(origin: OriginType.to)
                        : const CategorySelector(),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Row(
                children: [
                  Expanded(child: TransactionTypeSelector()),
                ],
              ),
              const SizedBox(height: 26),
              const Center(child: Keyboard()),
              const SizedBox(height: 26),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: SizedBox(
                      height: 40,
                      child: Consumer(builder: (_, ref, __) {
                        return AsyncButton(
                          callback: () {
                            submit(context, ref);
                          },
                          isLoading:
                              ref.watch(transactionFormProvider).isLoading,
                          title: AppLocalizations.of(context)!.save,
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AddCommentButton extends ConsumerWidget {
  const AddCommentButton({super.key});

  void showAddCommentDialog(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      builder: (context) => BottomSheet(
        showDragHandle: false,
        enableDrag: false,
        onClosing: () {},
        builder: (context) => const AddCommentDialog(),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context).colorScheme;
    final form = ref.watch(transactionFormProvider);
    final description = ref.read(transactionFormProvider).description;

    return Row(
      children: [
        OutlinedButton.icon(
          onPressed: () => showAddCommentDialog(context),
          label: Text(
            (description?.isEmpty ?? false || form.descriptionTxt.isEmpty)
                ? AppLocalizations.of(context)!.addComment
                : form.descriptionTxt,
            style: TextStyle(color: theme.onBackground),
          ),
          icon: Icon(
            Icons.comment_rounded,
            color: theme.onBackground,
          ),
        ),
        if (description?.isNotEmpty ?? false)
          IconButton(
            onPressed: () => ref
                .read(transactionFormProvider.notifier)
                .changeDescription(''),
            icon: const Icon(Icons.close_rounded),
          ),
      ],
    );
  }
}

class AddCommentDialog extends ConsumerStatefulWidget {
  const AddCommentDialog({
    super.key,
  });

  @override
  ConsumerState createState() => _AddCommentDialogState();
}

class _AddCommentDialogState extends ConsumerState<AddCommentDialog> {
  final focus = FocusNode();
  final controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    focus.requestFocus();

    controller.text = ref.read(transactionFormProvider).description ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).primaryTextTheme;
    final size = MediaQuery.of(context).viewInsets.bottom;

    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
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
                const CloseButton(),
                const SizedBox(width: 10),
                Text(
                  AppLocalizations.of(context)!.addComment,
                  style: textTheme.headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                AsyncButton(
                  callback: () {
                    ref
                        .read(transactionFormProvider.notifier)
                        .changeDescription(controller.value.text.trim());
                    context.pop();
                  },
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
            child: TextFormField(
              controller: controller,
              focusNode: focus,
              minLines: 1,
              maxLines: 1,
              decoration: const InputDecoration(
                icon: Icon(Icons.comment_rounded),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class TextKeyboardValue extends ConsumerWidget {
  const TextKeyboardValue({
    super.key,
  });

  final TextStyle _textStyle = const TextStyle(
    fontSize: 54,
    fontWeight: FontWeight.bold,
  );

  void _changeValueForm(WidgetRef ref, double value) {
    ref.read(transactionFormProvider.notifier).changeAmount(value);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final keyboarValue = ref.watch(keyboarValueProvider);
    final textTheme = Theme.of(context).primaryTextTheme;

    ref.listen(
      keyboarValueProvider.select((value) => value.value),
      (previous, next) => _changeValueForm(ref, next),
    );

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      reverse: true,
      child: RichText(
        softWrap: true,
        textAlign: TextAlign.end,
        text: TextSpan(
          children: [
            TextSpan(
              text: '\$ ',
              style:
                  TextStyle(fontSize: 42, color: textTheme.titleLarge!.color),
            ),
            TextSpan(
              text: keyboarValue.intTxt,
              style: TextStyle(color: textTheme.titleLarge!.color),
            ),
            TextSpan(
              text: keyboarValue.decimalTxt,
              style: TextStyle(fontSize: 54, color: textTheme.bodySmall!.color),
            ),
          ],
          style: _textStyle,
        ),
      ),
    );
  }
}

class CategorySelector extends ConsumerWidget {
  const CategorySelector({super.key});

  void _showCategoriesSelector(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return const Dialog.fullscreen(
          child: CategorySelectorDialog(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categorySelected = ref.watch(categoriesSelectorProvider);
    final theme = Theme.of(context).primaryTextTheme;

    return InkWell(
      onTap: () => _showCategoriesSelector(context),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: (categorySelected == null)
                ? MainAxisAlignment.center
                : MainAxisAlignment.start,
            children: [
              if (categorySelected != null)
                Icon(categorySelected.iconData)
              else
                const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(),
                ),
              const SizedBox(width: 20),
              Flexible(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: (categorySelected == null)
                      ? CrossAxisAlignment.center
                      : CrossAxisAlignment.start,
                  children: [
                    if (categorySelected != null)
                      Flexible(
                        child: Text(
                          categorySelected.name ?? '',
                          softWrap: true,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: theme.headlineSmall?.color,
                          ),
                        ),
                      )
                    else
                      Text(
                        AppLocalizations.of(context)!.select,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: theme.headlineSmall?.color,
                        ),
                      ),
                    Text(AppLocalizations.of(context)!.category.toUpperCase(),
                        style: theme.bodyLarge),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

enum OriginType { from, to }

class MoneyAccountSelector extends ConsumerWidget {
  const MoneyAccountSelector({
    super.key,
    this.origin = OriginType.from,
  });

  final OriginType origin;

  void _showAccountsSelector(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return Dialog.fullscreen(
          child: MoneyAccountsListSelector(origin: origin),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountSelected = ref.watch(
      transactionFormProvider.select((value) {
        return (origin == OriginType.from) ? value.account : value.accountTo;
      }),
    );
    final theme = Theme.of(context).primaryTextTheme;

    return InkWell(
      onTap: () => _showAccountsSelector(context),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (accountSelected != null)
                      Flexible(
                        child: Text(
                          accountSelected.name,
                          softWrap: true,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: theme.headlineSmall?.color,
                          ),
                        ),
                      )
                    else
                      Text(AppLocalizations.of(context)!.select),
                    Text(AppLocalizations.of(context)!.account.toUpperCase(),
                        style: theme.bodyLarge),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class MoneyAccountsListSelector extends ConsumerWidget {
  const MoneyAccountsListSelector({
    super.key,
    this.origin = OriginType.from,
  });

  final OriginType origin;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accounts = ref.watch(moneyAccountsProvider);
    final selectedAccount = ref.watch(
      transactionFormProvider.select(
        (value) => origin == OriginType.from ? value.account : value.accountTo,
      ),
    );

    final textTheme = Theme.of(context).primaryTextTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: accounts.when(
            data: (data) {
              List filteredData = data;
              return ListView.builder(
                reverse: true,
                itemCount: filteredData.length,
                itemBuilder: (_, i) {
                  final isSelected = selectedAccount?.id == filteredData[i].id;
                  return MoneyAccountListTile(
                    account: filteredData[i],
                    isSelected: isSelected,
                    onTap: () {
                      if (origin == OriginType.from) {
                        ref
                            .read(transactionFormProvider.notifier)
                            .changeAccount(filteredData[i]);
                      } else {
                        ref
                            .read(transactionFormProvider.notifier)
                            .changeAccountTo(filteredData[i]);
                      }
                      context.pop();
                    },
                  );
                },
              );
            },
            error: (_, __) => Center(
              child: Text(AppLocalizations.of(context)!.sWW),
            ),
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text(AppLocalizations.of(context)!.selectAccount.toUpperCase(),
              style: textTheme.bodyLarge),
        ),
      ],
    );
  }
}

class MoneyAccountListTile extends ConsumerWidget {
  const MoneyAccountListTile({
    super.key,
    required this.account,
    required this.onTap,
    this.isSelected = false,
  });

  final MoneyAccountLastTransactionEntity account;

  final bool isSelected;
  final void Function() onTap;

  final _textStyle = const TextStyle(fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context).colorScheme;
    final isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return ListTile(
      visualDensity: VisualDensity.standard,
      dense: false,
      onTap: onTap,
      leading: Container(
        height: 44,
        width: 44,
        decoration: BoxDecoration(
          color: isSelected ? theme.primary : theme.secondaryContainer,
          borderRadius: BorderRadius.circular(isSelected ? 50 : 6.0),
        ),
        child: isSelected
            ? Center(
                child: Icon(
                  Icons.check_rounded,
                  color: isDark ? null : theme.onPrimary,
                ),
              )
            : Center(
                child: Text(
                  account.shortNameTxt,
                  style: TextStyle(
                    color: isDark ? theme.onPrimary : theme.onBackground,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
      ),
      title: Text(
        account.name,
        style: isSelected ? _textStyle : null,
      ),
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
    final transactionTypeSelected = ref.watch(transactionFormProvider);
    final width = MediaQuery.of(context).size.width;
    return SegmentedButton(
      selectedIcon: icon(transactionTypeSelected.type),
      showSelectedIcon: width >= 400,
      segments: [
        ButtonSegment(
            value: TransactionType.income,
            label: Text(AppLocalizations.of(context)!.income)),
        ButtonSegment(
            value: TransactionType.expense,
            label: Text(AppLocalizations.of(context)!.expense)),
        ButtonSegment(
            value: TransactionType.transfer,
            label: Text(AppLocalizations.of(context)!.transfer)),
      ],
      selected: {transactionTypeSelected.type},
      onSelectionChanged: (v) {
        ref.read(transactionFormProvider.notifier).changeType(v.first);
      },
    );
  }
}

class Keyboard extends ConsumerWidget {
  const Keyboard({super.key});

  final SliverGridDelegate _sliver =
      const SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 3,
    crossAxisSpacing: 10,
    mainAxisSpacing: 10,
    childAspectRatio: 2.1,
  );

  void _addDigit(WidgetRef ref, int digit) {
    ref.read(keyboarValueProvider.notifier).addValue(digit);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GridView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: _sliver,
      children: [
        KeyboardButton(
          title: '7',
          onTap: () => _addDigit(ref, 7),
        ),
        KeyboardButton(
          title: '8',
          onTap: () => _addDigit(ref, 8),
        ),
        KeyboardButton(
          title: '9',
          onTap: () => _addDigit(ref, 9),
        ),
        KeyboardButton(
          title: '4',
          onTap: () => _addDigit(ref, 4),
        ),
        KeyboardButton(
          title: '5',
          onTap: () => _addDigit(ref, 5),
        ),
        KeyboardButton(
          title: '6',
          onTap: () => _addDigit(ref, 6),
        ),
        KeyboardButton(
          title: '1',
          onTap: () => _addDigit(ref, 1),
        ),
        KeyboardButton(
          title: '2',
          onTap: () => _addDigit(ref, 2),
        ),
        KeyboardButton(
          title: '3',
          onTap: () => _addDigit(ref, 3),
        ),
        KeyboardButton(
          title: '.',
          onTap: ref.read(keyboarValueProvider.notifier).addPoint,
        ),
        KeyboardButton(
          title: '0',
          onTap: () => _addDigit(ref, 0),
        ),
        KeyboardButton(
          type: KeyboardButtonType.icon,
          child: Icons.backspace_rounded,
          onTap: ref.read(keyboarValueProvider.notifier).removeDigit,
        ),
      ],
    );
  }
}

enum KeyboardButtonType { error, normal, icon }

class KeyboardButton extends StatelessWidget {
  const KeyboardButton({
    super.key,
    this.title,
    this.child,
    this.type = KeyboardButtonType.normal,
    this.height = 60,
    this.onTap,
  });

  final String? title;
  final IconData? child;
  final KeyboardButtonType type;
  final double? height;

  final void Function()? onTap;

  final TextStyle _textStyle = const TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final color = type == KeyboardButtonType.error ? theme.error : null;
    return Center(
      child: SizedBox(
        child: type == KeyboardButtonType.icon
            ? OutlinedButton(
                onPressed: onTap,
                child: Center(
                  child: (title != null)
                      ? Text(title!, style: _textStyle)
                      : Icon(child, color: theme.onBackground),
                ),
              )
            : ElevatedButton(
                onPressed: onTap,
                child: Center(
                  child: (title != null)
                      ? Text(title!, style: _textStyle)
                      : Icon(child, color: color),
                ),
              ),
      ),
    );
  }
}

class BalanceChecker extends ConsumerWidget {
  const BalanceChecker({super.key});

  Color _bg(BuildContext context, bool? error) {
    final colors = Theme.of(context).colorScheme;
    final isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;

    if (error == null) return colors.background;

    if (error) return colors.error;

    return isDark ? DarkTheme.green : LightTheme.green;
  }

  Color _fg(BuildContext context, bool? error) {
    final colors = Theme.of(context).colorScheme;

    if (error == null) return colors.onBackground;

    if (error) return colors.onError;

    return colors.background;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = ref.watch(transactionFormProvider);
    final color = Theme.of(context).colorScheme.onBackground;

    if (form.amount.value == 0) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            form.account!.amountTxt,
            style: TextStyle(fontSize: 14, color: color),
          ),
        ],
      );
    }

    return SingleChildScrollView(
      reverse: true,
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(form.account!.amountTxt,
              style: TextStyle(fontSize: 14, color: color)),
          const SizedBox(width: 4),
          Icon(Icons.arrow_right_alt_rounded, color: color),
          const SizedBox(width: 4),
          Badge(
            backgroundColor: _bg(context, form.balanceError),
            largeSize: 20,
            label: Text(
              form.diffAmountTxt,
              style: TextStyle(
                color: _fg(context, form.balanceError),
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
