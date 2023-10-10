import 'package:fit_wallet/features/categories/domain/entities/category_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final categoriesSelectorProvider = StateProvider.autoDispose<CategoryEntity?>(
  (ref) => null,
);
