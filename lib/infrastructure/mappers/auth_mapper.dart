import 'package:smartory_app/domain/entities/auth_tokens.dart';
import 'package:smartory_app/infrastructure/models/auth_model.dart';

class AuthMapper {
  static AuthTokens toEntity(AuthModel authModel) {
    return AuthTokens(
      accessToken: authModel.token,
      refreshToken: authModel.refreshToken,
    );
  }
}
