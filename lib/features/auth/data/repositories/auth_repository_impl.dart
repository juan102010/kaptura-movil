import 'package:dio/dio.dart';

import '../../../../core/errors/error_mapper.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entities/auth_session_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../datasources/auth_local_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._remote, this._local);

  final AuthRemoteDataSource _remote;
  final AuthLocalDataSource _local;

  @override
  Future<Result<AuthSessionEntity>> login({
    required String email,
    required String password,
  }) async {
    try {
      final session = await _remote.login(email: email, password: password);
      return (data: session, failure: null);
    } on DioException catch (e) {
      return (data: null, failure: ErrorMapper.fromDio(e));
    } catch (_) {
      return (data: null, failure: const UnknownFailure('Error inesperado.'));
    }
  }

  @override
  Future<Result<void>> sendOtpByEmail(String email) async {
    try {
      await _remote.sendOtpByEmail(email);
      return (data: null, failure: null);
    } on DioException catch (e) {
      return (data: null, failure: ErrorMapper.fromDio(e));
    } catch (_) {
      return (data: null, failure: const UnknownFailure('Error inesperado.'));
    }
  }

  @override
  Future<Result<void>> verifyOtpCode({
    required String email,
    required String code,
  }) async {
    try {
      await _remote.verifyOtpCode(email: email, code: code);
      return (data: null, failure: null);
    } on DioException catch (e) {
      return (data: null, failure: ErrorMapper.fromDio(e));
    } catch (_) {
      return (data: null, failure: const UnknownFailure('Error inesperado.'));
    }
  }

  @override
  Future<Result<void>> updatePassword({
    required String email,
    required String password,
  }) async {
    try {
      await _remote.updatePassword(email: email, password: password);
      return (data: null, failure: null);
    } on DioException catch (e) {
      return (data: null, failure: ErrorMapper.fromDio(e));
    } catch (_) {
      return (data: null, failure: const UnknownFailure('Error inesperado.'));
    }
  }

  // ✅ NUEVO: guardar sesión completa en local storage
  @override
  Future<Result<void>> saveFullSession({
    required String token,
    required Duration ttl,
    required Map<String, dynamic> user,
    required String scheme,
    required String schemeId,
    required String idPlans,
  }) async {
    try {
      await _local.saveFullSession(
        token: token,
        ttl: ttl,
        user: user,
        scheme: scheme,
        schemeId: schemeId,
        idPlans: idPlans,
      );
      return (data: null, failure: null);
    } catch (_) {
      return (
        data: null,
        failure: const UnknownFailure('No se pudo guardar la sesión.'),
      );
    }
  }

  @override
  Future<Result<String?>> getValidToken() async {
    try {
      final token = await _local.getValidToken();
      return (data: token, failure: null);
    } catch (_) {
      return (
        data: null,
        failure: const UnknownFailure('No se pudo leer la sesión.'),
      );
    }
  }

  @override
  Future<Result<void>> clearSession() async {
    try {
      await _local.clearSession();
      return (data: null, failure: null);
    } catch (_) {
      return (
        data: null,
        failure: const UnknownFailure('No se pudo cerrar sesión.'),
      );
    }
  }
}
