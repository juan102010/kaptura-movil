import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class RequestLogInterceptor extends Interceptor {
  RequestLogInterceptor(this._logger);

  final Logger _logger;

  static const _sensitiveKeys = {
    'password',
    'token',
    'authorization',
    'authToken',
    'refreshToken',
    'otp',
    'code',
  };

  dynamic _sanitize(dynamic data) {
    if (data is Map) {
      return data.map((key, value) {
        final k = key.toString();
        if (_sensitiveKeys.contains(k)) {
          return MapEntry(key, '***');
        }
        return MapEntry(key, _sanitize(value));
      });
    }
    if (data is List) {
      return data.map(_sanitize).toList();
    }
    return data;
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _logger.i('💡 HTTP ${options.method} ${options.uri}');

    if (options.data != null) {
      _logger.d('🐛 Body: ${_sanitize(options.data)}');
    }

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _logger.i('✅ ${response.statusCode} ${response.requestOptions.uri}');
    _logger.d('Response: ${response.data}');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _logger.e(
      '⛔ ERROR ${err.response?.statusCode} ${err.requestOptions.uri} -> ${err.message}',
    );
    handler.next(err);
  }
}
