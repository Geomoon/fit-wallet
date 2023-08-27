import 'package:fit_wallet/features/auth/domain/domain.dart';

abstract class AuthRepository {
  Future<AuthEntity> signIn(SignInEntity entity);
  Future<AuthEntity> signUp(SignUpEntity entity);
}
