import 'dart:developer';

import 'package:fit_wallet/features/auth/domain/domain.dart';
import 'package:dio/dio.dart';

class AuthDatasourceImpl extends AuthDatasource {
  AuthDatasourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<AuthEntity> signIn(SignInEntity entity) async {
    Response response;

    try {
      response = await _dio.post('/auth/signin', data: entity);
      return AuthEntity.fromJson(response.data);
    } catch (e) {
      log('Error', error: e);
      rethrow;
    }
  }

  @override
  Future<AuthEntity> signUp(SignUpEntity entity) {
    // TODO: implement signUp
    throw UnimplementedError();
  }
}
