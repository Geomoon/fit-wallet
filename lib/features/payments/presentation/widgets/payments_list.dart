import 'package:fit_wallet/features/payments/domain/entities/entities.dart';
import 'package:flutter/material.dart';

class PaymentsList extends StatelessWidget {
  const PaymentsList({super.key, required this.payments});

  final List<PaymentEntity> payments;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    if (payments.isEmpty) {
      return SizedBox(
        height: height - 360,
        child: const Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('No payments'),
              SizedBox(width: 20),
              Icon(Icons.payment_rounded),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      itemCount: payments.length,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) => Text('TEXT'),
    );
  }
}
