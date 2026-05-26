import 'dart:convert';

import 'package:drift/drift.dart';

import '../../../../core/local_db/app_database.dart';
import '../models/project_model.dart';

class ProjectsLocalDataSource {
  ProjectsLocalDataSource({required AppDatabase database})
    : _database = database;

  final AppDatabase _database;

  Future<void> upsertProjectsCache(List<ProjectModel> projects) async {
    if (projects.isEmpty) return;

    await _database.batch((batch) {
      for (final project in projects) {
        if (project.id.isEmpty) continue;

        batch.insert(
          _database.projectsTable,
          ProjectsTableCompanion.insert(
            id: project.id,
            rawJson: jsonEncode(project.toMap()),
            cachedAt: DateTime.now(),
          ),
          mode: InsertMode.insertOrReplace,
        );
      }
    });
  }

  Future<List<ProjectModel>> getProjectsCacheRaw() async {
    final rows = await _database.select(_database.projectsTable).get();
    final result = <ProjectModel>[];

    for (final row in rows) {
      try {
        final decoded = jsonDecode(row.rawJson);

        if (decoded is Map<String, dynamic>) {
          result.add(ProjectModel.fromMap(decoded));
        } else if (decoded is Map) {
          result.add(ProjectModel.fromMap(Map<String, dynamic>.from(decoded)));
        }
      } catch (_) {}
    }

    return result;
  }

  Future<void> clearProjectsCache() async {
    await _database.delete(_database.projectsTable).go();
  }
}
