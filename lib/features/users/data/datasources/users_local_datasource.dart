import 'dart:convert';

import 'package:drift/drift.dart';

import '../../../../core/local_db/app_database.dart';

abstract class UsersLocalDataSource {
  Future<List<Map<String, dynamic>>> getCachedUsers();
  Future<void> cacheUsers(List<Map<String, dynamic>> users);
  Future<void> clearUsers();
}

class UsersLocalDataSourceImpl implements UsersLocalDataSource {
  final AppDatabase database;

  UsersLocalDataSourceImpl({required this.database});

  @override
  Future<List<Map<String, dynamic>>> getCachedUsers() async {
    final rows = await database.select(database.usersTable).get();

    final users = <Map<String, dynamic>>[];

    for (final row in rows) {
      try {
        final decoded = jsonDecode(row.rawJson);

        if (decoded is Map<String, dynamic>) {
          final id = decoded['_id'];
          if (id != null && id.toString().trim().isNotEmpty) {
            users.add(decoded);
          }
        }
      } catch (_) {
        // Ignora registros corruptos o JSON inválido
      }
    }

    return users;
  }

  @override
  Future<void> cacheUsers(List<Map<String, dynamic>> users) async {
    await database.batch((batch) {
      batch.insertAll(
        database.usersTable,
        users
            .where((user) {
              final id = user['_id'];
              return id != null && id.toString().trim().isNotEmpty;
            })
            .map(
              (user) => UsersTableCompanion.insert(
                id: user['_id'].toString(),
                rawJson: jsonEncode(user),
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
