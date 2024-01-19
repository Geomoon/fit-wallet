import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
        Text(AppLocalizations.of(context)!.welcomeToFitWallet,
            style: textTheme.headlineLarge),
        const SizedBox(height: 10),
        Text(AppLocalizations.of(context)!.fitWallet,
            style:
                textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 40),
        Text(
          AppLocalizations.of(context)!.simpleMMApp,
          style: textTheme.bodyLarge,
        ),
      ],
    );
  }
}
