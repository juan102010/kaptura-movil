import 'package:drift/drift.dart';

class WorkOrdersTable extends Table {
  // _id del backend
  TextColumn get id => text()();

  // text_nameWorkOrder_id
  TextColumn get name => text().withDefault(const Constant(''))();

  // Normalizado a JSON string: ["userId1","userId2"]
  TextColumn get assignedIdsJson => text().withDefault(const Constant('[]'))();

  // ✅ NUEVO: objeto completo (JSON string)
  TextColumn get rawJson => text().withDefault(const Constant('{}'))();

  // ✅ NUEVO (recomendado): fechas para filtrar "hoy" sin decodificar JSON
  DateTimeColumn get startAt => dateTime().nullable()();
  DateTimeColumn get endAt => dateTime().nullable()();

  // Para control de cache (opcional pero recomendado)
  DateTimeColumn get cachedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
