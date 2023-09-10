import 'package:fit_wallet/features/money_accounts/presentation/providers/money_account_form_provider.dart';
import 'package:fit_wallet/features/money_accounts/presentation/providers/money_accounts_get_all_provider.dart';
import 'package:fit_wallet/features/shared/infrastructure/formatters/formatters.dart';
import 'package:fit_wallet/features/shared/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class MoneyAccountForm extends ConsumerWidget {
  const MoneyAccountForm({super.key, this.id});

  final String? id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).primaryTextTheme;
    final size = MediaQuery.of(context).viewInsets.bottom;

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
              const CloseButton(),
              const SizedBox(width: 10),
              Text(
                'New Account',
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
                    ref.invalidate(moneyAccountsProvider);

                    context.pop();
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
              TextFormField(
                initialValue: service.name.value,
                decoration: InputDecoration(
                    labelText: 'Account Name',
                    icon: const Icon(Icons.account_balance_rounded),
                    errorText: service.name.errorMessage),
                textInputAction: TextInputAction.next,
                onChanged: ref
                    .read(moneyAccountFormProvider(id).notifier)
                    .onNameChange,
              ),
              const SizedBox(height: 20),
              // const Row(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //     SizedBox(height: 30),
              //     Text('Ammount'),
              //   ],
              // ),
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
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
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
            ],
          ),
        ),
      ],
    );
  }
}
