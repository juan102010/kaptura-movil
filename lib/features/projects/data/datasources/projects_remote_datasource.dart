import 'package:dio/dio.dart';

class ProjectsRemoteDataSource {
  ProjectsRemoteDataSource({required Dio apiDio}) : _apiDio = apiDio;

  final Dio _apiDio;

  Map<String, dynamic> _asMap(dynamic data) {
    if (data is Map<String, dynamic>) return data;
    if (data is Map) return data.cast<String, dynamic>();
    throw Exception('Respuesta inesperada del servidor (no es Map).');
  }

  List<Map<String, dynamic>> _asListOfMap(dynamic data) {
    if (data is List) {
      return data
          .whereType<Map>()
          .map((e) => e.cast<String, dynamic>())
          .toList();
    }
    return <Map<String, dynamic>>[];
  }

  void _ensureOk(Map<String, dynamic> body) {
    final status = body['status'];
    if (status == true) return;

    final msg = (body['message'] ?? 'Error desconocido').toString();
    throw Exception(msg);
  }

  Future<List<Map<String, dynamic>>> getProjects() async {
    final resp = await _apiDio.get(
      '/api/dynamicRow/get-data-table',
      queryParameters: {'nombre_de_tabla': 'projects'},
    );

    final body = _asMap(resp.data);
    _ensureOk(body);

    return _asListOfMap(body['data']);
  }
}
