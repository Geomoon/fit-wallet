import 'package:fit_wallet/features/auth/presentation/providers/providers.dart';
import 'package:fit_wallet/features/money_accounts/presentation/presentation.dart';
import 'package:fit_wallet/features/shared/presentation/presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(child: _SignupScreenView()),
    );
  }
}

class _SignupScreenView extends ConsumerWidget {
  const _SignupScreenView();

  void _showDatePickerDialog(
      BuildContext context, TextEditingController controller) async {
    await showModalBottomSheet(
      context: context,
      builder: (context) {
        return Consumer(builder: (_, ref, __) {
          return CalendarPickerBottomDialog(
            title: 'Birthdate',
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
            onDateChanged: (d) {
              ref.read(signupProvider.notifier).onChangeBirthdate(d);
              context.pop();
            },
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;

    final provider = ref.watch(signupProvider);
    final controller = TextEditingController(text: provider.birthdateTxt);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text('Sign up', style: textTheme.headlineLarge),
            const SizedBox(height: 40),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Username',
                prefixIcon: const Icon(Icons.person_rounded),
                errorText: ref.read(signupProvider).username.errorMessage,
              ),
              textInputAction: TextInputAction.next,
              onChanged: ref.read(signupProvider.notifier).onChangeUsername,
            ),
            const SizedBox(height: 20),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email',
                prefixIcon: const Icon(Icons.alternate_email_rounded),
                errorText: ref.read(signupProvider).email.errorMessage,
              ),
              textInputAction: TextInputAction.next,
              onChanged: ref.read(signupProvider.notifier).onChangeEmail,
            ),
            const SizedBox(height: 20),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              obscureText: true,
              decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.password_rounded),
                  errorText: ref.read(signupProvider).password.errorMessage),
              textInputAction: TextInputAction.next,
              onChanged: ref.read(signupProvider.notifier).onChangePassword,
            ),
            const SizedBox(height: 20),
            TextFormField(
              readOnly: true,
              controller: controller,
              onTap: () => _showDatePickerDialog(context, controller),
              decoration: InputDecoration(
                  labelText: 'Birthdate',
                  prefixIcon: const Icon(Icons.date_range_rounded),
                  errorText: ref.read(signupProvider).birthdate.errorMessage),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: AsyncButton(
                    callback: ref.read(signupProvider.notifier).onSubmit,
                    title: 'Create account',
                    isLoading: provider.isPosting,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Expanded(child: Divider()),
                const SizedBox(width: 10),
                Text('or sign in with', style: textTheme.bodySmall),
                const SizedBox(width: 10),
                const Expanded(child: Divider()),
              ],
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {},
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.email),
                  SizedBox(width: 10),
                  Text('Gmail'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
