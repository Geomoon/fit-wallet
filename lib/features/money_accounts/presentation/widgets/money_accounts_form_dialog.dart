import 'package:fit_wallet/features/money_accounts/presentation/providers/money_account_form_provider.dart';
import 'package:fit_wallet/features/money_accounts/presentation/providers/money_accounts_get_all_provider.dart';
import 'package:fit_wallet/features/shared/infrastructure/formatters/formatters.dart';
import 'package:fit_wallet/features/shared/presentation/widgets/widgets.dart';
import 'package:fit_wallet/features/transactions/presentation/providers/get_transactions_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class MoneyAccountForm extends ConsumerWidget {
  const MoneyAccountForm({super.key, this.id});

  final String? id;
  final _box20W = const SizedBox(width: 20);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).primaryTextTheme;
    final size = MediaQuery.of(context).viewInsets.bottom;
    final color = Theme.of(context).colorScheme.onBackground;

    final service = ref.watch(moneyAccountFormProvider(id));

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
                id == null ? 'New Account' : 'Edit account',
                style: textTheme.headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              AsyncButton(
                title: 'Save',
                isLoading: service.isPosting,
                callback: () {
                  ref
                      .read(moneyAccountFormProvider(id).notifier)
                      .submit()
                      .then((value) {
                    if (value) {
                      ref.invalidate(moneyAccountsProvider);
                      ref.invalidate(getTransactionsProvider);
                      context.pop(true);
                    }
                  });
                },
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NameFormField(
                initialValue: service.name.value,
                errorMessage: service.name.errorMessage,
                onChanged: ref
                    .read(moneyAccountFormProvider(id).notifier)
                    .onNameChange,
              ),
              const SizedBox(height: 20),
              TextFormField(
                initialValue: service.value.value.toString(),
                keyboardType: TextInputType.number,
                textAlign: TextAlign.end,
                inputFormatters: [
                  FilteringTextInputFormatter.deny('-'),
                  FilteringTextInputFormatter.deny(' '),
                  FilteringTextInputFormatter.deny('..',
                      replacementString: '.'),
                  CurrencyNumberFormatter(),
                ],
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: textTheme.bodyMedium?.color),
                decoration: InputDecoration(
                  hintText: '0.00',
                  icon: const Icon(Icons.attach_money_rounded),
                  errorText: service.value.errorMessage,
                ),
                textInputAction: TextInputAction.done,
                onChanged: ref
                    .read(moneyAccountFormProvider(id).notifier)
                    .onValueChange,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('Set as favorite', style: textTheme.bodyLarge),
                  _box20W,
                  Switch.adaptive(
                    value: service.order.value == 0,
                    onChanged: (value) {
                      ref
                          .read(moneyAccountFormProvider(id).notifier)
                          .onOrderChange(value ? 0 : 1);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class NameFormField extends StatefulWidget {
  const NameFormField({
    super.key,
    required this.initialValue,
    required this.onChanged,
    this.errorMessage,
  });

  final String initialValue;
  final String? errorMessage;

  final void Function(String)? onChanged;

  @override
  State<NameFormField> createState() => _NameFormFieldState();
}

class _NameFormFieldState extends State<NameFormField> {
  final focus = FocusNode();

  @override
  void initState() {
    super.initState();
    focus.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).primaryTextTheme;

    return TextFormField(
      focusNode: focus,
      initialValue: widget.initialValue,
      decoration: InputDecoration(
        labelText: 'Account Name',
        icon: const Icon(Icons.account_balance_rounded),
        errorText: widget.errorMessage,
      ),
      textInputAction: TextInputAction.next,
      onChanged: widget.onChanged,
      style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.normal),
    );
  }
}
