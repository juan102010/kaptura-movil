import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'tables/work_orders_table.dart';
import 'tables/customers_table.dart';
import 'tables/projects_table.dart';
import 'tables/users_table.dart';
import 'tables/inventories_table.dart';
import 'tables/permission_settings_table.dart';
import 'tables/time_reports_table.dart';
import 'tables/pending_updates_table.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    WorkOrdersTable,
    CustomersTable,
    ProjectsTable,
    UsersTable,
    InventoriesTable,
    PermissionSettingsTable,
    TimeReportsTable,
    PendingUpdatesTable,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 9;

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

      // v3 -> v4: crear tabla projects
      if (from < 4) {
        await m.createTable(projectsTable);
      }

      // v4 -> v5: crear tabla users
      if (from < 5) {
        await m.createTable(usersTable);
      }

      // v5 -> v6: crear tabla inventories
      if (from < 6) {
        await m.createTable(inventoriesTable);
      }

      // v6 -> v7: crear cache de permisos
      if (from < 7) {
        await m.createTable(permissionSettingsTable);
      }

      // v7 -> v8: crear cache de reportes de tiempo
      if (from < 8) {
        await m.createTable(timeReportsTable);
      }

      // v8 -> v9: cola de actualizaciones para sincronizacion offline
      if (from < 9) {
        await m.createTable(pendingUpdatesTable);
      }
    },
  );
}

QueryExecutor _openConnection() {
  return driftDatabase(name: 'kaptura_app');
}
