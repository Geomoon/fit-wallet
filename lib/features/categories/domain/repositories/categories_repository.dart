import 'package:fit_wallet/features/categories/domain/entities/entities.dart';

abstract class CategoriesRepository {
  Future<List<CategoryEntity>> getAll();
}
