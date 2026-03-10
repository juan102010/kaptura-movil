import 'package:dio/dio.dart';

abstract class UsersRemoteDataSource {
  Future<List<Map<String, dynamic>>> getUsers();
}

class UsersRemoteDataSourceImpl implements UsersRemoteDataSource {
  final Dio apiDio;

  UsersRemoteDataSourceImpl({required this.apiDio});

  @override
  Future<List<Map<String, dynamic>>> getUsers() async {
    final response = await apiDio.get(
      '/api/v1/users/dynamicRowLogin/get-data-table',
      queryParameters: {'nombre_de_tabla': 'users'},
    );

    final responseData = response.data;

    if (responseData is! Map<String, dynamic>) {
      throw Exception('La respuesta de users no es un objeto JSON válido.');
    }

    final rawList = responseData['data'];

    if (rawList == null) {
      return [];
    }

    if (rawList is! List) {
      throw Exception('El campo data de users no contiene una lista válida.');
    }

    final users = <Map<String, dynamic>>[];

    for (final item in rawList) {
      if (item is! Map) continue;

      final userMap = Map<String, dynamic>.from(item);

      final id = userMap['_id'];
      if (id == null || id.toString().trim().isEmpty) {
        continue;
      }

      users.add(userMap);
    }

    return users;
  }
}
