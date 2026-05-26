import 'dart:convert';

import 'package:drift/drift.dart';

import '../../../../core/local_db/app_database.dart';
import '../models/work_order_model.dart';

abstract class HomeLocalDataSource {
  Future<void> upsertWorkOrdersCache(List<WorkOrderModel> workOrders);
  Future<List<WorkOrderModel>> getWorkOrdersCacheRaw();
  Future<void> clearWorkOrdersCache();
}

class HomeLocalDataSourceImpl implements HomeLocalDataSource {
  HomeLocalDataSourceImpl(this._db);

  final AppDatabase _db;

  @override
  Future<void> upsertWorkOrdersCache(List<WorkOrderModel> workOrders) async {
    if (workOrders.isEmpty) return;

    await _db.batch((batch) {
      batch.insertAllOnConflictUpdate(
        _db.workOrdersTable,
        workOrders
            .map((workOrder) {
              final id = workOrder.id.trim();
              if (id.isEmpty) return null;

              return WorkOrdersTableCompanion(
                id: Value(id),
                name: Value(workOrder.name),
                assignedIdsJson: Value(jsonEncode(workOrder.assignedIds)),
                rawJson: Value(_safeEncodeMap(workOrder.toMap())),
                startAt: Value(workOrder.startAt),
                endAt: Value(workOrder.endAt),
              );
            })
            .whereType<WorkOrdersTableCompanion>()
            .toList(),
      );
    });
  }

  @override
  Future<List<WorkOrderModel>> getWorkOrdersCacheRaw() async {
    final rows = await _db.select(_db.workOrdersTable).get();

    return rows.map((row) {
      final map = _safeDecodeMap(row.rawJson);
      map['_id'] ??= row.id;
      map['text_nameWorkOrder_id'] ??= row.name;
      map['text_assigned_id'] ??= _safeDecodeList(row.assignedIdsJson);
      map['cachedAt'] = row.cachedAt.toIso8601String();

      if (row.startAt != null) {
        map['__local_startAt'] = row.startAt!.toIso8601String();
      }
      if (row.endAt != null) {
        map['__local_endAt'] = row.endAt!.toIso8601String();
      }

      return WorkOrderModel.fromMap(map);
    }).toList();
  }

  @override
  Future<void> clearWorkOrdersCache() async {
    await _db.delete(_db.workOrdersTable).go();
  }

  String _safeEncodeMap(Map<String, dynamic> map) {
    try {
      return jsonEncode(map);
    } catch (_) {
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
            .map((item) => item.toString().trim())
            .where((item) => item.isNotEmpty)
            .toList();
      }
      return <String>[];
    } catch (_) {
      return <String>[];
    }
  }
}
