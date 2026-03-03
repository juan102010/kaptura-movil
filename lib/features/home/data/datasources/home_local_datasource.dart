import 'dart:convert';

import '../../../../core/local_db/app_database.dart';
import 'package:drift/drift.dart';

abstract class HomeLocalDataSource {
  Future<void> upsertWorkOrdersCache(List<Map<String, dynamic>> rawWorkOrders);
  Future<List<Map<String, dynamic>>> getWorkOrdersCacheRaw();
  Future<void> clearWorkOrdersCache();
}

class HomeLocalDataSourceImpl implements HomeLocalDataSource {
  HomeLocalDataSourceImpl(this._db);

  final AppDatabase _db;

  @override
  Future<void> upsertWorkOrdersCache(
    List<Map<String, dynamic>> rawWorkOrders,
  ) async {
    if (rawWorkOrders.isEmpty) return;

    await _db.batch((batch) {
      batch.insertAllOnConflictUpdate(
        _db.workOrdersTable,
        rawWorkOrders
            .map((e) {
              final id = (e['_id'] ?? '').toString();

              // text_nameWorkOrder_id
              final name = (e['text_nameWorkOrder_id'] ?? '').toString();

              // text_assigned_id: puede ser String o List
              final assigned = e['text_assigned_id'];
              final assignedList = _normalizeAssignedIds(assigned);

              return WorkOrdersTableCompanion(
                id: Value(id),
                name: Value(name),
                assignedIdsJson: Value(jsonEncode(assignedList)),
                // cachedAt lo dejamos que lo ponga el default de la DB
              );
            })
            .where((row) => row.id.value.isNotEmpty)
            .toList(),
      );
    });
  }

  @override
  Future<List<Map<String, dynamic>>> getWorkOrdersCacheRaw() async {
    final rows = await _db.select(_db.workOrdersTable).get();

    // devolvemos algo parecido a tu API (raw) para que sea fácil integrar luego
    return rows.map((r) {
      final assignedList = _safeDecodeList(r.assignedIdsJson);

      return <String, dynamic>{
        '_id': r.id,
        'text_nameWorkOrder_id': r.name,
        'text_assigned_id': assignedList,
        'cachedAt': r.cachedAt.toIso8601String(),
      };
    }).toList();
  }

  @override
  Future<void> clearWorkOrdersCache() async {
    await _db.delete(_db.workOrdersTable).go();
  }

  // ============================
  // Helpers
  // ============================

  List<String> _normalizeAssignedIds(dynamic assigned) {
    if (assigned == null) return <String>[];

    if (assigned is String) {
      final v = assigned.trim();
      if (v.isEmpty) return <String>[];
      return <String>[v];
    }

    if (assigned is List) {
      return assigned
          .map((e) => e.toString().trim())
          .where((e) => e.isNotEmpty)
          .toList();
    }

    return <String>[];
  }

  List<String> _safeDecodeList(String jsonStr) {
    try {
      final decoded = jsonDecode(jsonStr);
      if (decoded is List) {
        return decoded
            .map((e) => e.toString().trim())
            .where((e) => e.isNotEmpty)
            .toList();
      }
      return <String>[];
    } catch (_) {
      return <String>[];
    }
  }
}
