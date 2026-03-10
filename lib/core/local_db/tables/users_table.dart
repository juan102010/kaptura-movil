import 'package:drift/drift.dart';

class UsersTable extends Table {
  TextColumn get id => text()();

  TextColumn get rawJson => text()();

  DateTimeColumn get cachedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
