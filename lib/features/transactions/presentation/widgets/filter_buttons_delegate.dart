import 'package:fit_wallet/features/money_accounts/presentation/presentation.dart';
import 'package:fit_wallet/features/shared/presentation/widgets/clear_filters_button.dart';
import 'package:fit_wallet/features/shared/presentation/widgets/filter_button.dart';
import 'package:flutter/material.dart';

class FilterButtonsDelegate extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final colors = Theme.of(context).colorScheme.background;
    return Container(
      color: colors,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: const Row(
        children: [
          SizedBox(width: 10),
          FilterButton(),
          SizedBox(width: 10),
          TransactionTypeFilterButton(),
          Spacer(),
          ClearFiltersButton(),
          SizedBox(width: 10),
        ],
      ),
    );
  }

  @override
  double get maxExtent => 68;

  @override
  double get minExtent => 68;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}
