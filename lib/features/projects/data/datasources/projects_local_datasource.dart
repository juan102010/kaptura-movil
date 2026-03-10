import 'dart:convert';

import 'package:drift/drift.dart';

import '../../../../core/local_db/app_database.dart';

class ProjectsLocalDataSource {
  ProjectsLocalDataSource({required AppDatabase database})
    : _database = database;

  final AppDatabase _database;

  Future<void> upsertProjectsCache(
    List<Map<String, dynamic>> rawProjects,
  ) async {
    if (rawProjects.isEmpty) return;

    await _database.batch((batch) {
      for (final project in rawProjects) {
        final id = project['_id']?.toString();

        if (id == null || id.isEmpty) {
          continue;
        }

        batch.insert(
          _database.projectsTable,
          ProjectsTableCompanion.insert(
            id: id,
            rawJson: jsonEncode(project),
            cachedAt: DateTime.now(),
          ),
          mode: InsertMode.insertOrReplace,
        );
      }
    });
  }

  Future<List<Map<String, dynamic>>> getProjectsCacheRaw() async {
    final rows = await _database.select(_database.projectsTable).get();

    final result = <Map<String, dynamic>>[];

    for (final row in rows) {
      try {
        final decoded = jsonDecode(row.rawJson);

        if (decoded is Map<String, dynamic>) {
          result.add(decoded);
        } else if (decoded is Map) {
          result.add(Map<String, dynamic>.from(decoded));
        }
      } catch (_) {
        // Ignora registros corruptos o JSON inválido
      }
    }

    return result;
  }

  Future<void> clearProjectsCache() async {
    await _database.delete(_database.projectsTable).go();
  }
}
