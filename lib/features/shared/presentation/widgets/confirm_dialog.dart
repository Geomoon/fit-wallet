import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ConfirmDialog extends StatefulWidget {
  const ConfirmDialog({
    super.key,
    required this.onConfirm,
    this.onCancel,
    this.confirmText = 'Confirm',
    this.cancelText = 'Cancel',
    required this.title,
    this.description,
    this.icon,
  });

  final String confirmText;
  final String cancelText;
  final String title;
  final String? description;
  final Icon? icon;

  /// should return true if action is succefull, otherwise false
  final Future<bool> Function() onConfirm;
  final Function()? onCancel;

  @override
  State<ConfirmDialog> createState() => _ConfirmDialogState();
}

class _ConfirmDialogState extends State<ConfirmDialog> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: AlertDialog(
        insetPadding: const EdgeInsets.all(0),
        icon: widget.icon,
        title: Text(widget.title),
        content: widget.description == null ? null : Text(widget.description!),
        actions: [
          TextButton(
            onPressed: widget.onCancel ??
                () {
                  context.pop();
                },
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              setState(() {
                isLoading = true;
              });
              final isOk = await widget.onConfirm();

              setState(() {
                isLoading = false;
              });
              if (context.mounted) context.pop(isOk);
            },
            child: isLoading
                ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(color: theme.onPrimary),
                  )
                : const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
