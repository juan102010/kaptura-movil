import 'package:dio/dio.dart';

import '../models/user_model.dart';

abstract class HomeRemoteDataSource {
  Future<UserModel> getUserById({required String userId});

  Future<List<Map<String, dynamic>>> getTimeReports();

  Future<void> createTimeReport({required Map<String, dynamic> payload});

  Future<void> updateUserStateClockDiff({
    required String userId,
    required Map<String, dynamic> diffPayload,
  });
  Future<List<Map<String, dynamic>>> getWorkOrders();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  HomeRemoteDataSourceImpl({required Dio loginDio, required Dio apiDio})
    : _loginDio = loginDio,
      _apiDio = apiDio;

  final Dio _loginDio;
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

  @override
  Future<List<Map<String, dynamic>>> getWorkOrders() async {
    final resp = await _apiDio.get(
      '/api/dynamicRow/get-data-table',
      queryParameters: {'nombre_de_tabla': 'work_orders'},
    );

    final body = _asMap(resp.data);
    _ensureOk(body);

    return _asListOfMap(body['data']);
  }

  @override
  Future<UserModel> getUserById({required String userId}) async {
    final resp = await _loginDio.get(
      '/api/v1/users/dynamicRowLogin/get-by-id',
      queryParameters: {'nombre_de_tabla': 'users', 'id': userId},
    );

    final body = _asMap(resp.data);
    _ensureOk(body);

    final data = _asMap(body['data']);
    return UserModel.fromJson(data);
  }

  @override
  Future<List<Map<String, dynamic>>> getTimeReports() async {
    final resp = await _apiDio.get(
      '/api/dynamicRow/get-data-table',
      queryParameters: {'nombre_de_tabla': 'time_reports'},
    );

    final body = _asMap(resp.data);
    _ensureOk(body);

    return _asListOfMap(body['data']);
  }

  @override
  Future<void> createTimeReport({required Map<String, dynamic> payload}) async {
    final resp = await _apiDio.post(
      '/api/dynamicRow/create-row',
      data: {'nombre_de_tabla': 'time_reports', 'data': payload},
    );

    final body = _asMap(resp.data);
    _ensureOk(body);
  }

  @override
  Future<void> updateUserStateClockDiff({
    required String userId,
    required Map<String, dynamic> diffPayload,
  }) async {
    final resp = await _loginDio.put(
      '/api/v1/users/dynamicRowLogin/update-row',
      data: {'nombre_de_tabla': 'users', 'id': userId, 'data': diffPayload},
    );

    final body = _asMap(resp.data);
    _ensureOk(body);
  }
}
