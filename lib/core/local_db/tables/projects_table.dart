import 'package:drift/drift.dart';

class ProjectsTable extends Table {
  TextColumn get id => text()(); // _id del backend
  TextColumn get rawJson => text()(); // objeto completo serializado
  DateTimeColumn get cachedAt => dateTime()(); // fecha local de cache

  @override
  Set<Column> get primaryKey => {id};
}
