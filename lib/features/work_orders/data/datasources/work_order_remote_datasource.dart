import 'package:dio/dio.dart';

class WorkOrderRemoteDataSource {
  WorkOrderRemoteDataSource(this._loginDio);

  final Dio _loginDio;

  Future<void> updateWorkOrderTimeHistoryDiff({
    required String workOrderId,
    required List<Map<String, dynamic>> oldValue,
    required List<Map<String, dynamic>> newValue,
  }) async {
    final resp = await _loginDio.put(
      '/api/dynamicRow/update-row',
      data: {
        'nombre_de_tabla': 'work_orders',
        'id': workOrderId,
        'data': {
          'text_dateTime_id': {'oldValue': oldValue, 'newValue': newValue},
        },
      },
    );

    final body = _asMap(resp.data);
    _ensureOk(body);
  }

  Map<String, dynamic> _asMap(dynamic data) {
    if (data is Map<String, dynamic>) return data;
    if (data is Map) return Map<String, dynamic>.from(data);
    return <String, dynamic>{};
  }

  void _ensureOk(Map<String, dynamic> body) {
    final success =
        body['success'] == true ||
        body['ok'] == true ||
        body['status'] == true ||
        body['code'] == 200;

    if (!success && body.isNotEmpty) {
      final message =
          (body['message'] ??
                  body['msg'] ??
                  body['error'] ??
                  'No fue posible actualizar la work order.')
              .toString();
      throw Exception(message);
    }
  }
}
