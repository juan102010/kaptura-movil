import '../entities/inventory_item_entity.dart';

abstract class InventoryRepository {
  Future<List<InventoryItemEntity>> getCachedInventories();
  Future<List<InventoryItemEntity>> getRemoteInventories();
  Future<void> cacheInventories(List<InventoryItemEntity> items);
  Future<InventoryItemEntity> updateInventoryQuantities({
    required InventoryItemEntity currentItem,
    required int newDefaultQty,
    required int newStockMin,
  });
  Future<void> clearInventories();
}
