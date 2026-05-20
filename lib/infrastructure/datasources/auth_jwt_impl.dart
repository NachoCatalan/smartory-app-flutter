import 'package:dio/dio.dart';

import 'package:smartory_app/domain/datasources/auth_datasource.dart';
import 'package:smartory_app/domain/entities/auth_tokens.dart';
import 'package:smartory_app/infrastructure/mappers/auth_mapper.dart';
import 'package:smartory_app/infrastructure/models/auth_model.dart';

class AuthJwtDatasourceImpl extends AuthDatasource {
  late final Dio dio;

  AuthJwtDatasourceImpl()
    : dio = Dio(BaseOptions(baseUrl: 'http://192.168.100.27:3000/api/auth'));

  @override
  Future<AuthTokens> loginUser(String email, String password) async {
    try {
      final response = await dio.post(
        '/login',
        data: {"email": email, "password": password},
        options: Options(connectTimeout: Duration(seconds: 5)),
      );
      final data = response.data;
      final authModel = AuthModel.fromJson(data);
      return AuthMapper.toEntity(authModel);
    } on DioException catch (e) {
      final message = e.response?.data['message'] ?? 'Error de login';
      throw Exception(message);
    }
  }

  @override
  Future<AuthTokens> registerUser(String email, String password) async {
    try {
      final response = await dio.post(
        '/register',
        data: {"email": email, "password": password},
      );
      final data = response.data;
      final authModel = AuthModel.fromJson(data);
      return AuthMapper.toEntity(authModel);
    } on DioException catch (e) {
      final message = e.response?.data['message'] ?? 'Error de registro';
      throw Exception(message);
    }
  }

  @override
  Future<AuthTokens> obtainTokens(String refreshToken) async {
    final response = await dio.post(
      '/refresh',
      data: {'refreshToken': refreshToken},
    );
    final data = response.data;
    final jsonTokens = AuthModel.fromJson(data);
    return AuthMapper.toEntity(jsonTokens);
  }

  @override
  Future<void> requestPasswordRecovery(String email) {
    // TODO: implement requestPasswordRecovery
    throw UnimplementedError();
  }

  @override
  Future<void> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) {
    // TODO: implement resetPassword
    throw UnimplementedError();
  }

  @override
  Future<void> verifyRecoveryCode({
    required String email,
    required String code,
  }) {
    // TODO: implement verifyRecoveryCode
    throw UnimplementedError();
  }
}
