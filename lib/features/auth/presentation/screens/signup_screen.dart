import 'package:flutter/material.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(child: _SignupScreenView()),
    );
  }
}

class _SignupScreenView extends StatelessWidget {
  const _SignupScreenView();

  void _showBirthdateDialog(BuildContext context) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1920),
      lastDate: DateTime.now(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

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
              ),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 20),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email',
                prefixIcon: const Icon(Icons.alternate_email_rounded),
              ),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 20),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: const Icon(Icons.password_rounded),
              ),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 20),
            TextFormField(
              readOnly: true,
              onTap: () => _showBirthdateDialog(context),
              decoration: InputDecoration(
                labelText: 'Birthdate',
                prefixIcon: const Icon(Icons.date_range_rounded),
              ),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Create account',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  )
                ],
              ),
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
