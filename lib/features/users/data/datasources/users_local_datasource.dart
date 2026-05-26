import 'dart:convert';

import 'package:drift/drift.dart';

import '../../../../core/local_db/app_database.dart';
import '../models/user_list_model.dart';

abstract class UsersLocalDataSource {
  Future<List<UserListModel>> getCachedUsers();
  Future<void> cacheUsers(List<UserListModel> users);
  Future<void> clearUsers();
}

class UsersLocalDataSourceImpl implements UsersLocalDataSource {
  UsersLocalDataSourceImpl({required this.database});

  final AppDatabase database;

  @override
  Future<List<UserListModel>> getCachedUsers() async {
    final rows = await database.select(database.usersTable).get();
    final users = <UserListModel>[];

    for (final row in rows) {
      try {
        final decoded = jsonDecode(row.rawJson);
        if (decoded is Map<String, dynamic>) {
          final id = decoded['_id'];
          if (id != null && id.toString().trim().isNotEmpty) {
            users.add(UserListModel.fromMap(decoded));
          }
        }
      } catch (_) {}
    }

    return users;
  }

  @override
  Future<void> cacheUsers(List<UserListModel> users) async {
    await database.batch((batch) {
      batch.insertAll(
        database.usersTable,
        users
            .where((user) => user.id.trim().isNotEmpty)
            .map(
              (user) => UsersTableCompanion.insert(
                id: user.id,
                rawJson: jsonEncode(user.toMap()),
                cachedAt: DateTime.now(),
              ),
            )
            .toList(),
        mode: InsertMode.insertOrReplace,
      );
    });
  }

  @override
  Future<void> clearUsers() async {
    await database.delete(database.usersTable).go();
  }
}
