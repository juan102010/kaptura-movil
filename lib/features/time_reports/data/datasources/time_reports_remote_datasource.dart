import 'package:dio/dio.dart';

import '../models/time_report_record_model.dart';

abstract class TimeReportsRemoteDataSource {
  Future<List<TimeReportRecordModel>> getTimeReports();
  Future<TimeReportRecordModel> updateTimeReport({
    required TimeReportRecordModel current,
    required String type,
    required String atIso,
    required String atLocal,
  });
}

class TimeReportsRemoteDataSourceImpl implements TimeReportsRemoteDataSource {
  TimeReportsRemoteDataSourceImpl({required this.apiDio});

  final Dio apiDio;

  @override
  Future<List<TimeReportRecordModel>> getTimeReports() async {
    final response = await apiDio.get(
      '/api/dynamicRow/get-data-table',
      queryParameters: {'nombre_de_tabla': 'time_reports'},
    );
    final body = _asMap(response.data);
    _ensureOk(body);
    final data = body['data'];
    if (data is! List) return const <TimeReportRecordModel>[];

    return data
        .whereType<Map>()
        .map(
          (item) =>
              TimeReportRecordModel.fromMap(Map<String, dynamic>.from(item)),
        )
        .where((item) => item.id.isNotEmpty)
        .toList(growable: false);
  }

  @override
  Future<TimeReportRecordModel> updateTimeReport({
    required TimeReportRecordModel current,
    required String type,
    required String atIso,
    required String atLocal,
  }) async {
    final response = await apiDio.put(
      '/api/dynamicRow/update-row',
      data: {
        'nombre_de_tabla': 'time_reports',
        'id': current.id,
        'data': {
          'type': {'oldValue': current.type, 'newValue': type},
          'atISO': {'oldValue': current.atIso, 'newValue': atIso},
          'atLocal': {'oldValue': current.atLocal, 'newValue': atLocal},
        },
      },
    );
    _ensureOk(_asMap(response.data));

    final updated = Map<String, dynamic>.from(current.rawData)
      ..['type'] = type
      ..['atISO'] = atIso
      ..['atLocal'] = atLocal;
    return TimeReportRecordModel.fromMap(updated);
  }

  Map<String, dynamic> _asMap(dynamic data) {
    if (data is Map) return Map<String, dynamic>.from(data);
    throw Exception('Respuesta invalida de time_reports.');
  }

  void _ensureOk(Map<String, dynamic> body) {
    if (body['status'] == true || body['code'] == 200) return;
    throw Exception(
      (body['message'] ?? 'No fue posible procesar time_reports.').toString(),
    );
  }
}
