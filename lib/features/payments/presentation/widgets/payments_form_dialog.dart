import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:fit_wallet/features/money_accounts/presentation/presentation.dart';
import 'package:fit_wallet/features/payments/presentation/providers/providers.dart';
import 'package:fit_wallet/features/shared/infrastructure/formatters/number_formatter.dart';
import 'package:fit_wallet/features/shared/presentation/presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class PaymentsFormDialog extends ConsumerWidget {
  const PaymentsFormDialog({super.key, this.id});

  final String? id;

  void _showDatePickerDialog(
      BuildContext context, Function(DateTime?) onChange) async {
    final lastDate = DateTime(2200);
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      barrierColor: Colors.transparent,
      builder: (context) {
        return BottomSheet(
          onClosing: () {},
          showDragHandle: false,
          enableDrag: false,
          builder: (context) => CalendarPickerBottomDialog(
            title: AppLocalizations.of(context)!.pickADate,
            lastDate: lastDate,
            onDateChanged: onChange,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).primaryTextTheme;
    final theme = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).viewInsets.bottom;
    final color = Theme.of(context).colorScheme.onBackground;

    final provider = ref.watch(paymentFormProvider(id));

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
                id == null
                    ? AppLocalizations.of(context)!.newPayment
                    : AppLocalizations.of(context)!.editAccount,
                style: textTheme.headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              AsyncButton(
                isLoading: provider.isSaving,
                callback: () {
                  final service = ref.read(paymentFormProvider(id).notifier);
                  service.submit().then(
                    (value) {
                      if (value) {
                        context.pop(true);
                        ref.invalidate(paymentsProvider);
                        ref.invalidate(paymentsPendingProvider);
                      }
                    },
                  );
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ValueInput(
                initialValue: provider.amount.value,
                isPrimary: true,
                onChanged: (value) {
                  final service = ref.read(paymentFormProvider(id).notifier);
                  service.changeAmount(value);
                },
              ),
              const SizedBox(height: 20),
              NameFormField(
                initialValue: provider.description.value,
                errorMessage: null,
                onChanged: (e) {
                  final service = ref.read(paymentFormProvider(id).notifier);
                  service.changeDescription(e);
                },
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton.icon(
                    onPressed: () => _showDatePickerDialog(
                      context,
                      ref.read(paymentFormProvider(id).notifier).changeDueDate,
                    ),
                    label: Text(
                      provider.dueDateTxt.isEmpty
                          ? AppLocalizations.of(context)!.addDueDate
                          : provider.dueDateTxt,
                      style: TextStyle(color: theme.onBackground),
                    ),
                    icon: const Icon(Icons.access_time_rounded),
                  ),
                  if (provider.dueDate != null)
                    IconButton(
                      onPressed: ref
                          .read(paymentFormProvider(id).notifier)
                          .clearDueDate,
                      icon: const Icon(Icons.close_rounded),
                    ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}

class ValueInput extends StatefulWidget {
  const ValueInput({
    super.key,
    required this.initialValue,
    this.errorMessage,
    this.onChanged,
    this.isPrimary = false,
  });

  final double initialValue;
  final String? errorMessage;
  final bool isPrimary;

  final void Function(String)? onChanged;

  @override
  State<ValueInput> createState() => _ValueInputState();
}

class _ValueInputState extends State<ValueInput> {
  final focus = FocusNode();

  @override
  void initState() {
    super.initState();
    if (widget.isPrimary) focus.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).primaryTextTheme;

    return TextFormField(
      focusNode: focus,
      initialValue:
          widget.initialValue == 0 ? null : widget.initialValue.toString(),
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
      decoration: const InputDecoration(
        hintText: '0.00',
        icon: Icon(Icons.attach_money_rounded),
        errorText: null,
      ),
      textInputAction: TextInputAction.next,
      onChanged: widget.onChanged,
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
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).primaryTextTheme;

    return TextFormField(
      initialValue: widget.initialValue,
      decoration: InputDecoration(
        labelText: AppLocalizations.of(context)!.description,
        icon: const Icon(Icons.format_align_left_rounded),
        errorText: widget.errorMessage,
      ),
      textInputAction: TextInputAction.next,
      onChanged: widget.onChanged,
      style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.normal),
    );
  }
}
