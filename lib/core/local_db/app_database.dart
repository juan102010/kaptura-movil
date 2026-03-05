import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'tables/work_orders_table.dart';
import 'tables/customers_table.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [WorkOrdersTable, CustomersTable])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
    },
    onUpgrade: (m, from, to) async {
      // v1 -> v2: columnas nuevas en work_orders
      if (from < 2) {
        await m.addColumn(workOrdersTable, workOrdersTable.rawJson);
        await m.addColumn(workOrdersTable, workOrdersTable.startAt);
        await m.addColumn(workOrdersTable, workOrdersTable.endAt);
      }

      // v2 -> v3: crear tabla customers
      if (from < 3) {
        await m.createTable(customersTable);
      }
    },
  );
}

QueryExecutor _openConnection() {
  return driftDatabase(name: 'kaptura_app');
}
