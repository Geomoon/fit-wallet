import 'package:fit_wallet/features/categories/domain/datasources/datasources.dart';
import 'package:fit_wallet/features/categories/domain/entities/category_entity.dart';
import 'package:fit_wallet/features/categories/infrastructure/mappers/mappers.dart';
import 'package:fit_wallet/features/shared/infrastructure/utils/utils.dart';
import 'package:sqflite/sqflite.dart';

class CategoriesDatasourceDb implements CategoriesDatasource {
  CategoriesDatasourceDb(this._db);

  final Database _db;
  static const String table = 'categories';

  @override
  Future<List<CategoryEntity>> getAll() async {
    final locale = Utils.locale.split('_')[0];

    final query = await _db.rawQuery(
      '''
      select cate.cate_id, cate.cate_hex_color, cate.cate_icon,
      cate.cate_is_default, cate.cate_created_at, cate.cate_updated_at,
      case when ? = 'es' then term.term_text else cate.cate_name end as cate_name
      from categories cate 
      left join terms term on term.reg_id = cate.cate_id
    ''',
      [locale],
    );

    return query.map((e) => CategoriesMapper.fromJsonDb(e)).toList();
  }
}
