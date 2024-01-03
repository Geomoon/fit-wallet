import 'package:fit_wallet/features/shared/infrastructure/formatters/number_formatter.dart';
import 'package:fit_wallet/features/shared/presentation/presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PaymentsFormDialog extends StatelessWidget {
  const PaymentsFormDialog({super.key, this.id});

  final String? id;
  final _box20W = const SizedBox(width: 20);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).primaryTextTheme;
    final theme = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).viewInsets.bottom;
    final color = Theme.of(context).colorScheme.onBackground;

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
                id == null ? 'New Payment' : 'Edit Payment',
                style: textTheme.headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              AsyncButton(
                title: 'Save',
                isLoading: false,
                callback: () {
                  // ref
                  //     .read(moneyAccountFormProvider(id).notifier)
                  //     .submit()
                  //     .then((value) {
                  //   if (value) {
                  //     ref.invalidate(moneyAccountsProvider);
                  //     context.pop(true);
                  //   }
                  // });
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
              ValueInput(),
              const SizedBox(height: 20),
              NameFormField(
                initialValue: '',
                errorMessage: null,
                onChanged: (e) => {},
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton.icon(
                    onPressed: () => {},
                    label: Text(
                      'Add due date',
                      style: TextStyle(color: theme.onBackground),
                    ),
                    icon: Icon(
                      Icons.access_time_rounded,
                      // color: theme.onBackground,
                    ),
                  ),
                  if (false)
                    IconButton(
                      onPressed: () => {},
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
  });

  @override
  State<ValueInput> createState() => _ValueInputState();
}

class _ValueInputState extends State<ValueInput> {
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
      initialValue: '',
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
          color: textTheme.bodyMedium?.color),
      decoration: const InputDecoration(
        hintText: '0.00',
        icon: Icon(Icons.attach_money_rounded),
        errorText: null,
      ),
      textInputAction: TextInputAction.done,
      onChanged: (e) => {},
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
        labelText: 'Description',
        icon: const Icon(Icons.format_align_left_rounded),
        errorText: widget.errorMessage,
      ),
      textInputAction: TextInputAction.next,
      onChanged: widget.onChanged,
      style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.normal),
    );
  }
}
