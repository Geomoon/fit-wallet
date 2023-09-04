import 'package:flutter/material.dart';

class AsyncButton extends StatelessWidget {
  const AsyncButton({
    super.key,
    required this.callback,
    required this.title,
    this.isLoading = false,
  });

  final bool isLoading;
  final void Function() callback;
  final String title;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: isLoading ? null : callback,
      child: isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 3,
              ))
          : Text(title),
    );
  }
}
