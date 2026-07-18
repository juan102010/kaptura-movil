import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/di/providers.dart';
import '../../../../core/local_db/app_database_provider.dart';
import '../../../auth/presentation/controllers/auth_state.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../data/datasources/permission_settings_local_datasource.dart';
import '../../data/datasources/permission_settings_remote_datasource.dart';
import '../../data/repositories/permission_settings_repository_impl.dart';
import '../../domain/repositories/permission_settings_repository.dart';
import '../controllers/permission_settings_controller.dart';

final permissionSettingsRemoteDataSourceProvider =
    Provider<PermissionSettingsRemoteDataSource>((ref) {
      return PermissionSettingsRemoteDataSourceImpl(
        apiDio: ref.watch(dioClientsProvider).api,
      );
    });

final permissionSettingsLocalDataSourceProvider =
    Provider<PermissionSettingsLocalDataSource>((ref) {
      return PermissionSettingsLocalDataSourceImpl(
        database: ref.watch(appDatabaseProvider),
      );
    });

final permissionSettingsRepositoryProvider =
    Provider<PermissionSettingsRepository>((ref) {
      return PermissionSettingsRepositoryImpl(
        remoteDataSource: ref.watch(permissionSettingsRemoteDataSourceProvider),
        localDataSource: ref.watch(permissionSettingsLocalDataSourceProvider),
      );
    });

final permissionSettingsControllerProvider =
    StateNotifierProvider.autoDispose<
      PermissionSettingsController,
      PermissionSettingsState
    >((ref) {
      final controller = PermissionSettingsController(
        repository: ref.watch(permissionSettingsRepositoryProvider),
        secureStorage: ref.watch(secureStorageServiceProvider),
      );

      ref.listen<AuthState>(authControllerProvider, (previous, next) {
        if (next is AuthAuthenticated) {
          controller.start();
        } else {
          controller.stop();
        }
      }, fireImmediately: true);

      return controller;
    });
