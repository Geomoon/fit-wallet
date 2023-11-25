import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DebtsScreen extends ConsumerWidget {
  const DebtsScreen({Key? key}) : super(key: key);

  final padding = const EdgeInsets.symmetric(horizontal: 20.0);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.only(
          top: 10.0,
          bottom: 20.0,
        ),
        child: Center(
          child: Icon(Icons.storefront_rounded),
        ),
      ),
    );
  }
}
