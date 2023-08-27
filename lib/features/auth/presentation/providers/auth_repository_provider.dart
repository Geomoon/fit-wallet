import 'package:fit_wallet/features/auth/infrastructure/datasources/auth_datasource_impl.dart';
import 'package:fit_wallet/features/auth/infrastructure/repositories/auth_repository_impl.dart';
import 'package:fit_wallet/features/shared/presentation/providers/api_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRepositoryProvider = Provider((ref) {
  final api = ref.watch(apiProvider);
  final datasource = AuthDatasourceImpl(api.dio);
  return AuthRepositoryImpl(datasource);
});
