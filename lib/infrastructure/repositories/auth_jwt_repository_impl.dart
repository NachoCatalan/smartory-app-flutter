
import 'package:smartory_app/domain/entities/auth_tokens.dart';
import 'package:smartory_app/domain/repositories/auth_repository.dart';
import 'package:smartory_app/infrastructure/datasources/auth_jwt_impl.dart';

class AuthJwtRepositoryImpl extends AuthRepository {

  final AuthJwtDatasourceImpl datasource;

  AuthJwtRepositoryImpl({required this.datasource});

  @override
  Future<AuthTokens> loginUser(String email, String password) {
    return datasource.loginUser(email, password);
  }

  @override
  Future<void> registerUser(String username, String email, String password) {
    throw UnimplementedError();
  }

  @override
  Future<AuthTokens> obtainTokens(String token) {
    return datasource.obtainTokens(token);
  }
  
  @override
  Future<void> requestPasswordRecovery(String email) {
    // TODO: implement requestPasswordRecovery
    throw UnimplementedError();
  }
  
  @override
  Future<void> resetPassword({required String email, required String code, required String newPassword}) {
    // TODO: implement resetPassword
    throw UnimplementedError();
  }
  
  @override
  Future<void> verifyRecoveryCode({required String email, required String code}) {
    // TODO: implement verifyRecoveryCode
    throw UnimplementedError();
  }
  
  
}