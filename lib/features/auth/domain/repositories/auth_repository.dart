import '../../../../core/errors/failure.dart';
import '../entities/auth_session_entity.dart';

typedef Result<T> = ({T? data, Failure? failure});

abstract class AuthRepository {
  Future<Result<AuthSessionEntity>> login({
    required String email,
    required String password,
  });

  Future<Result<void>> sendOtpByEmail(String email);

  Future<Result<void>> verifyOtpCode({
    required String email,
    required String code,
  });

  Future<Result<void>> updatePassword({
    required String email,
    required String password,
  });

  // ✅ NUEVO: sesión local completa
  Future<Result<void>> saveFullSession({
    required String token,
    required Duration ttl,
    required Map<String, dynamic> user,
    required String scheme,
    required String schemeId,
    required String idPlans,
  });

  Future<Result<String?>> getValidToken();
  Future<Result<void>> clearSession();
}
