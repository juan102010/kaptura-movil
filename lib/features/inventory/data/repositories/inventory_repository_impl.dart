import '../../domain/entities/inventory_item_entity.dart';
import '../../domain/repositories/inventory_repository.dart';
import '../datasources/inventory_local_datasource.dart';
import '../datasources/inventory_remote_datasource.dart';
import '../models/inventory_item_model.dart';

class InventoryRepositoryImpl implements InventoryRepository {
  InventoryRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  final InventoryRemoteDataSource remoteDataSource;
  final InventoryLocalDataSource localDataSource;

  @override
  Future<List<InventoryItemEntity>> getCachedInventories() {
    return localDataSource.getCachedInventories();
  }

  @override
  Future<List<InventoryItemEntity>> getRemoteInventories() {
    return remoteDataSource.getInventories();
  }

  @override
  Future<void> cacheInventories(List<InventoryItemEntity> items) {
    return localDataSource.cacheInventories(
      items.map((item) => InventoryItemModel.fromMap(item.rawData)).toList(),
    );
  }

  @override
  Future<InventoryItemEntity> updateInventoryQuantities({
    required InventoryItemEntity currentItem,
    required int newDefaultQty,
    required int newStockMin,
  }) async {
    final updated = await remoteDataSource.updateInventoryQuantities(
      currentItem: InventoryItemModel.fromMap(currentItem.rawData),
      newDefaultQty: newDefaultQty,
      newStockMin: newStockMin,
    );

    await localDataSource.upsertInventory(updated);
    return updated;
  }

  @override
  Future<void> clearInventories() {
    return localDataSource.clearInventories();
  }
}
