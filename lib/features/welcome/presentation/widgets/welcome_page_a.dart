import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WelcomePageA extends StatelessWidget {
  const WelcomePageA({
    super.key,
    required this.textTheme,
  });

  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        const SizedBox(height: 60),
        Expanded(
          child: SvgPicture.asset('assets/images/credit_card.svg'),
        ),
        const SizedBox(height: 30),
        Text('Welcome to', style: textTheme.headlineLarge),
        const SizedBox(height: 10),
        Text('FitWallet',
            style:
                textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 40),
        Text(
          'Simple money management app',
          style: textTheme.bodyLarge,
        ),
      ],
    );
  }
}
