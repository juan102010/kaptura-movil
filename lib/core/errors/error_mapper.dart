import 'package:dio/dio.dart';
import 'failure.dart';

abstract final class ErrorMapper {
  static Failure fromDio(DioException e) {
    final status = e.response?.statusCode;

    if (status == 401) {
      return const UnauthorizedFailure(
        'No autorizado. Inicia sesión nuevamente.',
      );
    }
    if (status == 500) {
      return const ServerFailure('Error del servidor. Intenta más tarde.');
    }

    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return const NetworkFailure(
        'Tiempo de espera agotado. Revisa tu conexión.',
      );
    }

    return UnknownFailure(e.message ?? 'Error inesperado.');
  }
}
