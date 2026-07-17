import 'dart:convert';

import 'package:drift/drift.dart';

import '../../../../core/local_db/app_database.dart';
import '../models/inventory_item_model.dart';

abstract class InventoryLocalDataSource {
  Future<List<InventoryItemModel>> getCachedInventories();
  Future<void> cacheInventories(List<InventoryItemModel> items);
  Future<void> upsertInventory(InventoryItemModel item);
  Future<void> clearInventories();
}

class InventoryLocalDataSourceImpl implements InventoryLocalDataSource {
  InventoryLocalDataSourceImpl({required this.database});

  final AppDatabase database;

  @override
  Future<List<InventoryItemModel>> getCachedInventories() async {
    final rows = await database.select(database.inventoriesTable).get();
    final items = <InventoryItemModel>[];

    for (final row in rows) {
      try {
        final decoded = jsonDecode(row.rawJson);
        if (decoded is Map<String, dynamic>) {
          items.add(InventoryItemModel.fromMap(decoded));
        } else if (decoded is Map) {
          items.add(
            InventoryItemModel.fromMap(Map<String, dynamic>.from(decoded)),
          );
        }
      } catch (_) {}
    }

    return items;
  }

  @override
  Future<void> cacheInventories(List<InventoryItemModel> items) async {
    await database.batch((batch) {
      batch.insertAll(
        database.inventoriesTable,
        items
            .where((item) => item.id.trim().isNotEmpty)
            .map(
              (item) => InventoriesTableCompanion.insert(
                id: item.id,
                rawJson: jsonEncode(item.toMap()),
                cachedAt: DateTime.now(),
              ),
            )
            .toList(),
        mode: InsertMode.insertOrReplace,
      );
    });
  }

  @override
  Future<void> upsertInventory(InventoryItemModel item) async {
    if (item.id.trim().isEmpty) return;

    await database
        .into(database.inventoriesTable)
        .insert(
          InventoriesTableCompanion.insert(
            id: item.id,
            rawJson: jsonEncode(item.toMap()),
            cachedAt: DateTime.now(),
          ),
          mode: InsertMode.insertOrReplace,
        );
  }

  @override
  Future<void> clearInventories() async {
    await database.delete(database.inventoriesTable).go();
  }
}
