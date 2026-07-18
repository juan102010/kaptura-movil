import '../entities/permission_setting_entity.dart';

abstract class PermissionSettingsRepository {
  Future<List<PermissionSettingEntity>> getCachedPermissionSettings();
  Future<List<PermissionSettingEntity>> refreshPermissionSettings();
  Future<void> clearPermissionSettings();
}
