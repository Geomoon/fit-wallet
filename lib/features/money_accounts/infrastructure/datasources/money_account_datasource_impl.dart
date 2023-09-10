import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:fit_wallet/features/money_accounts/domain/datasources/datasources.dart';
import 'package:fit_wallet/features/money_accounts/domain/entities/create_money_account_entity.dart';
import 'package:fit_wallet/features/money_accounts/domain/entities/money_account_last_transaction_entity.dart';

class MoneyAccountDatasourceImpl implements MoneyAccountDatasource {
  MoneyAccountDatasourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<bool> create(CreateMoneyAccountEntity entity) async {
    try {
      await _dio.post('/money-accounts', data: entity);
    } catch (e) {
      log('error api', error: e);
      return false;
    }
    return true;
  }

  @override
  Future<bool> deleteById(String id) async {
    try {
      await _dio.delete('/money-accounts/$id');
      return true;
    } catch (e) {
      log('error api', error: e);
      rethrow;
    }
  }

  @override
  Future<List<MoneyAccountLastTransactionEntity>> getAll() async {
    final Response response;
    try {
      response = await _dio.get('/money-accounts');

      return (response.data as List)
          .map((e) => MoneyAccountLastTransactionEntity.fromJson(e))
          .toList();
    } catch (e) {
      log('error api', error: e);
      rethrow;
    }
  }

  @override
  Future<MoneyAccountLastTransactionEntity> getById(String id) async {
    final Response response;
    try {
      response = await _dio.get('/money-accounts/$id');

      return MoneyAccountLastTransactionEntity.fromJson(response.data);
    } catch (e) {
      log('error api', error: e);
      rethrow;
    }
  }

  @override
  Future<bool> update(String id, CreateMoneyAccountEntity entity) async {
    try {
      await _dio.patch('/money-accounts/$id', data: entity);
      return true;
    } catch (e) {
      log('error api', error: e);
      return false;
    }
  }
}
