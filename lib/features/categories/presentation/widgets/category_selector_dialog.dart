import 'package:fit_wallet/features/categories/domain/entities/entities.dart';
import 'package:fit_wallet/features/categories/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CategorySelectorDialog extends ConsumerWidget {
  const CategorySelectorDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accounts = ref.watch(categoriesGetAllProvider);
    final textTheme = Theme.of(context).primaryTextTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: accounts.when(
            data: (data) {
              return ListView.builder(
                padding: const EdgeInsetsDirectional.only(top: 20),
                reverse: true,
                itemCount: data.length,
                itemBuilder: (_, i) {
                  return CategoryListTile(category: data[i]);
                },
              );
            },
            error: (_, __) => const Center(
              child: Text('Error'),
            ),
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text('SELECT A CATEGORY', style: textTheme.bodyLarge),
        ),
      ],
    );
  }
}

class CategoryListTile extends ConsumerWidget {
  const CategoryListTile({
    super.key,
    required this.category,
  });

  final CategoryEntity category;

  final _textStyle = const TextStyle(fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context).colorScheme;

    final isSelected = ref.watch(categoriesSelectorProvider)?.id == category.id;

    return ListTile(
      visualDensity: VisualDensity.standard,
      dense: false,
      onTap: () {
        ref
            .read(categoriesSelectorProvider.notifier)
            .update((state) => category);
        context.pop();
      },
      leading: Container(
        height: 44,
        width: 44,
        decoration: BoxDecoration(
          color: isSelected ? theme.primary : theme.secondaryContainer,
          borderRadius: BorderRadius.circular(isSelected ? 50 : 6.0),
        ),
        child: isSelected
            ? const Center(child: Icon(Icons.check_rounded))
            : Center(child: Icon(category.iconData)),
      ),
      // trailing: CircleAvatar(
      //   maxRadius: 8,
      //   backgroundColor: category.color != null
      //       ? Color(category.color!)
      //       : theme.secondaryContainer,
      // ),
      title: Row(
        children: [
          CircleAvatar(
            maxRadius: 8,
            backgroundColor: category.color != null
                ? Color(category.color!)
                : theme.secondaryContainer,
          ),
          const SizedBox(width: 20),
          Text(
            category.nameTxt,
            style: isSelected ? _textStyle : null,
          ),
        ],
      ),
    );
  }
}
