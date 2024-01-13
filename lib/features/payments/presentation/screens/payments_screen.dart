import 'package:fit_wallet/config/themes/themes.dart';
import 'package:fit_wallet/features/payments/domain/entities/get_payment_params.dart';
import 'package:fit_wallet/features/payments/presentation/providers/providers.dart';
import 'package:fit_wallet/features/payments/presentation/widgets/widgets.dart';
import 'package:fit_wallet/features/shared/infrastructure/infrastructure.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class PaymentsScreen extends StatelessWidget {
  const PaymentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _PaymentsScreenView();
  }
}

class _PaymentsScreenView extends ConsumerWidget {
  const _PaymentsScreenView();

  final padding = const EdgeInsets.symmetric(horizontal: 20.0);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final payments = ref.watch(paymentsProvider);
    final textTheme = Theme.of(context).primaryTextTheme;

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Padding(
          padding: const EdgeInsets.only(
            top: 10.0,
            bottom: 20.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: padding,
                child: Text('TOTAL', style: textTheme.bodyLarge),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: padding,
                child: Text(Utils.currencyFormat(payments.total),
                    style: textTheme.headlineLarge),
              ),
              const SizedBox(height: 20),
              const FilterButtonsDelegate(),
              PaymentsList(
                payments: payments.payments,
              ),
              const SizedBox(height: 60),
            ],
          )),
    );
  }
}

class FilterButtonsDelegate extends StatelessWidget {
  const FilterButtonsDelegate({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme.background;
    return Container(
      color: colors,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: const Row(
        children: [
          SizedBox(width: 10),
          StateFilter(),
          SizedBox(width: 10),
          Spacer(),
          ClearFiltersButton(),
          SizedBox(width: 10),
        ],
      ),
    );
  }
}

class StateFilter extends ConsumerWidget {
  const StateFilter({super.key});

  void _showDialogFilter(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      builder: (context) {
        return BottomSheet(
          onClosing: () {},
          showDragHandle: false,
          enableDrag: false,
          builder: (context) {
            return const StateDialog();
          },
        );
      },
    );
  }

  IconData icon(bool? state) => switch (state) {
        true => Icons.done_rounded,
        false => Icons.circle_outlined,
        null => Icons.horizontal_rule_rounded,
      };

  String title(bool? state) => switch (state) {
        true => 'Completed',
        false => 'Pending',
        null => 'All',
      };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(paymentsProvider);
    final style = DarkTheme.primaryFilterStyle;
    return ElevatedButton(
      style: style,
      onPressed: () => _showDialogFilter(context),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title(state.params.isCompleted)),
          const SizedBox(width: 10),
          Icon(icon(state.params.isCompleted), size: 18),
        ],
      ),
    );
  }
}

class StateDialog extends ConsumerWidget {
  const StateDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).primaryTextTheme;
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Row(
              children: [
                Text(
                  'Filter By',
                  style: textTheme.titleLarge,
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          ListTile(
            leading: const Icon(Icons.horizontal_rule_rounded),
            title: const Text('All'),
            onTap: () {
              ref
                  .read(paymentsProvider.notifier)
                  .load(GetPaymentParams(isCompleted: null));
              context.pop();
            },
          ),
          ListTile(
            leading: const Icon(Icons.done_rounded),
            title: const Text('Completed'),
            onTap: () {
              ref
                  .read(paymentsProvider.notifier)
                  .load(GetPaymentParams(isCompleted: true));
              context.pop();
            },
          ),
          ListTile(
            leading: const Icon(Icons.circle_outlined),
            title: const Text('Pending'),
            onTap: () {
              ref
                  .read(paymentsProvider.notifier)
                  .load(GetPaymentParams(isCompleted: false));
              context.pop();
            },
          ),
        ],
      ),
    );
  }
}

class ClearFiltersButton extends ConsumerWidget {
  const ClearFiltersButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      onPressed: () {
        ref.read(paymentsProvider.notifier).load(GetPaymentParams());
      },
      icon: const Icon(Icons.filter_alt_off_rounded),
    );
  }
}
