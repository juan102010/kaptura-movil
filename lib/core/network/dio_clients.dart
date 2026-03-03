import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';

import '../constants/env_keys.dart';
import '../storage/secure_storage_service.dart';
import 'interceptors/auth_token_interceptor.dart';
import 'interceptors/error_interceptor.dart';
import 'interceptors/session_expired_interceptor.dart';
import 'interceptors/request_log_interceptor.dart';

class DioClients {
  DioClients({
    required Logger logger,
    required SecureStorageService secureStorage,
    required AppEventBus eventBus,
  }) : login = _buildLoginDio(logger: logger, secureStorage: secureStorage),
       api = _buildApiDio(
         logger: logger,
         secureStorage: secureStorage,
         eventBus: eventBus,
       );

  final Dio login;
  final Dio api;

  static Dio _baseDio(String baseUrl) {
    return Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: const {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
  }

  static Dio _buildLoginDio({
    required Logger logger,
    required SecureStorageService secureStorage,
  }) {
    final baseUrl = dotenv.get(EnvKeys.userApiBase);
    final dio = _baseDio(baseUrl);

    dio.interceptors.addAll([
      RequestLogInterceptor(logger), // 👈 LOG URL FINAL
      AuthTokenInterceptor(secureStorage),
      ErrorInterceptor(logger),
    ]);

    return dio;
  }

  static Dio _buildApiDio({
    required Logger logger,
    required SecureStorageService secureStorage,
    required AppEventBus eventBus,
  }) {
    final baseUrl = dotenv.get(EnvKeys.apiBase);
    final dio = _baseDio(baseUrl);

    dio.interceptors.addAll([
      RequestLogInterceptor(logger), // 👈 LOG URL FINAL
      AuthTokenInterceptor(secureStorage),
      ErrorInterceptor(logger),
      SessionExpiredInterceptor(eventBus),
    ]);

    return dio;
  }
}
