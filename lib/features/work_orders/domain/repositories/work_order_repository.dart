abstract class WorkOrderRepository {
  Future<void> updateWorkOrderTimeHistoryDiff({
    required String workOrderId,
    required List<Map<String, dynamic>> oldValue,
    required List<Map<String, dynamic>> newValue,
  });
}
