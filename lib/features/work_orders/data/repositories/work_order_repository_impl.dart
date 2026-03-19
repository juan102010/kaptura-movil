import '../../domain/repositories/work_order_repository.dart';
import '../datasources/work_order_remote_datasource.dart';

class WorkOrderRepositoryImpl implements WorkOrderRepository {
  WorkOrderRepositoryImpl(this._remoteDataSource);

  final WorkOrderRemoteDataSource _remoteDataSource;

  @override
  Future<void> updateWorkOrderTimeHistoryDiff({
    required String workOrderId,
    required List<Map<String, dynamic>> oldValue,
    required List<Map<String, dynamic>> newValue,
  }) {
    return _remoteDataSource.updateWorkOrderTimeHistoryDiff(
      workOrderId: workOrderId,
      oldValue: oldValue,
      newValue: newValue,
    );
  }
}
