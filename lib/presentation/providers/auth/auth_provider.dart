// 1. State
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import 'package:smartory_app/domain/entities/entities.dart';
import 'package:smartory_app/domain/repositories/auth_repository.dart';

import 'package:smartory_app/infrastructure/datasources/auth_jwt_impl.dart';
import 'package:smartory_app/infrastructure/repositories/auth_jwt_repository_impl.dart';

import 'package:smartory_app/presentation/utils/validators.dart';
import 'package:smartory_app/services/secure_storage_service.dart';

enum AuthStatus { authenticated, unauthenthicated }

class AuthState {
  final AuthStatus status;
  final AuthTokens? tokens;
  final User? user;

  AuthState({
    this.status = AuthStatus.unauthenthicated,
    this.tokens,
    this.user,
  });

  AuthState copyWith({AuthStatus? status, AuthTokens? tokens, User? user}) =>
      AuthState(
        status: status ?? this.status,
        tokens: tokens ?? this.tokens,
        user: user ?? this.user,
      );
}

// 2. Notifier

class AuthNotifier extends AsyncNotifier<AuthState> {
  final AuthRepository authRepository;

  late final SecureStorageService _storage;

  AuthNotifier({required this.authRepository});
  void clearError() {
    final currentState = state.value;

    state = AsyncData(
      currentState ?? AuthState(status: AuthStatus.unauthenthicated),
    );
  }

  @override
  Future<AuthState> build() async {
    _storage = SecureStorageService();

    final tokens = await _storage.getTokens();
    if (tokens == null) return AuthState(status: AuthStatus.unauthenthicated);

    final isExpired = Validators.isTokenExpired(tokens.accessToken);
    if (!isExpired) {
      return AuthState(status: AuthStatus.authenticated, tokens: tokens);
    }
    try {
      final newTokens = await authRepository.obtainTokens(tokens.refreshToken);
      await _storage.saveTokens(newTokens);
      return AuthState(tokens: newTokens, status: AuthStatus.authenticated);
    } catch (e) {
      await _storage.clearTokens();
      return AuthState(status: AuthStatus.unauthenthicated);
    }
  }

  Future<void> login(String email, String password) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final tokens = await authRepository.loginUser(email, password);
      final payload = JwtDecoder.decode(tokens.accessToken);

      final user = User(id: payload['id'], email: email);

      await _storage.saveTokens(tokens);

      return AuthState(
        status: AuthStatus.authenticated,
        tokens: tokens,
        user: user,
      );
    });
  }

  Future<void> register(String email, String password) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final tokens = await authRepository.registerUser(email, password);
      final payload = JwtDecoder.decode(tokens.accessToken);
      final user = User(id: payload['id'], email: email);

      await _storage.saveTokens(tokens);

      return AuthState(
        status: AuthStatus.authenticated,
        tokens: tokens,
        user: user,
      );
    });
  }

  Future<void> logout() async {
    await _storage.clearTokens();
    state = const AsyncLoading();
    state = AsyncData(
      AuthState(status: AuthStatus.unauthenthicated, tokens: null, user: null),
    );
  }

  Future<String?> getValidAccessToken() async {
    final currentState = state.value;
    if (currentState == null) return null;
    final tokens = currentState.tokens;
    if (tokens == null) return null;
    final isExpired = Validators.isTokenExpired(tokens.accessToken);
    if (!isExpired) return tokens.accessToken;
    final newTokens = await authRepository.obtainTokens(tokens.refreshToken);
    await _storage.saveTokens(newTokens);

    state = AsyncData(
      AuthState(tokens: newTokens, status: AuthStatus.authenticated),
    );
    return newTokens.accessToken;
  }
}

// 3. Provider

final authProvider = AsyncNotifierProvider<AuthNotifier, AuthState>(() {
  final datasource = AuthJwtDatasourceImpl();
  final repository = AuthJwtRepositoryImpl(datasource: datasource);
  return AuthNotifier(authRepository: repository);
});
