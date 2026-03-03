import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class ErrorInterceptor extends Interceptor {
  ErrorInterceptor(this._logger);

  final Logger _logger;

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final status = err.response?.statusCode;

    if (status == 401) {
      _logger.w('No autorizado (401).');
    } else if (status == 500) {
      _logger.e('Error servidor (500).');
    } else {
      _logger.e('HTTP error', error: err, stackTrace: err.stackTrace);
    }

    handler.next(err);
  }
}
