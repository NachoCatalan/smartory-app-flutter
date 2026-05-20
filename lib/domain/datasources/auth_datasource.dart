import 'package:smartory_app/domain/entities/auth_tokens.dart';

abstract class AuthDatasource {
  Future<AuthTokens> registerUser(String email, String password);

  Future<AuthTokens> loginUser(String email, String password);

  Future<void> requestPasswordRecovery(String email);

  Future<void> verifyRecoveryCode({
    required String email,
    required String code,
  });

  Future<void> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  });

  Future<AuthTokens> obtainTokens(String refreshToken);
}
