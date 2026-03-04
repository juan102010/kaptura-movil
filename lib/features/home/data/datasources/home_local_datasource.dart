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
              final id = (e['_id'] ?? '').toString().trim();
              if (id.isEmpty) return null;

              // text_nameWorkOrder_id
              final name = (e['text_nameWorkOrder_id'] ?? '').toString();

              // text_assigned_id: puede ser String o List
              final assigned = e['text_assigned_id'];
              final assignedList = _normalizeAssignedIds(assigned);

              // ✅ NUEVO: guardar TODO el objeto como JSON
              final rawJson = _safeEncodeMap(e);

              // ✅ NUEVO: fechas (para filtro "hoy")
              final startAt = _parseIsoDateTime(e['date_start_id']);
              final endAt = _parseIsoDateTime(e['date_end_id']);

              return WorkOrdersTableCompanion(
                id: Value(id),
                name: Value(name),
                assignedIdsJson: Value(jsonEncode(assignedList)),
                rawJson: Value(rawJson),
                startAt: Value(startAt),
                endAt: Value(endAt),
                // cachedAt lo dejamos al default de la DB
              );
            })
            .whereType<WorkOrdersTableCompanion>()
            .toList(),
      );
    });
  }

  @override
  Future<List<Map<String, dynamic>>> getWorkOrdersCacheRaw() async {
    final rows = await _db.select(_db.workOrdersTable).get();

    return rows.map((r) {
      // ✅ Preferimos el objeto completo desde rawJson
      final map = _safeDecodeMap(r.rawJson);

      // Aseguramos que tenga _id (por si el JSON estaba vacío por alguna razón)
      map['_id'] ??= r.id;

      // Opcional: asegurar algunos campos mínimos coherentes
      map['text_nameWorkOrder_id'] ??= r.name;

      // Si quieres seguir garantizando assigned como List, lo inyectamos
      map['text_assigned_id'] ??= _safeDecodeList(r.assignedIdsJson);

      // Metadata local útil (no rompe backend)
      map['cachedAt'] = r.cachedAt.toIso8601String();

      // También podemos exponer start/end ya parseados (útil en UI)
      if (r.startAt != null) {
        map['__local_startAt'] = r.startAt!.toIso8601String();
      }
      if (r.endAt != null) {
        map['__local_endAt'] = r.endAt!.toIso8601String();
      }

      return map;
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

  DateTime? _parseIsoDateTime(dynamic value) {
    if (value == null) return null;

    final s = value.toString().trim();
    if (s.isEmpty) return null;

    // Backend te manda ISO con Z: 2025-11-19T11:00:00.000Z
    // DateTime.parse lo soporta.
    try {
      return DateTime.parse(s);
    } catch (_) {
      return null;
    }
  }

  String _safeEncodeMap(Map<String, dynamic> map) {
    try {
      return jsonEncode(map);
    } catch (_) {
      // si algo raro no es encodable, evitamos romper el cache
      return '{}';
    }
  }

  Map<String, dynamic> _safeDecodeMap(String jsonStr) {
    try {
      final decoded = jsonDecode(jsonStr);
      if (decoded is Map) return decoded.cast<String, dynamic>();
      return <String, dynamic>{};
    } catch (_) {
      return <String, dynamic>{};
    }
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
