import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WelcomePageB extends StatelessWidget {
  const WelcomePageB({
    super.key,
    required this.textTheme,
  });

  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 60),
        Expanded(
          child: SvgPicture.asset('assets/images/list_todo.svg'),
        ),
        const SizedBox(height: 30),
        Text('Simple', style: textTheme.headlineLarge),
        const SizedBox(height: 80),
        Text(
          'Record your expenses ana incomes \nquickly and easily',
          style: textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
