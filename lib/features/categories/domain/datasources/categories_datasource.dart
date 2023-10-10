import 'package:fit_wallet/features/categories/domain/entities/entities.dart';

abstract class CategoriesDatasource {
  Future<List<CategoryEntity>> getAll();
}
