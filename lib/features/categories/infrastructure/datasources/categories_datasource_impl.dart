import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:fit_wallet/features/categories/domain/datasources/datasources.dart';
import 'package:fit_wallet/features/categories/domain/entities/category_entity.dart';
import 'package:fit_wallet/features/shared/infrastructure/exceptions/exceptions.dart';

class CategoriesDatasouceImpl extends CategoriesDatasource {
  CategoriesDatasouceImpl(this._dio);

  final Dio _dio;

  @override
  Future<List<CategoryEntity>> getAll() async {
    Response response;
    try {
      response = await _dio.get('/categories');

      return (response.data as List)
          .map((e) => CategoryEntity.fromJson(e))
          .toList();
    } catch (e) {
      log('error api', error: e);
      throw AppException('Error');
    }
  }
}
