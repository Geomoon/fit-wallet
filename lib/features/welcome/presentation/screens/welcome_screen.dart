import 'package:fit_wallet/features/welcome/presentation/providers/providers.dart';
import 'package:fit_wallet/features/welcome/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).primaryTextTheme;
    final page = ref.watch(pageProvider);
    final pageController = PageController();

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView(
              onPageChanged: (i) =>
                  ref.read(pageProvider.notifier).update((state) => i),
              controller: pageController,
              children: [
                WelcomePageA(textTheme: textTheme),
                WelcomePageB(textTheme: textTheme)
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 60),
            child: Row(
              children: [
                Expanded(child: Container()),
                const SizedBox(width: 10),
                Expanded(
                  child: FloatingActionButton.extended(
                    onPressed: () {
                      if (page == 0) {
                        ref.read(pageProvider.notifier).update((state) => 1);
                        pageController.animateToPage(
                          1,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.linear,
                        );
                      } else {
                        context.pushReplacement('/login');
                      }
                    },
                    label: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          page == 0 ? 'Next' : 'Start',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Icon(Icons.arrow_forward_rounded)
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: page == 0
                      ? TextButton(
                          onPressed: () {},
                          child: const Text('Skip'),
                        )
                      : Container(),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
