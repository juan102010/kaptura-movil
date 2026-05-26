import 'dart:convert';

import 'package:drift/drift.dart';

import '../../../../core/local_db/app_database.dart';
import '../models/customer_model.dart';

abstract class CustomersLocalDataSource {
  Future<void> upsertCustomersCache(List<CustomerModel> customers);
  Future<List<CustomerModel>> getCustomersCacheRaw();
  Future<void> clearCustomersCache();
}

class CustomersLocalDataSourceImpl implements CustomersLocalDataSource {
  CustomersLocalDataSourceImpl(this._db);

  final AppDatabase _db;

  @override
  Future<void> upsertCustomersCache(List<CustomerModel> customers) async {
    if (customers.isEmpty) return;

    await _db.batch((batch) {
      batch.insertAllOnConflictUpdate(
        _db.customersTable,
        customers
            .map((customer) {
              final id = customer.id.trim();
              if (id.isEmpty) return null;

              return CustomersTableCompanion(
                id: Value(id),
                rawJson: Value(_safeEncodeMap(customer.toMap())),
              );
            })
            .whereType<CustomersTableCompanion>()
            .toList(),
      );
    });
  }

  @override
  Future<List<CustomerModel>> getCustomersCacheRaw() async {
    final rows = await _db.select(_db.customersTable).get();

    return rows.map((row) {
      final map = _safeDecodeMap(row.rawJson);
      map['_id'] ??= row.id;
      map['cachedAt'] = row.cachedAt.toIso8601String();
      return CustomerModel.fromMap(map);
    }).toList();
  }

  @override
  Future<void> clearCustomersCache() async {
    await _db.delete(_db.customersTable).go();
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
}
