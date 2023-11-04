import 'package:fit_wallet/features/categories/infrastructure/datasources/datasources.dart';
import 'package:fit_wallet/features/categories/infrastructure/repositories/repositories.dart';
import 'package:fit_wallet/features/shared/presentation/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final categoriesRepositoryProvider = Provider((ref) {
  final api = ref.watch(apiProvider);
  final datasource = CategoriesDatasouceImpl(api.dio);

  return CategoriesRepositoryImpl(datasource);
});