import 'package:dio/dio.dart';

import '../network/internet_monitor.dart';
import '../network/internet_status.dart';
import 'pending_update_store.dart';

enum UpdateDelivery { sent, queued }

class UpdateDataResult {
  const UpdateDataResult.sent(this.response) : delivery = UpdateDelivery.sent;
  const UpdateDataResult.queued()
    : delivery = UpdateDelivery.queued,
      response = null;

  final UpdateDelivery delivery;
  final dynamic response;

  bool get wasQueued => delivery == UpdateDelivery.queued;
}

class UpdateDataByIdService {
  UpdateDataByIdService({
    required Dio apiDio,
    required PendingUpdateStore pendingStore,
    required InternetMonitor internetMonitor,
  }) : _apiDio = apiDio,
       _pendingStore = pendingStore,
       _internetMonitor = internetMonitor;

  final Dio _apiDio;
  final PendingUpdateStore _pendingStore;
  final InternetMonitor _internetMonitor;

  Future<UpdateDataResult> update({
    required String tableName,
    required String id,
    required Map<String, Map<String, dynamic>> data,
    String? schemeOverride,
  }) async {
    if (_internetMonitor.lastStatus == InternetStatus.offline) {
      await _enqueue(tableName, id, data, schemeOverride);
      return const UpdateDataResult.queued();
    }

    try {
      final response = await sendNow(
        tableName: tableName,
        id: id,
        data: data,
        schemeOverride: schemeOverride,
      );
      return UpdateDataResult.sent(response);
    } on DioException catch (error) {
      if (!_isConnectivityFailure(error)) rethrow;
      await _enqueue(tableName, id, data, schemeOverride);
      return const UpdateDataResult.queued();
    }
  }

  Future<dynamic> sendNow({
    required String tableName,
    required String id,
    required Map<String, Map<String, dynamic>> data,
    String? schemeOverride,
  }) async {
    final response = await _apiDio.put<dynamic>(
      '/api/dynamicRow/update-row',
      data: {'nombre_de_tabla': tableName, 'id': id, 'data': data},
      options: Options(
        headers: {
          if (schemeOverride != null && schemeOverride.trim().isNotEmpty)
            'x-scheme-id': schemeOverride,
        },
      ),
    );
    return response.data;
  }

  Future<void> _enqueue(
    String tableName,
    String id,
    Map<String, Map<String, dynamic>> data,
    String? schemeOverride,
  ) => _pendingStore.enqueue(
    tableName: tableName,
    recordId: id,
    data: data,
    schemeOverride: schemeOverride,
  );

  bool _isConnectivityFailure(DioException error) => switch (error.type) {
    DioExceptionType.connectionTimeout ||
    DioExceptionType.sendTimeout ||
    DioExceptionType.receiveTimeout ||
    DioExceptionType.connectionError => true,
    _ => false,
  };
}
