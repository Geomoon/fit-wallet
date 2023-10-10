import 'package:fit_wallet/features/categories/presentation/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final categoriesGetAllProvider = FutureProvider((ref) {
  final repo = ref.watch(categoriesRepositoryProvider);
  return repo.getAll();
});
