import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:fit_wallet/features/money_accounts/domain/datasources/datasources.dart';
import 'package:fit_wallet/features/money_accounts/domain/entities/create_money_account_entity.dart';
import 'package:fit_wallet/features/money_accounts/domain/entities/money_account_entity.dart';
import 'package:fit_wallet/features/money_accounts/domain/entities/money_account_last_transaction_entity.dart';

class MoneyAccountDatasourceImpl implements MoneyAccountDatasource {
  MoneyAccountDatasourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<bool> create(CreateMoneyAccountEntity entity) async {
    Response response;

    // try {
    //   response = await _dio.post('/money-accounts');
    //   return
    // } catch (e) {

    // }
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
  Future<List<MoneyAccountEntity>> getById(String id) {
    // TODO: implement getById
    throw UnimplementedError();
  }

  @override
  Future<bool> update(String id, CreateMoneyAccountEntity entity) {
    // TODO: implement update
    throw UnimplementedError();
  }
}
