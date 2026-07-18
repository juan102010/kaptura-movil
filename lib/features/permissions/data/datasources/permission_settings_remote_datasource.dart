import 'package:dio/dio.dart';

import '../models/permission_setting_model.dart';

abstract class PermissionSettingsRemoteDataSource {
  Future<List<PermissionSettingModel>> getPermissionSettings();
}

class PermissionSettingsRemoteDataSourceImpl
    implements PermissionSettingsRemoteDataSource {
  PermissionSettingsRemoteDataSourceImpl({required this.apiDio});

  final Dio apiDio;

  @override
  Future<List<PermissionSettingModel>> getPermissionSettings() async {
    final response = await apiDio.get(
      '/api/dynamicRow/get-data-table',
      queryParameters: {'nombre_de_tabla': 'permission settings'},
    );

    final body = response.data is Map
        ? Map<String, dynamic>.from(response.data as Map)
        : <String, dynamic>{};
    final success = body['status'] == true || body['code'] == 200;
    if (!success) {
      throw Exception(
        (body['message'] ?? 'No fue posible consultar permission settings.')
            .toString(),
      );
    }

    final data = body['data'];
    if (data is! List) return const <PermissionSettingModel>[];

    return data
        .whereType<Map>()
        .map(
          (item) =>
              PermissionSettingModel.fromMap(Map<String, dynamic>.from(item)),
        )
        .where((permission) => permission.id.isNotEmpty)
        .toList(growable: false);
  }
}
