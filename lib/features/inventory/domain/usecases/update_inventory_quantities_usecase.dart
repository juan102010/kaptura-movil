import '../entities/inventory_item_entity.dart';
import '../repositories/inventory_repository.dart';

class UpdateInventoryQuantitiesUsecase {
  UpdateInventoryQuantitiesUsecase(this._repository);

  final InventoryRepository _repository;

  Future<InventoryItemEntity> call({
    required InventoryItemEntity currentItem,
    required int newDefaultQty,
    required int newStockMin,
  }) {
    return _repository.updateInventoryQuantities(
      currentItem: currentItem,
      newDefaultQty: newDefaultQty,
      newStockMin: newStockMin,
    );
  }
}
