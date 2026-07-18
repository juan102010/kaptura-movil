import 'dart:convert';

import 'package:drift/drift.dart';

import '../local_db/app_database.dart';

class PendingUpdate {
  const PendingUpdate({
    required this.localId,
    required this.tableName,
    required this.recordId,
    required this.data,
    required this.schemeOverride,
  });

  final int localId;
  final String tableName;
  final String recordId;
  final Map<String, Map<String, dynamic>> data;
  final String? schemeOverride;
}

class PendingUpdateStore {
  PendingUpdateStore(this._database);

  final AppDatabase _database;

  Future<int> enqueue({
    required String tableName,
    required String recordId,
    required Map<String, Map<String, dynamic>> data,
    String? schemeOverride,
  }) {
    return _database
        .into(_database.pendingUpdatesTable)
        .insert(
          PendingUpdatesTableCompanion.insert(
            targetTable: tableName,
            recordId: recordId,
            dataJson: jsonEncode(data),
            schemeOverride: Value(schemeOverride),
          ),
        );
  }

  Future<List<PendingUpdate>> getPending() async {
    final query = _database.select(_database.pendingUpdatesTable)
      ..orderBy([(row) => OrderingTerm.asc(row.localId)]);
    final rows = await query.get();

    return rows
        .map((row) {
          final decoded = Map<String, dynamic>.from(
            jsonDecode(row.dataJson) as Map,
          );
          return PendingUpdate(
            localId: row.localId,
            tableName: row.targetTable,
            recordId: row.recordId,
            data: decoded.map(
              (key, value) =>
                  MapEntry(key, Map<String, dynamic>.from(value as Map)),
            ),
            schemeOverride: row.schemeOverride,
          );
        })
        .toList(growable: false);
  }

  Future<void> remove(int localId) async {
    await (_database.delete(
      _database.pendingUpdatesTable,
    )..where((row) => row.localId.equals(localId))).go();
  }

  Future<void> registerFailure(int localId, Object error) async {
    await (_database.update(
      _database.pendingUpdatesTable,
    )..where((row) => row.localId.equals(localId))).write(
      PendingUpdatesTableCompanion(
        attempts: const Value.absent(),
        lastError: Value(error.toString()),
      ),
    );
    await _database.customStatement(
      'UPDATE pending_updates_table SET attempts = attempts + 1 '
      'WHERE local_id = ?',
      [localId],
    );
  }
}
