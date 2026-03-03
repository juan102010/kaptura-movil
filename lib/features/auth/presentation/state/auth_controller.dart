import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/di/providers.dart';
import '../../../../core/services/biometric_service.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../domain/usecases/login_usecase.dart';
import 'auth_state.dart';

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>(
  (ref) {
    final controller = AuthController(
      loginUseCase: ref.read(loginUseCaseProvider),
      secureStorage: ref.read(secureStorageServiceProvider),
      biometricService: ref.read(biometricServiceProvider),
    );

    // ✅ Bootstrap automático al crearse
    Future.microtask(controller.bootstrap);

    // Limpieza cuando se destruya el provider
    ref.onDispose(controller.disposeController);

    return controller;
  },
);

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

    // ✅ sesión válida
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
        "id": session.user.id,
        "name": session.user.name,
        "email": session.user.email,
        "role": session.user.role,
        "scheme": session.user.scheme,
        "schemeId": session.user.schemeId,
        "idPlans": session.user.idPlans,
      },
      scheme: session.user.scheme,
      schemeId: session.user.schemeId,
      idPlans: session.user.idPlans,
    );

    // ✅ Guardar/limpiar credenciales según Remember me
    await _secureStorage.writeRememberedCredentials(
      rememberMe: rememberMe,
      email: email,
      password: password,
    );

    // ✅ Estado autenticado (para router redirect)
    state = AuthAuthenticated(token: session.token);

    _startExpiryTimer(_sessionTtl);
  }

  /// ✅ Para saber si mostrar botón de huella en Login
  Future<bool> hasRememberedCredentials() async {
    final creds = await _secureStorage.readRememberedCredentials();
    return creds != null;
  }

  Future<Map<String, String>?> getRememberedCredentials() {
    return _secureStorage.readRememberedCredentials();
  }

  /// ✅ Login rápido: biometría -> leer credenciales -> login remoto -> guardar sesión
  Future<void> loginWithBiometrics() async {
    state = const AuthLoading();

    try {
      final ok = await _biometricService.authenticate(
        reason: 'Confirma tu identidad para iniciar sesión',
      );

      // Si el usuario cancela o falla
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
          "id": session.user.id,
          "name": session.user.name,
          "email": session.user.email,
          "role": session.user.role,
          "scheme": session.user.scheme,
          "schemeId": session.user.schemeId,
          "idPlans": session.user.idPlans,
        },
        scheme: session.user.scheme,
        schemeId: session.user.schemeId,
        idPlans: session.user.idPlans,
      );

      // ✅ Estado autenticado (para router redirect)
      state = AuthAuthenticated(token: session.token);

      _startExpiryTimer(_sessionTtl);
    } catch (e) {
      // ✅ si local_auth falla o no puede abrir prompt, no te quedas pegado en loading
      state = AuthError('No se pudo usar biometría: $e');
    }
  }

  Future<void> logout() async {
    _expiryTimer?.cancel();
    _expiryTimer = null;

    try {
      // ✅ 1) Borra SOLO sesión
      await _secureStorage.clearSession();

      // ✅ 2) Si rememberMe es false, borra credenciales. Si true, se conservan.
      final remember = await _secureStorage.readRememberMe();
      if (!remember) {
        await _secureStorage.clearRememberedCredentials();
      }
    } catch (_) {
      // fallback por si algo raro pasa (igual te desloguea)
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
