import 'dart:convert';

import 'package:drift/drift.dart';

import '../../../../core/local_db/app_database.dart';

abstract class CustomersLocalDataSource {
  Future<void> upsertCustomersCache(List<Map<String, dynamic>> rawCustomers);
  Future<List<Map<String, dynamic>>> getCustomersCacheRaw();
  Future<void> clearCustomersCache();
}

class CustomersLocalDataSourceImpl implements CustomersLocalDataSource {
  CustomersLocalDataSourceImpl(this._db);

  final AppDatabase _db;

  @override
  Future<void> upsertCustomersCache(
    List<Map<String, dynamic>> rawCustomers,
  ) async {
    if (rawCustomers.isEmpty) return;

    await _db.batch((batch) {
      batch.insertAllOnConflictUpdate(
        _db.customersTable,
        rawCustomers
            .map((e) {
              final id = (e['_id'] ?? '').toString().trim();
              if (id.isEmpty) return null;

              final rawJson = _safeEncodeMap(e);

              return CustomersTableCompanion(
                id: Value(id),
                rawJson: Value(rawJson),
                // cachedAt queda al default currentDateAndTime()
              );
            })
            .whereType<CustomersTableCompanion>()
            .toList(),
      );
    });
  }

  @override
  Future<List<Map<String, dynamic>>> getCustomersCacheRaw() async {
    final rows = await _db.select(_db.customersTable).get();

    return rows.map((r) {
      final map = _safeDecodeMap(r.rawJson);

      // Aseguramos el _id
      map['_id'] ??= r.id;

      // Metadata local útil
      map['cachedAt'] = r.cachedAt.toIso8601String();

      return map;
    }).toList();
  }

  @override
  Future<void> clearCustomersCache() async {
    await _db.delete(_db.customersTable).go();
  }

  // ============================
  // Helpers
  // ============================

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
}
