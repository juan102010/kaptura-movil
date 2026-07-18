import 'package:drift/drift.dart';

class PendingUpdatesTable extends Table {
  IntColumn get localId => integer().autoIncrement()();
  TextColumn get targetTable => text()();
  TextColumn get recordId => text()();
  TextColumn get dataJson => text()();
  TextColumn get schemeOverride => text().nullable()();
  IntColumn get attempts => integer().withDefault(const Constant(0))();
  TextColumn get lastError => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
