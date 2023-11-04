import 'package:fit_wallet/config/themes/dark_theme.dart';
import 'package:flutter/material.dart';

enum SnackBarType { info, error, warning, success }

class SnackBarContent extends StatelessWidget {
  const SnackBarContent({
    super.key,
    required this.title,
    this.type,
    this.tinted = false,
  });

  final String title;
  final SnackBarType? type;
  final bool tinted;

  void show(BuildContext context) {
    final entry = OverlayEntry(builder: (context) {
      return Positioned(top: 50.0, left: 0.0, right: 0.0, child: this);
    });

    Overlay.of(context).insert(entry);
    Future.delayed(const Duration(seconds: 3), () => entry.remove());
  }

  Color _colorBg(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return switch (type) {
      SnackBarType.info => Colors.white,
      SnackBarType.warning => Colors.amber.shade300,
      SnackBarType.error => colors.error,
      SnackBarType.success => DarkTheme.green,
      null => Colors.white,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        alignment: Alignment.center,
        child: Card(
          elevation: 0,
          color: tinted ? _colorBg(context) : null,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(90)),
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Padding(
            padding: const EdgeInsets.only(
              top: 12,
              bottom: 12,
              left: 18,
              right: 12,
            ),
            child: Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                      color: tinted ? Colors.black : null,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 10),
                _Icon(type: type, tinted: tinted),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Icon extends StatelessWidget {
  const _Icon({this.type, this.tinted = false});

  final SnackBarType? type;
  final bool tinted;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return switch (type) {
      SnackBarType.info => const Icon(Icons.info_rounded),
      SnackBarType.warning => const Icon(Icons.warning_rounded),
      SnackBarType.error => Icon(
          Icons.error_rounded,
          color: tinted ? Colors.black : colors.error,
        ),
      SnackBarType.success => Icon(
          Icons.check_circle_rounded,
          color: tinted ? Colors.black : DarkTheme.green,
        ),
      null => Container(),
    };
  }
}
