import '../../../../core/services/update_data_by_id_service.dart';

class WorkOrderRemoteDataSource {
  WorkOrderRemoteDataSource(this._updateService);

  final UpdateDataByIdService _updateService;

  Future<void> updateWorkOrderTimeHistoryDiff({
    required String workOrderId,
    required List<Map<String, dynamic>> oldValue,
    required List<Map<String, dynamic>> newValue,
  }) async {
    await _updateService.update(
      tableName: 'work_orders',
      id: workOrderId,
      data: {
        'text_dateTime_id': {'oldValue': oldValue, 'newValue': newValue},
      },
    );
  }
}
