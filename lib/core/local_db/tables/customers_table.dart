import 'package:drift/drift.dart';

class CustomersTable extends Table {
  // _id del backend
  TextColumn get id => text()();

  // ✅ Objeto completo (JSON string) tal cual viene en body['data'][i]
  TextColumn get rawJson => text().withDefault(const Constant('{}'))();

  // Control de cache
  DateTimeColumn get cachedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
