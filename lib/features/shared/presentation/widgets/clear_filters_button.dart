import 'package:fit_wallet/features/shared/domain/domain.dart';
import 'package:fit_wallet/features/shared/presentation/presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ClearFiltersButton extends ConsumerWidget {
  const ClearFiltersButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      onPressed: () {
        ref
            .read(transactionTypeFilterProvider.notifier)
            .update((state) => TransactionTypeFilter.all);
        ref.read(dateFilterValueProvider.notifier).setType(DateFilter.empty);
      },
      icon: const Icon(Icons.filter_alt_off_rounded),
    );
  }
}
