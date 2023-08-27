import 'package:fit_wallet/features/auth/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: _SigningScreenView());
  }
}

class _SigningScreenView extends StatelessWidget {
  const _SigningScreenView();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        children: [
          Image(
            opacity: const AlwaysStoppedAnimation(.8),
            image: const AssetImage('assets/images/bg_v7.jpg'),
            fit: BoxFit.cover,
            width: double.infinity,
            height: size.height / 3,
          ),
          const LoginFormView(),
          const _Signup(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _Signup extends StatelessWidget {
  const _Signup();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20.0, bottom: 10.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextButton(
            onPressed: () => context.push('/signup'),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Sign up'),
              ],
            ),
          ),
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
    );
  }
}

class ImageBG extends StatelessWidget {
  const ImageBG({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          constraints: const BoxConstraints.tightForFinite(),
          child: const Image(
            opacity: AlwaysStoppedAnimation(.8),
            image: AssetImage('assets/images/bg_v7.jpg'),
            fit: BoxFit.cover,
          ),
        ),
      ],
    );
  }
}

class LoginFormView extends ConsumerWidget {
  const LoginFormView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final service = ref.watch(authSignInProvider);

    return Padding(
      padding: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),
          Text('FitWallet', style: textTheme.headlineLarge),
          const SizedBox(height: 20),
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            onChanged: ref.read(authSignInProvider.notifier).onChangeEmail,
            decoration: InputDecoration(
              labelText: 'Email',
              prefixIcon: const Icon(Icons.alternate_email_rounded),
              errorText: service.isPosted ? service.email.errorMessage : null,
            ),
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 20),
          TextFormField(
            obscureText: true,
            textInputAction: TextInputAction.go,
            onChanged: ref.read(authSignInProvider.notifier).onChangePassword,
            decoration: InputDecoration(
              labelText: 'Password',
              prefixIcon: const Icon(Icons.password_rounded),
              errorText:
                  service.isPosted ? service.password.errorMessage : null,
            ),
          ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: !service.isPosting
                ? () {
                    ref.read(authSignInProvider.notifier).onSubmit();
                  }
                : null,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                service.isPosting
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator())
                    : const Text('Login',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
