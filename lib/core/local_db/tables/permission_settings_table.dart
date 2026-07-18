import 'package:drift/drift.dart';

class PermissionSettingsTable extends Table {
  TextColumn get id => text()();
  TextColumn get rawJson => text()();
  DateTimeColumn get cachedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
