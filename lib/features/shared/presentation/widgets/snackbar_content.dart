import 'package:flutter/material.dart';

enum SnackBarType { info, error, warning }

class SnackBarContent extends StatelessWidget {
  const SnackBarContent({
    super.key,
    required this.title,
    this.type,
  });

  final String title;
  final SnackBarType? type;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 6, bottom: 6, left: 12, right: 6),
      child: Row(
        children: [
          Expanded(child: Text(title)),
          const SizedBox(width: 10),
          _Icon(type: type),
        ],
      ),
    );
  }
}

class _Icon extends StatelessWidget {
  const _Icon({this.type});

  final SnackBarType? type;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return switch (type) {
      SnackBarType.info => const Icon(Icons.info_rounded),
      SnackBarType.warning => const Icon(Icons.warning_rounded),
      SnackBarType.error => Icon(Icons.error_rounded, color: colors.error),
      null => Container(),
    };
  }
}
