import 'package:fit_wallet/features/payments/presentation/widgets/widgets.dart';
import 'package:fit_wallet/features/shared/presentation/presentation.dart';
import 'package:flutter/material.dart';

class FABPaymentsScreen extends StatelessWidget {
  const FABPaymentsScreen({super.key});

  void showDialog(BuildContext context) async {
    final saved = await showModalBottomSheet<bool?>(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return BottomSheet(
          onClosing: () {},
          showDragHandle: false,
          enableDrag: false,
          builder: (context) {
            return const PaymentsFormDialog();
          },
        );
      },
    );

    if (saved == true) {
      if (context.mounted) {
        const SnackBarContent(
          title: 'Payment added',
          type: SnackBarType.success,
          tinted: true,
        ).show(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () => showDialog(context),
      label: const Text('Payment'),
      icon: const Icon(Icons.add_card_rounded),
    );
  }
}
