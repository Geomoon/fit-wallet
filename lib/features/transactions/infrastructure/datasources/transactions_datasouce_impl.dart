import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:fit_wallet/features/shared/domain/entities/pagination_entity.dart';
import 'package:fit_wallet/features/transactions/domain/domain.dart';

class TransactionsDatasourceImpl extends TransactionsDatasource {
  TransactionsDatasourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<void> create(CreateTransactionEntity entity) async {
    try {
      await _dio.post('/transactions', data: entity);
    } catch (e) {
      log('error api', error: e);
      rethrow;
    }
  }

  @override
  Future<void> delete(String id) async {
    try {
      await _dio.delete('/transactions/$id');
    } catch (e) {
      log('error api', error: e);
      rethrow;
    }
  }

  @override
  Future<PaginationEntity<TransactionEntity>> getAll(
    GetTransactionsParams params,
  ) async {
    final Response response;
    try {
      response =
          await _dio.get('/transactions', queryParameters: params.toJson());

      return PaginationEntity.fromJson(
          response.data, TransactionEntity.fromJson);
    } catch (e) {
      log('error api', error: e);
      rethrow;
    }
  }

  @override
  Future<TransactionEntity> getById(String id) async {
    final Response response;

    try {
      response = await _dio.get('/transactions/$id');
      return TransactionEntity.fromJson(response.data);
    } catch (e) {
      log('error api', error: e);
      rethrow;
    }
  }
}
