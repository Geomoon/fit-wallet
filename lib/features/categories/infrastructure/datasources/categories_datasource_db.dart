import 'package:fit_wallet/features/categories/domain/datasources/datasources.dart';
import 'package:fit_wallet/features/categories/domain/entities/category_entity.dart';
import 'package:fit_wallet/features/categories/infrastructure/mappers/mappers.dart';
import 'package:sqflite/sqflite.dart';

class CategoriesDatasourceDb implements CategoriesDatasource {
  CategoriesDatasourceDb(this._db);

  final Database _db;
  static const String table = 'categories';

  @override
  Future<List<CategoryEntity>> getAll() async {
    final query = await _db.query(table, where: 'cate_deleted_at is null');

    return query.map((e) => CategoriesMapper.fromJsonDb(e)).toList();
  }
}
