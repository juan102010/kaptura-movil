import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'tables/work_orders_table.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [WorkOrdersTable])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
    },
    onUpgrade: (m, from, to) async {
      // ✅ Si vienes de v1 -> v2: agregamos columnas nuevas
      if (from < 2) {
        await m.addColumn(workOrdersTable, workOrdersTable.rawJson);
        await m.addColumn(workOrdersTable, workOrdersTable.startAt);
        await m.addColumn(workOrdersTable, workOrdersTable.endAt);
      }
    },
  );
}

QueryExecutor _openConnection() {
  return driftDatabase(name: 'kaptura_app');
}
