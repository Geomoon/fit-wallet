import 'dart:developer';

import 'package:fit_wallet/features/auth/domain/domain.dart';
import 'package:dio/dio.dart';
import 'package:fit_wallet/features/shared/infrastructure/exceptions/exceptions.dart';

class AuthDatasourceImpl extends AuthDatasource {
  AuthDatasourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<AuthEntity> signIn(SignInEntity entity) async {
    Response response;

    try {
      response = await _dio.post('/auth/signin', data: entity);
      return AuthEntity.fromJson(response.data);
    } on DioException catch (e) {
      log('Error', error: e);
      throw AppException(e.response?.data["message"] ?? 'Error');
    } catch (e) {
      log('Error', error: e);
      throw AppException('Error');
    }
  }

  @override
  Future<AuthEntity> signUp(SignUpEntity entity) async {
    Response response;
    try {
      response = await _dio.post('/auth/signup', data: entity);
      return AuthEntity.fromJson(response.data);
    } on DioException catch (e) {
      log('Error', error: e);
      throw AppException(e.response?.data["message"] ?? 'Error');
    } catch (e) {
      log('Error', error: e);
      throw AppException('Error');
    }
  }
}
