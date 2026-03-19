import '../repositories/work_order_repository.dart';

class UpdateWorkOrderTimeHistoryUsecase {
  UpdateWorkOrderTimeHistoryUsecase(this._repository);

  final WorkOrderRepository _repository;

  Future<void> call({
    required String workOrderId,
    required List<Map<String, dynamic>> oldValue,
    required List<Map<String, dynamic>> newValue,
  }) {
    return _repository.updateWorkOrderTimeHistoryDiff(
      workOrderId: workOrderId,
      oldValue: oldValue,
      newValue: newValue,
    );
  }
}
