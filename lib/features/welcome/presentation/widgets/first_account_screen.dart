import 'package:fit_wallet/features/money_accounts/domain/entities/entities.dart';
import 'package:fit_wallet/features/money_accounts/presentation/providers/money_account_form_provider.dart';
import 'package:fit_wallet/features/money_accounts/presentation/widgets/widgets.dart';
import 'package:fit_wallet/features/shared/infrastructure/formatters/number_formatter.dart';
import 'package:fit_wallet/features/shared/infrastructure/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FirstAccountScreen extends ConsumerWidget {
  const FirstAccountScreen({
    super.key,
    required this.textTheme,
  });

  final TextTheme textTheme;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final service = ref.watch(moneyAccountFormProvider(null));

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                "Let's create your first account",
                style: textTheme.headlineLarge,
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              height: 200,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: MoneyAccountCard(
                  account: MoneyAccountLastTransactionEntity(
                    id: Utils.uuid,
                    name: service.name.value,
                    amount: service.value.value,
                    userId: '',
                    createdAt: DateTime.now(),
                    order: 0,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: NameFormField(
                initialValue: service.name.value,
                errorMessage: service.name.errorMessage,
                focus: false,
                onChanged: ref
                    .read(moneyAccountFormProvider(null).notifier)
                    .onNameChange,
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: TextFormField(
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
                  labelText: 'Amount',
                  hintText: '0.00',
                  icon: const Icon(Icons.attach_money_rounded),
                  errorText: service.value.errorMessage,
                ),
                textInputAction: TextInputAction.done,
                onChanged: ref
                    .read(moneyAccountFormProvider(null).notifier)
                    .onValueChange,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
