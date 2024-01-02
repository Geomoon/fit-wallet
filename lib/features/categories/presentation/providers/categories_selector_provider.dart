import 'package:fit_wallet/features/categories/domain/entities/category_entity.dart';
import 'package:fit_wallet/features/categories/presentation/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final categoriesSelectorProvider = StateProvider.autoDispose<CategoryEntity?>(
  (ref) {
    final categories = ref.watch(categoriesGetAllProvider).asData;
    if (categories?.value.isEmpty ?? true) return null;

    return categories!.value
        .where((element) => element.isDefault == true)
        .first;
  },
);
