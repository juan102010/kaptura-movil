import '../../../work_orders/domain/entities/work_order_entity.dart';
import '../../domain/entities/home_entity.dart';
import '../../domain/entities/time_report_entity.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_local_datasource.dart';
import '../datasources/home_remote_datasource.dart';
import '../models/work_order_model.dart';

class HomeRepositoryImpl implements HomeRepository {
  HomeRepositoryImpl(this._remote, this._local);

  final HomeRemoteDataSource _remote;
  final HomeLocalDataSource _local;

  @override
  Future<HomeEntity> getUserById({required String userId}) async {
    final model = await _remote.getUserById(userId: userId);
    return HomeEntity(
      id: model.id,
      name: model.name,
      stateClock: model.stateClock,
    );
  }

  @override
  Future<List<TimeReportEntity>> getTimeReports() {
    return _remote.getTimeReports();
  }

  @override
  Future<void> createTimeReport({required Map<String, dynamic> payload}) {
    return _remote.createTimeReport(payload: payload);
  }

  @override
  Future<void> updateUserStateClockDiff({
    required String userId,
    required Map<String, dynamic> diffPayload,
  }) {
    return _remote.updateUserStateClockDiff(
      userId: userId,
      diffPayload: diffPayload,
    );
  }

  @override
  Future<List<WorkOrderEntity>> getWorkOrdersRemote() {
    return _remote.getWorkOrders();
  }

  @override
  Future<void> saveWorkOrdersCache(List<WorkOrderEntity> workOrders) {
    final models = workOrders
        .map((workOrder) => WorkOrderModel.fromMap(workOrder.rawData))
        .toList();
    return _local.upsertWorkOrdersCache(models);
  }

  @override
  Future<List<WorkOrderEntity>> getWorkOrdersCache() {
    return _local.getWorkOrdersCacheRaw();
  }

  @override
  Future<void> clearWorkOrdersCache() {
    return _local.clearWorkOrdersCache();
  }
}
