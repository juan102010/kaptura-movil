import 'dart:convert';

import 'package:drift/drift.dart';

import '../../../../core/local_db/app_database.dart';
import '../models/permission_setting_model.dart';

abstract class PermissionSettingsLocalDataSource {
  Future<List<PermissionSettingModel>> getCachedPermissionSettings();
  Future<void> replacePermissionSettings(
    List<PermissionSettingModel> permissions,
  );
  Future<void> clearPermissionSettings();
}

class PermissionSettingsLocalDataSourceImpl
    implements PermissionSettingsLocalDataSource {
  PermissionSettingsLocalDataSourceImpl({required this.database});

  final AppDatabase database;

  @override
  Future<List<PermissionSettingModel>> getCachedPermissionSettings() async {
    final rows = await database.select(database.permissionSettingsTable).get();
    final permissions = <PermissionSettingModel>[];

    for (final row in rows) {
      try {
        final decoded = jsonDecode(row.rawJson);
        if (decoded is Map) {
          permissions.add(
            PermissionSettingModel.fromMap(Map<String, dynamic>.from(decoded)),
          );
        }
      } catch (_) {}
    }

    return permissions;
  }

  @override
  Future<void> replacePermissionSettings(
    List<PermissionSettingModel> permissions,
  ) async {
    await database.transaction(() async {
      await database.delete(database.permissionSettingsTable).go();
      if (permissions.isEmpty) return;

      await database.batch((batch) {
        batch.insertAll(
          database.permissionSettingsTable,
          permissions
              .map(
                (permission) => PermissionSettingsTableCompanion.insert(
                  id: permission.id,
                  rawJson: jsonEncode(permission.toMap()),
                  cachedAt: DateTime.now(),
                ),
              )
              .toList(growable: false),
          mode: InsertMode.insertOrReplace,
        );
      });
    });
  }

  @override
  Future<void> clearPermissionSettings() {
    return database.delete(database.permissionSettingsTable).go();
  }
}
