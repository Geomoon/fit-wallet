import 'package:fit_wallet/features/money_accounts/presentation/providers/providers.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:fit_wallet/features/money_accounts/domain/entities/entities.dart';
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
    final service = ref.watch(
      firstMoneyAccountFormProvider(AppLocalizations.of(context)!.firstAccount),
    );

    return SafeArea(
      child: service.isPosting || service.isPosted
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      AppLocalizations.of(context)!.letsCreateAccount,
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 10),
                    child: NameFormField(
                      initialValue: service.name.value.isEmpty
                          ? AppLocalizations.of(context)!.firstAccount
                          : service.name.value,
                      errorMessage: service.name.errorMessage,
                      focus: false,
                      onChanged: ref
                          .read(firstMoneyAccountFormProvider(
                                  AppLocalizations.of(context)!.firstAccount)
                              .notifier)
                          .onNameChange,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 10),
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
                          .read(firstMoneyAccountFormProvider(
                                  AppLocalizations.of(context)!.firstAccount)
                              .notifier)
                          .onValueChange,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
