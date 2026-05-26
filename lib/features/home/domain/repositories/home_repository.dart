import '../../../work_orders/domain/entities/work_order_entity.dart';
import '../entities/home_entity.dart';
import '../entities/time_report_entity.dart';

abstract class HomeRepository {
  Future<HomeEntity> getUserById({required String userId});

  Future<List<TimeReportEntity>> getTimeReports();

  Future<void> createTimeReport({required Map<String, dynamic> payload});

  Future<void> updateUserStateClockDiff({
    required String userId,
    required Map<String, dynamic> diffPayload,
  });

  Future<List<WorkOrderEntity>> getWorkOrdersRemote();

  Future<void> saveWorkOrdersCache(List<WorkOrderEntity> workOrders);
  Future<List<WorkOrderEntity>> getWorkOrdersCache();
  Future<void> clearWorkOrdersCache();
}
