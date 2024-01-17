import 'package:fit_wallet/features/auth/presentation/providers/providers.dart';
import 'package:fit_wallet/features/money_accounts/presentation/providers/money_account_form_provider.dart';
import 'package:fit_wallet/features/shared/presentation/presentation.dart';
import 'package:fit_wallet/features/welcome/presentation/providers/providers.dart';
import 'package:fit_wallet/features/welcome/presentation/widgets/first_account_screen.dart';
import 'package:fit_wallet/features/welcome/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final page = ref.watch(pageProvider);

    final textTheme = Theme.of(context).primaryTextTheme;
    final pageController = PageController();

    final isLoading = ref.watch(moneyAccountFormProvider(null));

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
                WelcomePageB(textTheme: textTheme),
                FirstAccountScreen(textTheme: textTheme),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: 10, vertical: page == 2 ? 20 : 60),
            child: Row(
              children: [
                Expanded(child: Container()),
                const SizedBox(width: 10),
                Expanded(
                  child: FloatingActionButton.extended(
                    onPressed: isLoading.isPosting || isLoading.isPosted
                        ? null
                        : () async {
                            if (page != 2) {
                              ref
                                  .read(pageProvider.notifier)
                                  .update((state) => state + 1);
                              pageController.animateToPage(
                                page + 1,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.linear,
                              );
                            } else {
                              await ref
                                  .read(moneyAccountFormProvider(null).notifier)
                                  .submit();

                              if (context.mounted) {
                                const SnackBarContent(
                                  title: 'Welcome',
                                  tinted: true,
                                  type: SnackBarType.success,
                                ).show(context);
                                await Future.delayed(
                                    const Duration(seconds: 2));
                                await ref
                                    .read(authStatusProvider.notifier)
                                    .toPassedWelcome();
                              }
                            }
                          },
                    label: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          page != 2 ? 'Next' : 'Start',
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
                  child:
                      // child: page != 2
                      //     ? TextButton(
                      //         onPressed: () async {
                      //           await ref
                      //               .read(authStatusProvider.notifier)
                      //               .toPassedWelcome();
                      //         },
                      //         child: const Text('Skip'),
                      //       )
                      //     :
                      Container(),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
