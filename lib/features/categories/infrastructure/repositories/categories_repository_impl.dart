import 'package:fit_wallet/features/categories/domain/datasources/datasources.dart';
import 'package:fit_wallet/features/categories/domain/entities/category_entity.dart';
import 'package:fit_wallet/features/categories/domain/repositories/repositories.dart';

class CategoriesRepositoryImpl extends CategoriesRepository {
  CategoriesRepositoryImpl(this._datasource);

  final CategoriesDatasource _datasource;

  @override
  Future<List<CategoryEntity>> getAll() {
    return _datasource.getAll();
  }
}
