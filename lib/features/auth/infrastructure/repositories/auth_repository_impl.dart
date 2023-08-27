import 'package:fit_wallet/features/auth/domain/domain.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._datasource);

  final AuthDatasource _datasource;

  @override
  Future<AuthEntity> signIn(SignInEntity entity) => _datasource.signIn(entity);

  @override
  Future<AuthEntity> signUp(SignUpEntity entity) => _datasource.signUp(entity);
}
