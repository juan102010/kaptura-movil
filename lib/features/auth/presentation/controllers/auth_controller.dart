import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/biometric_service.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../domain/usecases/login_usecase.dart';
import 'auth_state.dart';

class AuthController extends StateNotifier<AuthState> {
  AuthController({
    required LoginUseCase loginUseCase,
    required SecureStorageService secureStorage,
    required BiometricService biometricService,
  }) : _loginUseCase = loginUseCase,
       _secureStorage = secureStorage,
       _biometricService = biometricService,
       super(const AuthInitial());

  final LoginUseCase _loginUseCase;
  final SecureStorageService _secureStorage;
  final BiometricService _biometricService;

  Timer? _expiryTimer;

  static const _sessionTtl = Duration(hours: 1);

  Future<void> bootstrap() async {
    final session = await _secureStorage.readSession();

    if (session == null) {
      state = const AuthUnauthenticated();
      return;
    }

    state = AuthAuthenticated(token: session.token);
    _startExpiryTimer(session.remainingTtl);
  }

  Future<void> login({
    required String email,
    required String password,
    required bool rememberMe,
  }) async {
    state = const AuthLoading();

    final result = await _loginUseCase(email: email, password: password);

    if (result.failure != null) {
      state = AuthError(result.failure!.message);
      return;
    }

    final session = result.data!;
    if (session.token.isEmpty) {
      state = const AuthEmpty();
      return;
    }

    await _secureStorage.writeFullSession(
      token: session.token,
      ttl: _sessionTtl,
      user: {
        'id': session.user.id,
        'name': session.user.name,
        'email': session.user.email,
        'role': session.user.role,
        'scheme': session.user.scheme,
        'schemeId': session.user.schemeId,
        'idPlans': session.user.idPlans,
      },
      scheme: session.user.scheme,
      schemeId: session.user.schemeId,
      idPlans: session.user.idPlans,
    );

    await _secureStorage.writeRememberedCredentials(
      rememberMe: rememberMe,
      email: email,
      password: password,
    );

    state = AuthAuthenticated(token: session.token);
    _startExpiryTimer(_sessionTtl);
  }

  Future<bool> hasRememberedCredentials() async {
    final creds = await _secureStorage.readRememberedCredentials();
    return creds != null;
  }

  Future<Map<String, String>?> getRememberedCredentials() {
    return _secureStorage.readRememberedCredentials();
  }

  Future<void> loginWithBiometrics({required String reason}) async {
    state = const AuthLoading();

    try {
      final ok = await _biometricService.authenticate(reason: reason);

      if (!ok) {
        state = const AuthInitial();
        return;
      }

      final creds = await _secureStorage.readRememberedCredentials();
      if (creds == null) {
        state = const AuthError('No hay credenciales guardadas.');
        return;
      }

      final email = creds['email']!;
      final password = creds['password']!;

      final result = await _loginUseCase(email: email, password: password);

      if (result.failure != null) {
        state = AuthError(result.failure!.message);
        return;
      }

      final session = result.data!;
      if (session.token.isEmpty) {
        state = const AuthEmpty();
        return;
      }

      await _secureStorage.writeFullSession(
        token: session.token,
        ttl: _sessionTtl,
        user: {
          'id': session.user.id,
          'name': session.user.name,
          'email': session.user.email,
          'role': session.user.role,
          'scheme': session.user.scheme,
          'schemeId': session.user.schemeId,
          'idPlans': session.user.idPlans,
        },
        scheme: session.user.scheme,
        schemeId: session.user.schemeId,
        idPlans: session.user.idPlans,
      );

      state = AuthAuthenticated(token: session.token);
      _startExpiryTimer(_sessionTtl);
    } catch (e) {
      state = AuthError('No se pudo usar biometria: $e');
    }
  }

  Future<void> logout() async {
    _expiryTimer?.cancel();
    _expiryTimer = null;

    try {
      await _secureStorage.clearSession();

      final remember = await _secureStorage.readRememberMe();
      if (!remember) {
        await _secureStorage.clearRememberedCredentials();
      }
    } catch (_) {
      await _secureStorage.clearSession();
    }

    state = const AuthUnauthenticated();
  }

  void _startExpiryTimer(Duration ttl) {
    _expiryTimer?.cancel();
    _expiryTimer = Timer(ttl, () async {
      await logout();
    });
  }

  void disposeController() {
    _expiryTimer?.cancel();
  }
}
