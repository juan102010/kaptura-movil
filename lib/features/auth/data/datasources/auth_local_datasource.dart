import '../../../../core/storage/secure_storage_service.dart';

abstract class AuthLocalDataSource {
  /// Guarda sesión completa (token + user + scheme + schemeId + idPlans + expiresAt)
  Future<void> saveFullSession({
    required String token,
    required Duration ttl,
    required Map<String, dynamic> user,
    required String scheme,
    required String schemeId,
    required String idPlans,
  });

  /// Retorna token si la sesión es válida; si expiró la borra y retorna null
  Future<String?> getValidToken();

  /// Te devuelve la sesión completa si es válida; si no, null
  Future<StoredSession?> getValidSession();

  Future<void> clearSession();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  AuthLocalDataSourceImpl(this._storage);

  final SecureStorageService _storage;

  @override
  Future<void> saveFullSession({
    required String token,
    required Duration ttl,
    required Map<String, dynamic> user,
    required String scheme,
    required String schemeId,
    required String idPlans,
  }) async {
    await _storage.writeFullSession(
      token: token,
      ttl: ttl,
      user: user,
      scheme: scheme,
      schemeId: schemeId,
      idPlans: idPlans,
    );
  }

  @override
  Future<String?> getValidToken() async {
    final session = await _storage.readSession();
    return session?.token;
  }

  @override
  Future<StoredSession?> getValidSession() async {
    return _storage.readSession();
  }

  @override
  Future<void> clearSession() async {
    await _storage.clearSession();
  }
}
