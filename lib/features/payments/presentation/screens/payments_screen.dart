import 'package:fit_wallet/features/payments/domain/entities/entities.dart';
import 'package:fit_wallet/features/payments/presentation/providers/providers.dart';
import 'package:fit_wallet/features/payments/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PaymentsScreen extends StatelessWidget {
  const PaymentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const _PaymentsScreenView(),
    );
  }
}

class _PaymentsScreenView extends ConsumerWidget {
  const _PaymentsScreenView();

  final padding = const EdgeInsets.symmetric(horizontal: 20.0);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final payments = ref.watch(paymentsProvider(GetPaymentParams()));
    // final textTheme = Theme.of(context).primaryTextTheme;

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.only(
          top: 10.0,
          bottom: 20.0,
        ),
        child: payments.when(
          error: (error, stackTrace) => Center(
            child: Text(error.toString()),
          ),
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          data: (data) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Padding(
              //   padding: padding,
              //   child: Text('TOTAL', style: textTheme.bodyLarge),
              // ),
              // const SizedBox(height: 10),
              // Padding(
              //   padding: padding,
              //   child: Text(total, style: textTheme.headlineLarge),
              // ),
              // const SizedBox(height: 20),
              PaymentsList(
                payments: data,
              ),
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }
}
