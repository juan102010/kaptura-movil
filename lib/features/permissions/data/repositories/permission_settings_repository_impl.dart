import '../../domain/entities/permission_setting_entity.dart';
import '../../domain/repositories/permission_settings_repository.dart';
import '../datasources/permission_settings_local_datasource.dart';
import '../datasources/permission_settings_remote_datasource.dart';

class PermissionSettingsRepositoryImpl implements PermissionSettingsRepository {
  PermissionSettingsRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  final PermissionSettingsRemoteDataSource remoteDataSource;
  final PermissionSettingsLocalDataSource localDataSource;

  @override
  Future<List<PermissionSettingEntity>> getCachedPermissionSettings() {
    return localDataSource.getCachedPermissionSettings();
  }

  @override
  Future<List<PermissionSettingEntity>> refreshPermissionSettings() async {
    final permissions = await remoteDataSource.getPermissionSettings();
    await localDataSource.replacePermissionSettings(permissions);
    return permissions;
  }

  @override
  Future<void> clearPermissionSettings() {
    return localDataSource.clearPermissionSettings();
  }
}
