import '../entities/home_entity.dart';

abstract class HomeRepository {
  Future<HomeEntity> getUserById({required String userId});

  Future<List<Map<String, dynamic>>> getTimeReports();

  Future<void> createTimeReport({required Map<String, dynamic> payload});

  Future<void> updateUserStateClockDiff({
    required String userId,
    required Map<String, dynamic> diffPayload,
  });
  Future<List<Map<String, dynamic>>> getWorkOrdersRemote();

  // Cache local
  Future<void> saveWorkOrdersCache(List<Map<String, dynamic>> rawWorkOrders);
  Future<List<Map<String, dynamic>>> getWorkOrdersCache();
  Future<void> clearWorkOrdersCache();
}
