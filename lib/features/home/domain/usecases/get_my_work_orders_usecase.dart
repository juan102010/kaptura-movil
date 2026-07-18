import '../../../work_orders/domain/entities/work_order_entity.dart';
import '../repositories/home_repository.dart';

class GetMyWorkOrdersUsecase {
  GetMyWorkOrdersUsecase(this._repo);

  final HomeRepository _repo;

  Future<List<WorkOrderEntity>> call({required String userId}) async {
    final remote = await _repo.getWorkOrdersRemote();
    final filtered = _filterByAssigned(remote, userId);
    await _repo.saveWorkOrdersCache(filtered);
    return filtered;
  }

  Future<List<WorkOrderEntity>> getCached() async {
    return _repo.getWorkOrdersCache();
  }

  Future<void> saveCached(List<WorkOrderEntity> workOrders) {
    return _repo.saveWorkOrdersCache(workOrders);
  }

  List<WorkOrderEntity> _filterByAssigned(
    List<WorkOrderEntity> list,
    String userId,
  ) {
    return list.where((row) => row.assignedIds.contains(userId)).toList();
  }
}
