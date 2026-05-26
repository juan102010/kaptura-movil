import 'package:dio/dio.dart';

import '../models/user_list_model.dart';

abstract class UsersRemoteDataSource {
  Future<List<UserListModel>> getUsers();
}

class UsersRemoteDataSourceImpl implements UsersRemoteDataSource {
  UsersRemoteDataSourceImpl({required this.apiDio});

  final Dio apiDio;

  @override
  Future<List<UserListModel>> getUsers() async {
    final response = await apiDio.get(
      '/api/v1/users/dynamicRowLogin/get-data-table',
      queryParameters: {'nombre_de_tabla': 'users'},
    );

    final responseData = response.data;

    if (responseData is! Map<String, dynamic>) {
      throw Exception('La respuesta de users no es un objeto JSON valido.');
    }

    final rawList = responseData['data'];

    if (rawList == null) return [];
    if (rawList is! List) {
      throw Exception('El campo data de users no contiene una lista valida.');
    }

    final users = <UserListModel>[];

    for (final item in rawList) {
      if (item is! Map) continue;

      final userMap = Map<String, dynamic>.from(item);
      final id = userMap['_id'];
      if (id == null || id.toString().trim().isEmpty) {
        continue;
      }

      users.add(UserListModel.fromMap(userMap));
    }

    return users;
  }
}
