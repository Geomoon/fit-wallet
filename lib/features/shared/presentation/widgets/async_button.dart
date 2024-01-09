import 'package:flutter/material.dart';

class AsyncButton extends StatelessWidget {
  const AsyncButton({
    super.key,
    required this.callback,
    this.title,
    this.child,
    this.isLoading = false,
  });

  final bool isLoading;
  final void Function() callback;
  final String? title;
  final Widget? child;

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
          : title != null
              ? Text(
                  title!,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                )
              : child,
    );
  }
}
