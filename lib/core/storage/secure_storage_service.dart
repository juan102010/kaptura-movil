import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StoredSession {
  const StoredSession({
    required this.token,
    required this.expiresAt,
    required this.user,
    required this.scheme,
    required this.schemeId,
    required this.idPlans,
  });

  final String token;
  final DateTime expiresAt;
  final Map<String, dynamic> user;
  final String scheme;
  final String schemeId;
  final String idPlans;

  Duration get remainingTtl {
    final diff = expiresAt.difference(DateTime.now());
    if (diff.isNegative) return Duration.zero;
    return diff;
  }
}

class SecureStorageService {
  SecureStorageService(this._storage);

  final FlutterSecureStorage _storage;

  static const _kTokenKey = 'auth_token';
  static const _kExpiresAtKey = 'auth_expires_at_ms';
  static const _kUserKey = 'auth_user_json';
  static const _kSchemeKey = 'auth_scheme';
  static const _kSchemeIdKey = 'auth_scheme_id';
  static const _kPlansKey = 'auth_plans_id';
  static const _kRememberMeKey = 'auth_remember_me';
  static const _kRememberEmailKey = 'auth_remember_email';
  static const _kRememberPasswordKey = 'auth_remember_password';

  // ✅ Guarda todo lo necesario para reconstruir sesión
  Future<void> writeFullSession({
    required String token,
    required Duration ttl,
    required Map<String, dynamic> user,
    required String scheme,
    required String schemeId,
    required String idPlans,
  }) async {
    final expiresAt = DateTime.now().add(ttl);

    await _storage.write(key: _kTokenKey, value: token);
    await _storage.write(
      key: _kExpiresAtKey,
      value: expiresAt.millisecondsSinceEpoch.toString(),
    );
    await _storage.write(key: _kUserKey, value: jsonEncode(user));
    await _storage.write(key: _kSchemeKey, value: scheme);
    await _storage.write(key: _kSchemeIdKey, value: schemeId);
    await _storage.write(key: _kPlansKey, value: idPlans);

    // 🔍 DEBUG: mostrar qué se guardó (solo en debug)
    if (kDebugMode) {
      debugPrint('====== SESSION GUARDADA ======');
      debugPrint('TOKEN: $token');
      debugPrint('EXPIRES AT: $expiresAt');
      debugPrint('USER: ${jsonEncode(user)}');
      debugPrint('SCHEME: $scheme');
      debugPrint('SCHEME ID: $schemeId');
      debugPrint('ID PLANS: $idPlans');
      debugPrint('===============================');
    }
  }

  // ✅ Lee sesión completa; si expiró, la borra y retorna null
  Future<StoredSession?> readSession() async {
    final token = await _storage.read(key: _kTokenKey);
    final expiresRaw = await _storage.read(key: _kExpiresAtKey);

    if (token == null || token.isEmpty) return null;
    if (expiresRaw == null || expiresRaw.isEmpty) return null;

    final expiresMs = int.tryParse(expiresRaw);
    if (expiresMs == null) return null;

    final expiresAt = DateTime.fromMillisecondsSinceEpoch(expiresMs);

    // expiró -> limpia y null
    if (!DateTime.now().isBefore(expiresAt)) {
      await clearSession();
      return null;
    }

    final userRaw = await _storage.read(key: _kUserKey);
    final scheme = await _storage.read(key: _kSchemeKey);
    final schemeId = await _storage.read(key: _kSchemeIdKey);
    final idPlans = await _storage.read(key: _kPlansKey);

    final user = (userRaw == null || userRaw.isEmpty)
        ? <String, dynamic>{}
        : (jsonDecode(userRaw) as Map).cast<String, dynamic>();

    return StoredSession(
      token: token,
      expiresAt: expiresAt,
      user: user,
      scheme: scheme ?? '',
      schemeId: schemeId ?? '',
      idPlans: idPlans ?? '',
    );
  }

  // ✅ compat si aún lo usas en otros lados
  Future<void> writeToken(String token) async {
    await _storage.write(key: _kTokenKey, value: token);
  }

  Future<String?> readToken() async {
    return _storage.read(key: _kTokenKey);
  }

  /// ✅ Borra SOLO las keys de sesión que tú guardasa
  Future<void> clearSession() async {
    await _storage.delete(key: _kTokenKey);
    await _storage.delete(key: _kExpiresAtKey);
    await _storage.delete(key: _kUserKey);
    await _storage.delete(key: _kSchemeKey);
    await _storage.delete(key: _kSchemeIdKey);
    await _storage.delete(key: _kPlansKey);
  }

  Future<void> clearAll() async {
    await _storage.deleteAll();
  }

  Future<void> writeRememberedCredentials({
    required bool rememberMe,
    required String email,
    required String password,
  }) async {
    await _storage.write(key: _kRememberMeKey, value: rememberMe ? '1' : '0');

    if (!rememberMe) {
      await clearRememberedCredentials();
      return;
    }

    await _storage.write(key: _kRememberEmailKey, value: email);
    await _storage.write(key: _kRememberPasswordKey, value: password);
  }

  Future<bool> readRememberMe() async {
    final raw = await _storage.read(key: _kRememberMeKey);
    return raw == '1';
  }

  Future<Map<String, String>?> readRememberedCredentials() async {
    final rememberMe = await readRememberMe();
    if (!rememberMe) return null;

    final email = await _storage.read(key: _kRememberEmailKey);
    final password = await _storage.read(key: _kRememberPasswordKey);

    if (email == null || email.isEmpty) return null;
    if (password == null || password.isEmpty) return null;

    return {'email': email, 'password': password};
  }

  Future<void> clearRememberedCredentials() async {
    await _storage.delete(key: _kRememberEmailKey);
    await _storage.delete(key: _kRememberPasswordKey);
    await _storage.delete(key: _kRememberMeKey);
  }
}
