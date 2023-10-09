import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:fit_wallet/config/env/env.dart';
import 'package:fit_wallet/features/shared/infrastructure/infrastructure.dart';
import 'package:fit_wallet/features/shared/presentation/presentation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final apiProvider = Provider((ref) {
  final storageService = ref.watch(localStorageProvider);
  return ApiProvider(storageService);
});

class ApiProvider {
  late final Dio _dio;
  late final LocalStorageService _storageService;

  ApiProvider(this._storageService) {
    _dio = Dio(
      BaseOptions(
        baseUrl: Env.apiUrl,
        contentType: 'application/json',
        connectTimeout: const Duration(seconds: 5),
      ),
    );

    _dio.interceptors.add(
      LogInterceptor(
        logPrint: (object) => log(object.toString()),
      ),
    );

    _dio.interceptors.add(
      _AuthInterceptor(_storageService, dio),
    );
  }

  Dio get dio => _dio;
}

class _AuthInterceptor implements Interceptor {
  _AuthInterceptor(this._storageService, this._dio);

  final LocalStorageService _storageService;
  final Dio _dio;

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    switch (err.response?.statusCode ?? 400) {
      case 401:
        if (err.requestOptions.path.contains('auth/signin') ||
            err.requestOptions.path.contains('auth/signup')) {
          handler.next(err);
          return;
        }

        final refreshToken = await _storageService.getValue('refreshToken');

        final Dio dio = Dio(BaseOptions(baseUrl: Env.apiUrl));

        final refreshResponse = await dio.post('/auth/refresh',
            options:
                Options(headers: {'Authorization': 'Bearer $refreshToken'}));

        final token = refreshResponse.data['accessToken'];
        final refresh = refreshResponse.data['refreshToken'];

        await _storageService.setValue('accessToken', token);
        await _storageService.setValue('refreshToken', refresh);

        handler.resolve(await _dio.fetch(err.requestOptions));

      case >= 400 && < 500:
        handler.next(err);
        return;
      case >= 500:
        log(err.message ?? '');
        handler.next(err);
        return;
    }
    handler.next(err);
  }

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final accessToken = await _storageService.getValue('accessToken');
    if (accessToken != null) {
      options.headers.addAll({'Authorization': 'Bearer $accessToken'});
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    handler.next(response);
  }
}
