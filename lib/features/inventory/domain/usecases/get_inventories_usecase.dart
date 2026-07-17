import '../entities/inventory_item_entity.dart';
import '../repositories/inventory_repository.dart';

class GetInventoriesUsecase {
  GetInventoriesUsecase(this._repository);

  final InventoryRepository _repository;

  Future<List<InventoryItemEntity>> call() async {
    final remote = await _repository.getRemoteInventories();
    await _repository.cacheInventories(remote);
    return remote;
  }
}
