import 'dart:convert';

import 'package:drift/drift.dart';

import '../../../../core/local_db/app_database.dart';
import '../models/time_report_record_model.dart';

abstract class TimeReportsLocalDataSource {
  Future<List<TimeReportRecordModel>> getCachedTimeReports();
  Future<void> replaceTimeReports(List<TimeReportRecordModel> reports);
  Future<void> upsertTimeReport(TimeReportRecordModel report);
}

class TimeReportsLocalDataSourceImpl implements TimeReportsLocalDataSource {
  TimeReportsLocalDataSourceImpl({required this.database});

  final AppDatabase database;

  @override
  Future<List<TimeReportRecordModel>> getCachedTimeReports() async {
    final rows = await database.select(database.timeReportsTable).get();
    final reports = <TimeReportRecordModel>[];
    for (final row in rows) {
      try {
        final decoded = jsonDecode(row.rawJson);
        if (decoded is Map) {
          reports.add(
            TimeReportRecordModel.fromMap(Map<String, dynamic>.from(decoded)),
          );
        }
      } catch (_) {}
    }
    return reports;
  }

  @override
  Future<void> replaceTimeReports(List<TimeReportRecordModel> reports) async {
    await database.transaction(() async {
      await database.delete(database.timeReportsTable).go();
      if (reports.isEmpty) return;
      await database.batch((batch) {
        batch.insertAll(
          database.timeReportsTable,
          reports.map(_companion).toList(growable: false),
          mode: InsertMode.insertOrReplace,
        );
      });
    });
  }

  @override
  Future<void> upsertTimeReport(TimeReportRecordModel report) {
    return database
        .into(database.timeReportsTable)
        .insert(_companion(report), mode: InsertMode.insertOrReplace);
  }

  TimeReportsTableCompanion _companion(TimeReportRecordModel report) {
    return TimeReportsTableCompanion.insert(
      id: report.id,
      rawJson: jsonEncode(report.rawData),
      cachedAt: DateTime.now(),
    );
  }
}
