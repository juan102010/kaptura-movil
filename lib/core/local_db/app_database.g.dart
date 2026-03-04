// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $WorkOrdersTableTable extends WorkOrdersTable
    with TableInfo<$WorkOrdersTableTable, WorkOrdersTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkOrdersTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _assignedIdsJsonMeta = const VerificationMeta(
    'assignedIdsJson',
  );
  @override
  late final GeneratedColumn<String> assignedIdsJson = GeneratedColumn<String>(
    'assigned_ids_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _rawJsonMeta = const VerificationMeta(
    'rawJson',
  );
  @override
  late final GeneratedColumn<String> rawJson = GeneratedColumn<String>(
    'raw_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('{}'),
  );
  static const VerificationMeta _startAtMeta = const VerificationMeta(
    'startAt',
  );
  @override
  late final GeneratedColumn<DateTime> startAt = GeneratedColumn<DateTime>(
    'start_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _endAtMeta = const VerificationMeta('endAt');
  @override
  late final GeneratedColumn<DateTime> endAt = GeneratedColumn<DateTime>(
    'end_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cachedAtMeta = const VerificationMeta(
    'cachedAt',
  );
  @override
  late final GeneratedColumn<DateTime> cachedAt = GeneratedColumn<DateTime>(
    'cached_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    assignedIdsJson,
    rawJson,
    startAt,
    endAt,
    cachedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'work_orders_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<WorkOrdersTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    }
    if (data.containsKey('assigned_ids_json')) {
      context.handle(
        _assignedIdsJsonMeta,
        assignedIdsJson.isAcceptableOrUnknown(
          data['assigned_ids_json']!,
          _assignedIdsJsonMeta,
        ),
      );
    }
    if (data.containsKey('raw_json')) {
      context.handle(
        _rawJsonMeta,
        rawJson.isAcceptableOrUnknown(data['raw_json']!, _rawJsonMeta),
      );
    }
    if (data.containsKey('start_at')) {
      context.handle(
        _startAtMeta,
        startAt.isAcceptableOrUnknown(data['start_at']!, _startAtMeta),
      );
    }
    if (data.containsKey('end_at')) {
      context.handle(
        _endAtMeta,
        endAt.isAcceptableOrUnknown(data['end_at']!, _endAtMeta),
      );
    }
    if (data.containsKey('cached_at')) {
      context.handle(
        _cachedAtMeta,
        cachedAt.isAcceptableOrUnknown(data['cached_at']!, _cachedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkOrdersTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkOrdersTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      assignedIdsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}assigned_ids_json'],
      )!,
      rawJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}raw_json'],
      )!,
      startAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_at'],
      ),
      endAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_at'],
      ),
      cachedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}cached_at'],
      )!,
    );
  }

  @override
  $WorkOrdersTableTable createAlias(String alias) {
    return $WorkOrdersTableTable(attachedDatabase, alias);
  }
}

class WorkOrdersTableData extends DataClass
    implements Insertable<WorkOrdersTableData> {
  final String id;
  final String name;
  final String assignedIdsJson;
  final String rawJson;
  final DateTime? startAt;
  final DateTime? endAt;
  final DateTime cachedAt;
  const WorkOrdersTableData({
    required this.id,
    required this.name,
    required this.assignedIdsJson,
    required this.rawJson,
    this.startAt,
    this.endAt,
    required this.cachedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['assigned_ids_json'] = Variable<String>(assignedIdsJson);
    map['raw_json'] = Variable<String>(rawJson);
    if (!nullToAbsent || startAt != null) {
      map['start_at'] = Variable<DateTime>(startAt);
    }
    if (!nullToAbsent || endAt != null) {
      map['end_at'] = Variable<DateTime>(endAt);
    }
    map['cached_at'] = Variable<DateTime>(cachedAt);
    return map;
  }

  WorkOrdersTableCompanion toCompanion(bool nullToAbsent) {
    return WorkOrdersTableCompanion(
      id: Value(id),
      name: Value(name),
      assignedIdsJson: Value(assignedIdsJson),
      rawJson: Value(rawJson),
      startAt: startAt == null && nullToAbsent
          ? const Value.absent()
          : Value(startAt),
      endAt: endAt == null && nullToAbsent
          ? const Value.absent()
          : Value(endAt),
      cachedAt: Value(cachedAt),
    );
  }

  factory WorkOrdersTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkOrdersTableData(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      assignedIdsJson: serializer.fromJson<String>(json['assignedIdsJson']),
      rawJson: serializer.fromJson<String>(json['rawJson']),
      startAt: serializer.fromJson<DateTime?>(json['startAt']),
      endAt: serializer.fromJson<DateTime?>(json['endAt']),
      cachedAt: serializer.fromJson<DateTime>(json['cachedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'assignedIdsJson': serializer.toJson<String>(assignedIdsJson),
      'rawJson': serializer.toJson<String>(rawJson),
      'startAt': serializer.toJson<DateTime?>(startAt),
      'endAt': serializer.toJson<DateTime?>(endAt),
      'cachedAt': serializer.toJson<DateTime>(cachedAt),
    };
  }

  WorkOrdersTableData copyWith({
    String? id,
    String? name,
    String? assignedIdsJson,
    String? rawJson,
    Value<DateTime?> startAt = const Value.absent(),
    Value<DateTime?> endAt = const Value.absent(),
    DateTime? cachedAt,
  }) => WorkOrdersTableData(
    id: id ?? this.id,
    name: name ?? this.name,
    assignedIdsJson: assignedIdsJson ?? this.assignedIdsJson,
    rawJson: rawJson ?? this.rawJson,
    startAt: startAt.present ? startAt.value : this.startAt,
    endAt: endAt.present ? endAt.value : this.endAt,
    cachedAt: cachedAt ?? this.cachedAt,
  );
  WorkOrdersTableData copyWithCompanion(WorkOrdersTableCompanion data) {
    return WorkOrdersTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      assignedIdsJson: data.assignedIdsJson.present
          ? data.assignedIdsJson.value
          : this.assignedIdsJson,
      rawJson: data.rawJson.present ? data.rawJson.value : this.rawJson,
      startAt: data.startAt.present ? data.startAt.value : this.startAt,
      endAt: data.endAt.present ? data.endAt.value : this.endAt,
      cachedAt: data.cachedAt.present ? data.cachedAt.value : this.cachedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkOrdersTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('assignedIdsJson: $assignedIdsJson, ')
          ..write('rawJson: $rawJson, ')
          ..write('startAt: $startAt, ')
          ..write('endAt: $endAt, ')
          ..write('cachedAt: $cachedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, assignedIdsJson, rawJson, startAt, endAt, cachedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkOrdersTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.assignedIdsJson == this.assignedIdsJson &&
          other.rawJson == this.rawJson &&
          other.startAt == this.startAt &&
          other.endAt == this.endAt &&
          other.cachedAt == this.cachedAt);
}

class WorkOrdersTableCompanion extends UpdateCompanion<WorkOrdersTableData> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> assignedIdsJson;
  final Value<String> rawJson;
  final Value<DateTime?> startAt;
  final Value<DateTime?> endAt;
  final Value<DateTime> cachedAt;
  final Value<int> rowid;
  const WorkOrdersTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.assignedIdsJson = const Value.absent(),
    this.rawJson = const Value.absent(),
    this.startAt = const Value.absent(),
    this.endAt = const Value.absent(),
    this.cachedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WorkOrdersTableCompanion.insert({
    required String id,
    this.name = const Value.absent(),
    this.assignedIdsJson = const Value.absent(),
    this.rawJson = const Value.absent(),
    this.startAt = const Value.absent(),
    this.endAt = const Value.absent(),
    this.cachedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id);
  static Insertable<WorkOrdersTableData> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? assignedIdsJson,
    Expression<String>? rawJson,
    Expression<DateTime>? startAt,
    Expression<DateTime>? endAt,
    Expression<DateTime>? cachedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (assignedIdsJson != null) 'assigned_ids_json': assignedIdsJson,
      if (rawJson != null) 'raw_json': rawJson,
      if (startAt != null) 'start_at': startAt,
      if (endAt != null) 'end_at': endAt,
      if (cachedAt != null) 'cached_at': cachedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WorkOrdersTableCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? assignedIdsJson,
    Value<String>? rawJson,
    Value<DateTime?>? startAt,
    Value<DateTime?>? endAt,
    Value<DateTime>? cachedAt,
    Value<int>? rowid,
  }) {
    return WorkOrdersTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      assignedIdsJson: assignedIdsJson ?? this.assignedIdsJson,
      rawJson: rawJson ?? this.rawJson,
      startAt: startAt ?? this.startAt,
      endAt: endAt ?? this.endAt,
      cachedAt: cachedAt ?? this.cachedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (assignedIdsJson.present) {
      map['assigned_ids_json'] = Variable<String>(assignedIdsJson.value);
    }
    if (rawJson.present) {
      map['raw_json'] = Variable<String>(rawJson.value);
    }
    if (startAt.present) {
      map['start_at'] = Variable<DateTime>(startAt.value);
    }
    if (endAt.present) {
      map['end_at'] = Variable<DateTime>(endAt.value);
    }
    if (cachedAt.present) {
      map['cached_at'] = Variable<DateTime>(cachedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkOrdersTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('assignedIdsJson: $assignedIdsJson, ')
          ..write('rawJson: $rawJson, ')
          ..write('startAt: $startAt, ')
          ..write('endAt: $endAt, ')
          ..write('cachedAt: $cachedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $WorkOrdersTableTable workOrdersTable = $WorkOrdersTableTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [workOrdersTable];
}

typedef $$WorkOrdersTableTableCreateCompanionBuilder =
    WorkOrdersTableCompanion Function({
      required String id,
      Value<String> name,
      Value<String> assignedIdsJson,
      Value<String> rawJson,
      Value<DateTime?> startAt,
      Value<DateTime?> endAt,
      Value<DateTime> cachedAt,
      Value<int> rowid,
    });
typedef $$WorkOrdersTableTableUpdateCompanionBuilder =
    WorkOrdersTableCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> assignedIdsJson,
      Value<String> rawJson,
      Value<DateTime?> startAt,
      Value<DateTime?> endAt,
      Value<DateTime> cachedAt,
      Value<int> rowid,
    });

class $$WorkOrdersTableTableFilterComposer
    extends Composer<_$AppDatabase, $WorkOrdersTableTable> {
  $$WorkOrdersTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get assignedIdsJson => $composableBuilder(
    column: $table.assignedIdsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rawJson => $composableBuilder(
    column: $table.rawJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startAt => $composableBuilder(
    column: $table.startAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endAt => $composableBuilder(
    column: $table.endAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WorkOrdersTableTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkOrdersTableTable> {
  $$WorkOrdersTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get assignedIdsJson => $composableBuilder(
    column: $table.assignedIdsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rawJson => $composableBuilder(
    column: $table.rawJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startAt => $composableBuilder(
    column: $table.startAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endAt => $composableBuilder(
    column: $table.endAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WorkOrdersTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkOrdersTableTable> {
  $$WorkOrdersTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get assignedIdsJson => $composableBuilder(
    column: $table.assignedIdsJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get rawJson =>
      $composableBuilder(column: $table.rawJson, builder: (column) => column);

  GeneratedColumn<DateTime> get startAt =>
      $composableBuilder(column: $table.startAt, builder: (column) => column);

  GeneratedColumn<DateTime> get endAt =>
      $composableBuilder(column: $table.endAt, builder: (column) => column);

  GeneratedColumn<DateTime> get cachedAt =>
      $composableBuilder(column: $table.cachedAt, builder: (column) => column);
}

class $$WorkOrdersTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WorkOrdersTableTable,
          WorkOrdersTableData,
          $$WorkOrdersTableTableFilterComposer,
          $$WorkOrdersTableTableOrderingComposer,
          $$WorkOrdersTableTableAnnotationComposer,
          $$WorkOrdersTableTableCreateCompanionBuilder,
          $$WorkOrdersTableTableUpdateCompanionBuilder,
          (
            WorkOrdersTableData,
            BaseReferences<
              _$AppDatabase,
              $WorkOrdersTableTable,
              WorkOrdersTableData
            >,
          ),
          WorkOrdersTableData,
          PrefetchHooks Function()
        > {
  $$WorkOrdersTableTableTableManager(
    _$AppDatabase db,
    $WorkOrdersTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkOrdersTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkOrdersTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkOrdersTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> assignedIdsJson = const Value.absent(),
                Value<String> rawJson = const Value.absent(),
                Value<DateTime?> startAt = const Value.absent(),
                Value<DateTime?> endAt = const Value.absent(),
                Value<DateTime> cachedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorkOrdersTableCompanion(
                id: id,
                name: name,
                assignedIdsJson: assignedIdsJson,
                rawJson: rawJson,
                startAt: startAt,
                endAt: endAt,
                cachedAt: cachedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String> name = const Value.absent(),
                Value<String> assignedIdsJson = const Value.absent(),
                Value<String> rawJson = const Value.absent(),
                Value<DateTime?> startAt = const Value.absent(),
                Value<DateTime?> endAt = const Value.absent(),
                Value<DateTime> cachedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorkOrdersTableCompanion.insert(
                id: id,
                name: name,
                assignedIdsJson: assignedIdsJson,
                rawJson: rawJson,
                startAt: startAt,
                endAt: endAt,
                cachedAt: cachedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WorkOrdersTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WorkOrdersTableTable,
      WorkOrdersTableData,
      $$WorkOrdersTableTableFilterComposer,
      $$WorkOrdersTableTableOrderingComposer,
      $$WorkOrdersTableTableAnnotationComposer,
      $$WorkOrdersTableTableCreateCompanionBuilder,
      $$WorkOrdersTableTableUpdateCompanionBuilder,
      (
        WorkOrdersTableData,
        BaseReferences<
          _$AppDatabase,
          $WorkOrdersTableTable,
          WorkOrdersTableData
        >,
      ),
      WorkOrdersTableData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$WorkOrdersTableTableTableManager get workOrdersTable =>
      $$WorkOrdersTableTableTableManager(_db, _db.workOrdersTable);
}
