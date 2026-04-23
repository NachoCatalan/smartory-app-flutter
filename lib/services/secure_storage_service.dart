import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:smartory_app/domain/entities/auth_tokens.dart';

class SecureStorageService {
  final storage = FlutterSecureStorage();

  Future<void> saveTokens(AuthTokens tokens) async {
    await storage.write(key: 'accessToken', value: tokens.accessToken);
    await storage.write(key: 'refreshToken', value: tokens.refreshToken);
  }

  Future<AuthTokens?> getTokens() async {
    final accessToken = await storage.read(key: 'accessToken');
    final refreshToken = await storage.read(key: 'refreshToken');
    if (accessToken == null || refreshToken == null) return null;
    return AuthTokens(accessToken: accessToken, refreshToken: refreshToken);
  }

  Future<void> clearTokens() async {
    await storage.deleteAll();
  }
}
