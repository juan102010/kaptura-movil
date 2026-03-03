import '../../domain/entities/home_entity.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_remote_datasource.dart';
import '../datasources/home_local_datasource.dart';

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
  Future<List<Map<String, dynamic>>> getTimeReports() {
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
  Future<List<Map<String, dynamic>>> getWorkOrdersRemote() {
    return _remote.getWorkOrders();
  }

  @override
  Future<void> saveWorkOrdersCache(List<Map<String, dynamic>> rawWorkOrders) {
    return _local.upsertWorkOrdersCache(rawWorkOrders);
  }

  @override
  Future<List<Map<String, dynamic>>> getWorkOrdersCache() {
    return _local.getWorkOrdersCacheRaw();
  }

  @override
  Future<void> clearWorkOrdersCache() {
    return _local.clearWorkOrdersCache();
  }
}
