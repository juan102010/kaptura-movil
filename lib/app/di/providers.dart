import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';

import '../../core/network/dio_clients.dart';
import '../../core/network/interceptors/session_expired_interceptor.dart';
import '../../core/storage/secure_storage_service.dart';

import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/datasources/auth_local_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';

import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/send_otp_usecase.dart';
import '../../features/auth/domain/usecases/verify_otp_usecase.dart';
import '../../features/auth/domain/usecases/update_password_usecase.dart';

// ✅ NUEVOS usecases
import '../../features/auth/domain/usecases/save_session_usecase.dart';
import '../../features/auth/domain/usecases/load_session_usecase.dart';
import '../../features/auth/domain/usecases/clear_session_usecase.dart';
import '../../core/services/location_service.dart';
import '../../core/network/internet_monitor.dart';
import '../../core/network/internet_status.dart';
import 'package:local_auth/local_auth.dart';
import '../../core/services/biometric_service.dart';

final loggerProvider = Provider<Logger>((ref) => Logger());

final eventBusProvider = Provider<AppEventBus>((ref) {
  final bus = AppEventBus();
  ref.onDispose(bus.dispose);
  return bus;
});

final flutterSecureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage();
});

final secureStorageServiceProvider = Provider<SecureStorageService>((ref) {
  return SecureStorageService(ref.read(flutterSecureStorageProvider));
});

final dioClientsProvider = Provider<DioClients>((ref) {
  return DioClients(
    logger: ref.read(loggerProvider),
    secureStorage: ref.read(secureStorageServiceProvider),
    eventBus: ref.read(eventBusProvider),
  );
});

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSourceImpl(ref.read(dioClientsProvider).login);
});

// ✅ NUEVO: Local datasource (token + expiresAt)
final authLocalDataSourceProvider = Provider<AuthLocalDataSource>((ref) {
  return AuthLocalDataSourceImpl(ref.read(secureStorageServiceProvider));
});

// ✅ ACTUALIZADO: Repo ahora usa remote + local
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    ref.read(authRemoteDataSourceProvider),
    ref.read(authLocalDataSourceProvider),
  );
});

// UseCases existentes
final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  return LoginUseCase(ref.read(authRepositoryProvider));
});

final sendOtpUseCaseProvider = Provider<SendOtpUseCase>((ref) {
  return SendOtpUseCase(ref.read(authRepositoryProvider));
});

final verifyOtpUseCaseProvider = Provider<VerifyOtpUseCase>((ref) {
  return VerifyOtpUseCase(ref.read(authRepositoryProvider));
});

final updatePasswordUseCaseProvider = Provider<UpdatePasswordUseCase>((ref) {
  return UpdatePasswordUseCase(ref.read(authRepositoryProvider));
});

// ✅ NUEVOS: usecases para sesión
final saveSessionUseCaseProvider = Provider<SaveSessionUseCase>((ref) {
  return SaveSessionUseCase(ref.read(authRepositoryProvider));
});

final loadSessionUseCaseProvider = Provider<LoadSessionUseCase>((ref) {
  return LoadSessionUseCase(ref.read(authRepositoryProvider));
});

final clearSessionUseCaseProvider = Provider<ClearSessionUseCase>((ref) {
  return ClearSessionUseCase(ref.read(authRepositoryProvider));
});

final locationServiceProvider = Provider<LocationService>((ref) {
  return const LocationService();
});
final localAuthProvider = Provider<LocalAuthentication>((ref) {
  return LocalAuthentication();
});

final biometricServiceProvider = Provider<BiometricService>((ref) {
  return BiometricServiceImpl(ref.read(localAuthProvider));
});
final internetMonitorProvider = Provider<InternetMonitor>((ref) {
  final monitor = InternetMonitor();
  // inicia monitoreo apenas se crea
  Future.microtask(monitor.start);

  ref.onDispose(() {
    monitor.dispose();
  });

  return monitor;
});

final internetStatusProvider = StreamProvider<InternetStatus>((ref) {
  final monitor = ref.watch(internetMonitorProvider);
  return monitor.stream;
});
