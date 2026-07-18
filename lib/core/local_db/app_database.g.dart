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

class $CustomersTableTable extends CustomersTable
    with TableInfo<$CustomersTableTable, CustomersTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CustomersTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  List<GeneratedColumn> get $columns => [id, rawJson, cachedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'customers_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<CustomersTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('raw_json')) {
      context.handle(
        _rawJsonMeta,
        rawJson.isAcceptableOrUnknown(data['raw_json']!, _rawJsonMeta),
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
  CustomersTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CustomersTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      rawJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}raw_json'],
      )!,
      cachedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}cached_at'],
      )!,
    );
  }

  @override
  $CustomersTableTable createAlias(String alias) {
    return $CustomersTableTable(attachedDatabase, alias);
  }
}

class CustomersTableData extends DataClass
    implements Insertable<CustomersTableData> {
  final String id;
  final String rawJson;
  final DateTime cachedAt;
  const CustomersTableData({
    required this.id,
    required this.rawJson,
    required this.cachedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['raw_json'] = Variable<String>(rawJson);
    map['cached_at'] = Variable<DateTime>(cachedAt);
    return map;
  }

  CustomersTableCompanion toCompanion(bool nullToAbsent) {
    return CustomersTableCompanion(
      id: Value(id),
      rawJson: Value(rawJson),
      cachedAt: Value(cachedAt),
    );
  }

  factory CustomersTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CustomersTableData(
      id: serializer.fromJson<String>(json['id']),
      rawJson: serializer.fromJson<String>(json['rawJson']),
      cachedAt: serializer.fromJson<DateTime>(json['cachedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'rawJson': serializer.toJson<String>(rawJson),
      'cachedAt': serializer.toJson<DateTime>(cachedAt),
    };
  }

  CustomersTableData copyWith({
    String? id,
    String? rawJson,
    DateTime? cachedAt,
  }) => CustomersTableData(
    id: id ?? this.id,
    rawJson: rawJson ?? this.rawJson,
    cachedAt: cachedAt ?? this.cachedAt,
  );
  CustomersTableData copyWithCompanion(CustomersTableCompanion data) {
    return CustomersTableData(
      id: data.id.present ? data.id.value : this.id,
      rawJson: data.rawJson.present ? data.rawJson.value : this.rawJson,
      cachedAt: data.cachedAt.present ? data.cachedAt.value : this.cachedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CustomersTableData(')
          ..write('id: $id, ')
          ..write('rawJson: $rawJson, ')
          ..write('cachedAt: $cachedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, rawJson, cachedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CustomersTableData &&
          other.id == this.id &&
          other.rawJson == this.rawJson &&
          other.cachedAt == this.cachedAt);
}

class CustomersTableCompanion extends UpdateCompanion<CustomersTableData> {
  final Value<String> id;
  final Value<String> rawJson;
  final Value<DateTime> cachedAt;
  final Value<int> rowid;
  const CustomersTableCompanion({
    this.id = const Value.absent(),
    this.rawJson = const Value.absent(),
    this.cachedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CustomersTableCompanion.insert({
    required String id,
    this.rawJson = const Value.absent(),
    this.cachedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id);
  static Insertable<CustomersTableData> custom({
    Expression<String>? id,
    Expression<String>? rawJson,
    Expression<DateTime>? cachedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (rawJson != null) 'raw_json': rawJson,
      if (cachedAt != null) 'cached_at': cachedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CustomersTableCompanion copyWith({
    Value<String>? id,
    Value<String>? rawJson,
    Value<DateTime>? cachedAt,
    Value<int>? rowid,
  }) {
    return CustomersTableCompanion(
      id: id ?? this.id,
      rawJson: rawJson ?? this.rawJson,
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
    if (rawJson.present) {
      map['raw_json'] = Variable<String>(rawJson.value);
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
    return (StringBuffer('CustomersTableCompanion(')
          ..write('id: $id, ')
          ..write('rawJson: $rawJson, ')
          ..write('cachedAt: $cachedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProjectsTableTable extends ProjectsTable
    with TableInfo<$ProjectsTableTable, ProjectsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProjectsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
    requiredDuringInsert: true,
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
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, rawJson, cachedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'projects_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProjectsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('raw_json')) {
      context.handle(
        _rawJsonMeta,
        rawJson.isAcceptableOrUnknown(data['raw_json']!, _rawJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_rawJsonMeta);
    }
    if (data.containsKey('cached_at')) {
      context.handle(
        _cachedAtMeta,
        cachedAt.isAcceptableOrUnknown(data['cached_at']!, _cachedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_cachedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProjectsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProjectsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      rawJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}raw_json'],
      )!,
      cachedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}cached_at'],
      )!,
    );
  }

  @override
  $ProjectsTableTable createAlias(String alias) {
    return $ProjectsTableTable(attachedDatabase, alias);
  }
}

class ProjectsTableData extends DataClass
    implements Insertable<ProjectsTableData> {
  final String id;
  final String rawJson;
  final DateTime cachedAt;
  const ProjectsTableData({
    required this.id,
    required this.rawJson,
    required this.cachedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['raw_json'] = Variable<String>(rawJson);
    map['cached_at'] = Variable<DateTime>(cachedAt);
    return map;
  }

  ProjectsTableCompanion toCompanion(bool nullToAbsent) {
    return ProjectsTableCompanion(
      id: Value(id),
      rawJson: Value(rawJson),
      cachedAt: Value(cachedAt),
    );
  }

  factory ProjectsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProjectsTableData(
      id: serializer.fromJson<String>(json['id']),
      rawJson: serializer.fromJson<String>(json['rawJson']),
      cachedAt: serializer.fromJson<DateTime>(json['cachedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'rawJson': serializer.toJson<String>(rawJson),
      'cachedAt': serializer.toJson<DateTime>(cachedAt),
    };
  }

  ProjectsTableData copyWith({
    String? id,
    String? rawJson,
    DateTime? cachedAt,
  }) => ProjectsTableData(
    id: id ?? this.id,
    rawJson: rawJson ?? this.rawJson,
    cachedAt: cachedAt ?? this.cachedAt,
  );
  ProjectsTableData copyWithCompanion(ProjectsTableCompanion data) {
    return ProjectsTableData(
      id: data.id.present ? data.id.value : this.id,
      rawJson: data.rawJson.present ? data.rawJson.value : this.rawJson,
      cachedAt: data.cachedAt.present ? data.cachedAt.value : this.cachedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProjectsTableData(')
          ..write('id: $id, ')
          ..write('rawJson: $rawJson, ')
          ..write('cachedAt: $cachedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, rawJson, cachedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProjectsTableData &&
          other.id == this.id &&
          other.rawJson == this.rawJson &&
          other.cachedAt == this.cachedAt);
}

class ProjectsTableCompanion extends UpdateCompanion<ProjectsTableData> {
  final Value<String> id;
  final Value<String> rawJson;
  final Value<DateTime> cachedAt;
  final Value<int> rowid;
  const ProjectsTableCompanion({
    this.id = const Value.absent(),
    this.rawJson = const Value.absent(),
    this.cachedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProjectsTableCompanion.insert({
    required String id,
    required String rawJson,
    required DateTime cachedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       rawJson = Value(rawJson),
       cachedAt = Value(cachedAt);
  static Insertable<ProjectsTableData> custom({
    Expression<String>? id,
    Expression<String>? rawJson,
    Expression<DateTime>? cachedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (rawJson != null) 'raw_json': rawJson,
      if (cachedAt != null) 'cached_at': cachedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProjectsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? rawJson,
    Value<DateTime>? cachedAt,
    Value<int>? rowid,
  }) {
    return ProjectsTableCompanion(
      id: id ?? this.id,
      rawJson: rawJson ?? this.rawJson,
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
    if (rawJson.present) {
      map['raw_json'] = Variable<String>(rawJson.value);
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
    return (StringBuffer('ProjectsTableCompanion(')
          ..write('id: $id, ')
          ..write('rawJson: $rawJson, ')
          ..write('cachedAt: $cachedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UsersTableTable extends UsersTable
    with TableInfo<$UsersTableTable, UsersTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
    requiredDuringInsert: true,
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
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, rawJson, cachedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<UsersTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('raw_json')) {
      context.handle(
        _rawJsonMeta,
        rawJson.isAcceptableOrUnknown(data['raw_json']!, _rawJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_rawJsonMeta);
    }
    if (data.containsKey('cached_at')) {
      context.handle(
        _cachedAtMeta,
        cachedAt.isAcceptableOrUnknown(data['cached_at']!, _cachedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_cachedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UsersTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UsersTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      rawJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}raw_json'],
      )!,
      cachedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}cached_at'],
      )!,
    );
  }

  @override
  $UsersTableTable createAlias(String alias) {
    return $UsersTableTable(attachedDatabase, alias);
  }
}

class UsersTableData extends DataClass implements Insertable<UsersTableData> {
  final String id;
  final String rawJson;
  final DateTime cachedAt;
  const UsersTableData({
    required this.id,
    required this.rawJson,
    required this.cachedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['raw_json'] = Variable<String>(rawJson);
    map['cached_at'] = Variable<DateTime>(cachedAt);
    return map;
  }

  UsersTableCompanion toCompanion(bool nullToAbsent) {
    return UsersTableCompanion(
      id: Value(id),
      rawJson: Value(rawJson),
      cachedAt: Value(cachedAt),
    );
  }

  factory UsersTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UsersTableData(
      id: serializer.fromJson<String>(json['id']),
      rawJson: serializer.fromJson<String>(json['rawJson']),
      cachedAt: serializer.fromJson<DateTime>(json['cachedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'rawJson': serializer.toJson<String>(rawJson),
      'cachedAt': serializer.toJson<DateTime>(cachedAt),
    };
  }

  UsersTableData copyWith({String? id, String? rawJson, DateTime? cachedAt}) =>
      UsersTableData(
        id: id ?? this.id,
        rawJson: rawJson ?? this.rawJson,
        cachedAt: cachedAt ?? this.cachedAt,
      );
  UsersTableData copyWithCompanion(UsersTableCompanion data) {
    return UsersTableData(
      id: data.id.present ? data.id.value : this.id,
      rawJson: data.rawJson.present ? data.rawJson.value : this.rawJson,
      cachedAt: data.cachedAt.present ? data.cachedAt.value : this.cachedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UsersTableData(')
          ..write('id: $id, ')
          ..write('rawJson: $rawJson, ')
          ..write('cachedAt: $cachedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, rawJson, cachedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UsersTableData &&
          other.id == this.id &&
          other.rawJson == this.rawJson &&
          other.cachedAt == this.cachedAt);
}

class UsersTableCompanion extends UpdateCompanion<UsersTableData> {
  final Value<String> id;
  final Value<String> rawJson;
  final Value<DateTime> cachedAt;
  final Value<int> rowid;
  const UsersTableCompanion({
    this.id = const Value.absent(),
    this.rawJson = const Value.absent(),
    this.cachedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UsersTableCompanion.insert({
    required String id,
    required String rawJson,
    required DateTime cachedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       rawJson = Value(rawJson),
       cachedAt = Value(cachedAt);
  static Insertable<UsersTableData> custom({
    Expression<String>? id,
    Expression<String>? rawJson,
    Expression<DateTime>? cachedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (rawJson != null) 'raw_json': rawJson,
      if (cachedAt != null) 'cached_at': cachedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UsersTableCompanion copyWith({
    Value<String>? id,
    Value<String>? rawJson,
    Value<DateTime>? cachedAt,
    Value<int>? rowid,
  }) {
    return UsersTableCompanion(
      id: id ?? this.id,
      rawJson: rawJson ?? this.rawJson,
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
    if (rawJson.present) {
      map['raw_json'] = Variable<String>(rawJson.value);
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
    return (StringBuffer('UsersTableCompanion(')
          ..write('id: $id, ')
          ..write('rawJson: $rawJson, ')
          ..write('cachedAt: $cachedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $InventoriesTableTable extends InventoriesTable
    with TableInfo<$InventoriesTableTable, InventoriesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InventoriesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
    requiredDuringInsert: true,
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
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, rawJson, cachedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'inventories_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<InventoriesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('raw_json')) {
      context.handle(
        _rawJsonMeta,
        rawJson.isAcceptableOrUnknown(data['raw_json']!, _rawJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_rawJsonMeta);
    }
    if (data.containsKey('cached_at')) {
      context.handle(
        _cachedAtMeta,
        cachedAt.isAcceptableOrUnknown(data['cached_at']!, _cachedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_cachedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  InventoriesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InventoriesTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      rawJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}raw_json'],
      )!,
      cachedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}cached_at'],
      )!,
    );
  }

  @override
  $InventoriesTableTable createAlias(String alias) {
    return $InventoriesTableTable(attachedDatabase, alias);
  }
}

class InventoriesTableData extends DataClass
    implements Insertable<InventoriesTableData> {
  final String id;
  final String rawJson;
  final DateTime cachedAt;
  const InventoriesTableData({
    required this.id,
    required this.rawJson,
    required this.cachedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['raw_json'] = Variable<String>(rawJson);
    map['cached_at'] = Variable<DateTime>(cachedAt);
    return map;
  }

  InventoriesTableCompanion toCompanion(bool nullToAbsent) {
    return InventoriesTableCompanion(
      id: Value(id),
      rawJson: Value(rawJson),
      cachedAt: Value(cachedAt),
    );
  }

  factory InventoriesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InventoriesTableData(
      id: serializer.fromJson<String>(json['id']),
      rawJson: serializer.fromJson<String>(json['rawJson']),
      cachedAt: serializer.fromJson<DateTime>(json['cachedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'rawJson': serializer.toJson<String>(rawJson),
      'cachedAt': serializer.toJson<DateTime>(cachedAt),
    };
  }

  InventoriesTableData copyWith({
    String? id,
    String? rawJson,
    DateTime? cachedAt,
  }) => InventoriesTableData(
    id: id ?? this.id,
    rawJson: rawJson ?? this.rawJson,
    cachedAt: cachedAt ?? this.cachedAt,
  );
  InventoriesTableData copyWithCompanion(InventoriesTableCompanion data) {
    return InventoriesTableData(
      id: data.id.present ? data.id.value : this.id,
      rawJson: data.rawJson.present ? data.rawJson.value : this.rawJson,
      cachedAt: data.cachedAt.present ? data.cachedAt.value : this.cachedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InventoriesTableData(')
          ..write('id: $id, ')
          ..write('rawJson: $rawJson, ')
          ..write('cachedAt: $cachedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, rawJson, cachedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InventoriesTableData &&
          other.id == this.id &&
          other.rawJson == this.rawJson &&
          other.cachedAt == this.cachedAt);
}

class InventoriesTableCompanion extends UpdateCompanion<InventoriesTableData> {
  final Value<String> id;
  final Value<String> rawJson;
  final Value<DateTime> cachedAt;
  final Value<int> rowid;
  const InventoriesTableCompanion({
    this.id = const Value.absent(),
    this.rawJson = const Value.absent(),
    this.cachedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  InventoriesTableCompanion.insert({
    required String id,
    required String rawJson,
    required DateTime cachedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       rawJson = Value(rawJson),
       cachedAt = Value(cachedAt);
  static Insertable<InventoriesTableData> custom({
    Expression<String>? id,
    Expression<String>? rawJson,
    Expression<DateTime>? cachedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (rawJson != null) 'raw_json': rawJson,
      if (cachedAt != null) 'cached_at': cachedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  InventoriesTableCompanion copyWith({
    Value<String>? id,
    Value<String>? rawJson,
    Value<DateTime>? cachedAt,
    Value<int>? rowid,
  }) {
    return InventoriesTableCompanion(
      id: id ?? this.id,
      rawJson: rawJson ?? this.rawJson,
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
    if (rawJson.present) {
      map['raw_json'] = Variable<String>(rawJson.value);
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
    return (StringBuffer('InventoriesTableCompanion(')
          ..write('id: $id, ')
          ..write('rawJson: $rawJson, ')
          ..write('cachedAt: $cachedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PermissionSettingsTableTable extends PermissionSettingsTable
    with TableInfo<$PermissionSettingsTableTable, PermissionSettingsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PermissionSettingsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
    requiredDuringInsert: true,
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
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, rawJson, cachedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'permission_settings_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<PermissionSettingsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('raw_json')) {
      context.handle(
        _rawJsonMeta,
        rawJson.isAcceptableOrUnknown(data['raw_json']!, _rawJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_rawJsonMeta);
    }
    if (data.containsKey('cached_at')) {
      context.handle(
        _cachedAtMeta,
        cachedAt.isAcceptableOrUnknown(data['cached_at']!, _cachedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_cachedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PermissionSettingsTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PermissionSettingsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      rawJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}raw_json'],
      )!,
      cachedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}cached_at'],
      )!,
    );
  }

  @override
  $PermissionSettingsTableTable createAlias(String alias) {
    return $PermissionSettingsTableTable(attachedDatabase, alias);
  }
}

class PermissionSettingsTableData extends DataClass
    implements Insertable<PermissionSettingsTableData> {
  final String id;
  final String rawJson;
  final DateTime cachedAt;
  const PermissionSettingsTableData({
    required this.id,
    required this.rawJson,
    required this.cachedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['raw_json'] = Variable<String>(rawJson);
    map['cached_at'] = Variable<DateTime>(cachedAt);
    return map;
  }

  PermissionSettingsTableCompanion toCompanion(bool nullToAbsent) {
    return PermissionSettingsTableCompanion(
      id: Value(id),
      rawJson: Value(rawJson),
      cachedAt: Value(cachedAt),
    );
  }

  factory PermissionSettingsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PermissionSettingsTableData(
      id: serializer.fromJson<String>(json['id']),
      rawJson: serializer.fromJson<String>(json['rawJson']),
      cachedAt: serializer.fromJson<DateTime>(json['cachedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'rawJson': serializer.toJson<String>(rawJson),
      'cachedAt': serializer.toJson<DateTime>(cachedAt),
    };
  }

  PermissionSettingsTableData copyWith({
    String? id,
    String? rawJson,
    DateTime? cachedAt,
  }) => PermissionSettingsTableData(
    id: id ?? this.id,
    rawJson: rawJson ?? this.rawJson,
    cachedAt: cachedAt ?? this.cachedAt,
  );
  PermissionSettingsTableData copyWithCompanion(
    PermissionSettingsTableCompanion data,
  ) {
    return PermissionSettingsTableData(
      id: data.id.present ? data.id.value : this.id,
      rawJson: data.rawJson.present ? data.rawJson.value : this.rawJson,
      cachedAt: data.cachedAt.present ? data.cachedAt.value : this.cachedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PermissionSettingsTableData(')
          ..write('id: $id, ')
          ..write('rawJson: $rawJson, ')
          ..write('cachedAt: $cachedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, rawJson, cachedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PermissionSettingsTableData &&
          other.id == this.id &&
          other.rawJson == this.rawJson &&
          other.cachedAt == this.cachedAt);
}

class PermissionSettingsTableCompanion
    extends UpdateCompanion<PermissionSettingsTableData> {
  final Value<String> id;
  final Value<String> rawJson;
  final Value<DateTime> cachedAt;
  final Value<int> rowid;
  const PermissionSettingsTableCompanion({
    this.id = const Value.absent(),
    this.rawJson = const Value.absent(),
    this.cachedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PermissionSettingsTableCompanion.insert({
    required String id,
    required String rawJson,
    required DateTime cachedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       rawJson = Value(rawJson),
       cachedAt = Value(cachedAt);
  static Insertable<PermissionSettingsTableData> custom({
    Expression<String>? id,
    Expression<String>? rawJson,
    Expression<DateTime>? cachedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (rawJson != null) 'raw_json': rawJson,
      if (cachedAt != null) 'cached_at': cachedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PermissionSettingsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? rawJson,
    Value<DateTime>? cachedAt,
    Value<int>? rowid,
  }) {
    return PermissionSettingsTableCompanion(
      id: id ?? this.id,
      rawJson: rawJson ?? this.rawJson,
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
    if (rawJson.present) {
      map['raw_json'] = Variable<String>(rawJson.value);
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
    return (StringBuffer('PermissionSettingsTableCompanion(')
          ..write('id: $id, ')
          ..write('rawJson: $rawJson, ')
          ..write('cachedAt: $cachedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TimeReportsTableTable extends TimeReportsTable
    with TableInfo<$TimeReportsTableTable, TimeReportsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TimeReportsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
    requiredDuringInsert: true,
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
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, rawJson, cachedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'time_reports_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<TimeReportsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('raw_json')) {
      context.handle(
        _rawJsonMeta,
        rawJson.isAcceptableOrUnknown(data['raw_json']!, _rawJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_rawJsonMeta);
    }
    if (data.containsKey('cached_at')) {
      context.handle(
        _cachedAtMeta,
        cachedAt.isAcceptableOrUnknown(data['cached_at']!, _cachedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_cachedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TimeReportsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TimeReportsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      rawJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}raw_json'],
      )!,
      cachedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}cached_at'],
      )!,
    );
  }

  @override
  $TimeReportsTableTable createAlias(String alias) {
    return $TimeReportsTableTable(attachedDatabase, alias);
  }
}

class TimeReportsTableData extends DataClass
    implements Insertable<TimeReportsTableData> {
  final String id;
  final String rawJson;
  final DateTime cachedAt;
  const TimeReportsTableData({
    required this.id,
    required this.rawJson,
    required this.cachedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['raw_json'] = Variable<String>(rawJson);
    map['cached_at'] = Variable<DateTime>(cachedAt);
    return map;
  }

  TimeReportsTableCompanion toCompanion(bool nullToAbsent) {
    return TimeReportsTableCompanion(
      id: Value(id),
      rawJson: Value(rawJson),
      cachedAt: Value(cachedAt),
    );
  }

  factory TimeReportsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TimeReportsTableData(
      id: serializer.fromJson<String>(json['id']),
      rawJson: serializer.fromJson<String>(json['rawJson']),
      cachedAt: serializer.fromJson<DateTime>(json['cachedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'rawJson': serializer.toJson<String>(rawJson),
      'cachedAt': serializer.toJson<DateTime>(cachedAt),
    };
  }

  TimeReportsTableData copyWith({
    String? id,
    String? rawJson,
    DateTime? cachedAt,
  }) => TimeReportsTableData(
    id: id ?? this.id,
    rawJson: rawJson ?? this.rawJson,
    cachedAt: cachedAt ?? this.cachedAt,
  );
  TimeReportsTableData copyWithCompanion(TimeReportsTableCompanion data) {
    return TimeReportsTableData(
      id: data.id.present ? data.id.value : this.id,
      rawJson: data.rawJson.present ? data.rawJson.value : this.rawJson,
      cachedAt: data.cachedAt.present ? data.cachedAt.value : this.cachedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TimeReportsTableData(')
          ..write('id: $id, ')
          ..write('rawJson: $rawJson, ')
          ..write('cachedAt: $cachedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, rawJson, cachedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TimeReportsTableData &&
          other.id == this.id &&
          other.rawJson == this.rawJson &&
          other.cachedAt == this.cachedAt);
}

class TimeReportsTableCompanion extends UpdateCompanion<TimeReportsTableData> {
  final Value<String> id;
  final Value<String> rawJson;
  final Value<DateTime> cachedAt;
  final Value<int> rowid;
  const TimeReportsTableCompanion({
    this.id = const Value.absent(),
    this.rawJson = const Value.absent(),
    this.cachedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TimeReportsTableCompanion.insert({
    required String id,
    required String rawJson,
    required DateTime cachedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       rawJson = Value(rawJson),
       cachedAt = Value(cachedAt);
  static Insertable<TimeReportsTableData> custom({
    Expression<String>? id,
    Expression<String>? rawJson,
    Expression<DateTime>? cachedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (rawJson != null) 'raw_json': rawJson,
      if (cachedAt != null) 'cached_at': cachedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TimeReportsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? rawJson,
    Value<DateTime>? cachedAt,
    Value<int>? rowid,
  }) {
    return TimeReportsTableCompanion(
      id: id ?? this.id,
      rawJson: rawJson ?? this.rawJson,
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
    if (rawJson.present) {
      map['raw_json'] = Variable<String>(rawJson.value);
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
    return (StringBuffer('TimeReportsTableCompanion(')
          ..write('id: $id, ')
          ..write('rawJson: $rawJson, ')
          ..write('cachedAt: $cachedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PendingUpdatesTableTable extends PendingUpdatesTable
    with TableInfo<$PendingUpdatesTableTable, PendingUpdatesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PendingUpdatesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _localIdMeta = const VerificationMeta(
    'localId',
  );
  @override
  late final GeneratedColumn<int> localId = GeneratedColumn<int>(
    'local_id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _targetTableMeta = const VerificationMeta(
    'targetTable',
  );
  @override
  late final GeneratedColumn<String> targetTable = GeneratedColumn<String>(
    'target_table',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _recordIdMeta = const VerificationMeta(
    'recordId',
  );
  @override
  late final GeneratedColumn<String> recordId = GeneratedColumn<String>(
    'record_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dataJsonMeta = const VerificationMeta(
    'dataJson',
  );
  @override
  late final GeneratedColumn<String> dataJson = GeneratedColumn<String>(
    'data_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _schemeOverrideMeta = const VerificationMeta(
    'schemeOverride',
  );
  @override
  late final GeneratedColumn<String> schemeOverride = GeneratedColumn<String>(
    'scheme_override',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _attemptsMeta = const VerificationMeta(
    'attempts',
  );
  @override
  late final GeneratedColumn<int> attempts = GeneratedColumn<int>(
    'attempts',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastErrorMeta = const VerificationMeta(
    'lastError',
  );
  @override
  late final GeneratedColumn<String> lastError = GeneratedColumn<String>(
    'last_error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    localId,
    targetTable,
    recordId,
    dataJson,
    schemeOverride,
    attempts,
    lastError,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pending_updates_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<PendingUpdatesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('local_id')) {
      context.handle(
        _localIdMeta,
        localId.isAcceptableOrUnknown(data['local_id']!, _localIdMeta),
      );
    }
    if (data.containsKey('target_table')) {
      context.handle(
        _targetTableMeta,
        targetTable.isAcceptableOrUnknown(
          data['target_table']!,
          _targetTableMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_targetTableMeta);
    }
    if (data.containsKey('record_id')) {
      context.handle(
        _recordIdMeta,
        recordId.isAcceptableOrUnknown(data['record_id']!, _recordIdMeta),
      );
    } else if (isInserting) {
      context.missing(_recordIdMeta);
    }
    if (data.containsKey('data_json')) {
      context.handle(
        _dataJsonMeta,
        dataJson.isAcceptableOrUnknown(data['data_json']!, _dataJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_dataJsonMeta);
    }
    if (data.containsKey('scheme_override')) {
      context.handle(
        _schemeOverrideMeta,
        schemeOverride.isAcceptableOrUnknown(
          data['scheme_override']!,
          _schemeOverrideMeta,
        ),
      );
    }
    if (data.containsKey('attempts')) {
      context.handle(
        _attemptsMeta,
        attempts.isAcceptableOrUnknown(data['attempts']!, _attemptsMeta),
      );
    }
    if (data.containsKey('last_error')) {
      context.handle(
        _lastErrorMeta,
        lastError.isAcceptableOrUnknown(data['last_error']!, _lastErrorMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {localId};
  @override
  PendingUpdatesTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PendingUpdatesTableData(
      localId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}local_id'],
      )!,
      targetTable: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}target_table'],
      )!,
      recordId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}record_id'],
      )!,
      dataJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}data_json'],
      )!,
      schemeOverride: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}scheme_override'],
      ),
      attempts: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}attempts'],
      )!,
      lastError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_error'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $PendingUpdatesTableTable createAlias(String alias) {
    return $PendingUpdatesTableTable(attachedDatabase, alias);
  }
}

class PendingUpdatesTableData extends DataClass
    implements Insertable<PendingUpdatesTableData> {
  final int localId;
  final String targetTable;
  final String recordId;
  final String dataJson;
  final String? schemeOverride;
  final int attempts;
  final String? lastError;
  final DateTime createdAt;
  const PendingUpdatesTableData({
    required this.localId,
    required this.targetTable,
    required this.recordId,
    required this.dataJson,
    this.schemeOverride,
    required this.attempts,
    this.lastError,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['local_id'] = Variable<int>(localId);
    map['target_table'] = Variable<String>(targetTable);
    map['record_id'] = Variable<String>(recordId);
    map['data_json'] = Variable<String>(dataJson);
    if (!nullToAbsent || schemeOverride != null) {
      map['scheme_override'] = Variable<String>(schemeOverride);
    }
    map['attempts'] = Variable<int>(attempts);
    if (!nullToAbsent || lastError != null) {
      map['last_error'] = Variable<String>(lastError);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  PendingUpdatesTableCompanion toCompanion(bool nullToAbsent) {
    return PendingUpdatesTableCompanion(
      localId: Value(localId),
      targetTable: Value(targetTable),
      recordId: Value(recordId),
      dataJson: Value(dataJson),
      schemeOverride: schemeOverride == null && nullToAbsent
          ? const Value.absent()
          : Value(schemeOverride),
      attempts: Value(attempts),
      lastError: lastError == null && nullToAbsent
          ? const Value.absent()
          : Value(lastError),
      createdAt: Value(createdAt),
    );
  }

  factory PendingUpdatesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PendingUpdatesTableData(
      localId: serializer.fromJson<int>(json['localId']),
      targetTable: serializer.fromJson<String>(json['targetTable']),
      recordId: serializer.fromJson<String>(json['recordId']),
      dataJson: serializer.fromJson<String>(json['dataJson']),
      schemeOverride: serializer.fromJson<String?>(json['schemeOverride']),
      attempts: serializer.fromJson<int>(json['attempts']),
      lastError: serializer.fromJson<String?>(json['lastError']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'localId': serializer.toJson<int>(localId),
      'targetTable': serializer.toJson<String>(targetTable),
      'recordId': serializer.toJson<String>(recordId),
      'dataJson': serializer.toJson<String>(dataJson),
      'schemeOverride': serializer.toJson<String?>(schemeOverride),
      'attempts': serializer.toJson<int>(attempts),
      'lastError': serializer.toJson<String?>(lastError),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  PendingUpdatesTableData copyWith({
    int? localId,
    String? targetTable,
    String? recordId,
    String? dataJson,
    Value<String?> schemeOverride = const Value.absent(),
    int? attempts,
    Value<String?> lastError = const Value.absent(),
    DateTime? createdAt,
  }) => PendingUpdatesTableData(
    localId: localId ?? this.localId,
    targetTable: targetTable ?? this.targetTable,
    recordId: recordId ?? this.recordId,
    dataJson: dataJson ?? this.dataJson,
    schemeOverride: schemeOverride.present
        ? schemeOverride.value
        : this.schemeOverride,
    attempts: attempts ?? this.attempts,
    lastError: lastError.present ? lastError.value : this.lastError,
    createdAt: createdAt ?? this.createdAt,
  );
  PendingUpdatesTableData copyWithCompanion(PendingUpdatesTableCompanion data) {
    return PendingUpdatesTableData(
      localId: data.localId.present ? data.localId.value : this.localId,
      targetTable: data.targetTable.present
          ? data.targetTable.value
          : this.targetTable,
      recordId: data.recordId.present ? data.recordId.value : this.recordId,
      dataJson: data.dataJson.present ? data.dataJson.value : this.dataJson,
      schemeOverride: data.schemeOverride.present
          ? data.schemeOverride.value
          : this.schemeOverride,
      attempts: data.attempts.present ? data.attempts.value : this.attempts,
      lastError: data.lastError.present ? data.lastError.value : this.lastError,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PendingUpdatesTableData(')
          ..write('localId: $localId, ')
          ..write('targetTable: $targetTable, ')
          ..write('recordId: $recordId, ')
          ..write('dataJson: $dataJson, ')
          ..write('schemeOverride: $schemeOverride, ')
          ..write('attempts: $attempts, ')
          ..write('lastError: $lastError, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    localId,
    targetTable,
    recordId,
    dataJson,
    schemeOverride,
    attempts,
    lastError,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PendingUpdatesTableData &&
          other.localId == this.localId &&
          other.targetTable == this.targetTable &&
          other.recordId == this.recordId &&
          other.dataJson == this.dataJson &&
          other.schemeOverride == this.schemeOverride &&
          other.attempts == this.attempts &&
          other.lastError == this.lastError &&
          other.createdAt == this.createdAt);
}

class PendingUpdatesTableCompanion
    extends UpdateCompanion<PendingUpdatesTableData> {
  final Value<int> localId;
  final Value<String> targetTable;
  final Value<String> recordId;
  final Value<String> dataJson;
  final Value<String?> schemeOverride;
  final Value<int> attempts;
  final Value<String?> lastError;
  final Value<DateTime> createdAt;
  const PendingUpdatesTableCompanion({
    this.localId = const Value.absent(),
    this.targetTable = const Value.absent(),
    this.recordId = const Value.absent(),
    this.dataJson = const Value.absent(),
    this.schemeOverride = const Value.absent(),
    this.attempts = const Value.absent(),
    this.lastError = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  PendingUpdatesTableCompanion.insert({
    this.localId = const Value.absent(),
    required String targetTable,
    required String recordId,
    required String dataJson,
    this.schemeOverride = const Value.absent(),
    this.attempts = const Value.absent(),
    this.lastError = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : targetTable = Value(targetTable),
       recordId = Value(recordId),
       dataJson = Value(dataJson);
  static Insertable<PendingUpdatesTableData> custom({
    Expression<int>? localId,
    Expression<String>? targetTable,
    Expression<String>? recordId,
    Expression<String>? dataJson,
    Expression<String>? schemeOverride,
    Expression<int>? attempts,
    Expression<String>? lastError,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (localId != null) 'local_id': localId,
      if (targetTable != null) 'target_table': targetTable,
      if (recordId != null) 'record_id': recordId,
      if (dataJson != null) 'data_json': dataJson,
      if (schemeOverride != null) 'scheme_override': schemeOverride,
      if (attempts != null) 'attempts': attempts,
      if (lastError != null) 'last_error': lastError,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  PendingUpdatesTableCompanion copyWith({
    Value<int>? localId,
    Value<String>? targetTable,
    Value<String>? recordId,
    Value<String>? dataJson,
    Value<String?>? schemeOverride,
    Value<int>? attempts,
    Value<String?>? lastError,
    Value<DateTime>? createdAt,
  }) {
    return PendingUpdatesTableCompanion(
      localId: localId ?? this.localId,
      targetTable: targetTable ?? this.targetTable,
      recordId: recordId ?? this.recordId,
      dataJson: dataJson ?? this.dataJson,
      schemeOverride: schemeOverride ?? this.schemeOverride,
      attempts: attempts ?? this.attempts,
      lastError: lastError ?? this.lastError,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (localId.present) {
      map['local_id'] = Variable<int>(localId.value);
    }
    if (targetTable.present) {
      map['target_table'] = Variable<String>(targetTable.value);
    }
    if (recordId.present) {
      map['record_id'] = Variable<String>(recordId.value);
    }
    if (dataJson.present) {
      map['data_json'] = Variable<String>(dataJson.value);
    }
    if (schemeOverride.present) {
      map['scheme_override'] = Variable<String>(schemeOverride.value);
    }
    if (attempts.present) {
      map['attempts'] = Variable<int>(attempts.value);
    }
    if (lastError.present) {
      map['last_error'] = Variable<String>(lastError.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PendingUpdatesTableCompanion(')
          ..write('localId: $localId, ')
          ..write('targetTable: $targetTable, ')
          ..write('recordId: $recordId, ')
          ..write('dataJson: $dataJson, ')
          ..write('schemeOverride: $schemeOverride, ')
          ..write('attempts: $attempts, ')
          ..write('lastError: $lastError, ')
          ..write('createdAt: $createdAt')
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
  late final $CustomersTableTable customersTable = $CustomersTableTable(this);
  late final $ProjectsTableTable projectsTable = $ProjectsTableTable(this);
  late final $UsersTableTable usersTable = $UsersTableTable(this);
  late final $InventoriesTableTable inventoriesTable = $InventoriesTableTable(
    this,
  );
  late final $PermissionSettingsTableTable permissionSettingsTable =
      $PermissionSettingsTableTable(this);
  late final $TimeReportsTableTable timeReportsTable = $TimeReportsTableTable(
    this,
  );
  late final $PendingUpdatesTableTable pendingUpdatesTable =
      $PendingUpdatesTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    workOrdersTable,
    customersTable,
    projectsTable,
    usersTable,
    inventoriesTable,
    permissionSettingsTable,
    timeReportsTable,
    pendingUpdatesTable,
  ];
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
typedef $$CustomersTableTableCreateCompanionBuilder =
    CustomersTableCompanion Function({
      required String id,
      Value<String> rawJson,
      Value<DateTime> cachedAt,
      Value<int> rowid,
    });
typedef $$CustomersTableTableUpdateCompanionBuilder =
    CustomersTableCompanion Function({
      Value<String> id,
      Value<String> rawJson,
      Value<DateTime> cachedAt,
      Value<int> rowid,
    });

class $$CustomersTableTableFilterComposer
    extends Composer<_$AppDatabase, $CustomersTableTable> {
  $$CustomersTableTableFilterComposer({
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

  ColumnFilters<String> get rawJson => $composableBuilder(
    column: $table.rawJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CustomersTableTableOrderingComposer
    extends Composer<_$AppDatabase, $CustomersTableTable> {
  $$CustomersTableTableOrderingComposer({
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

  ColumnOrderings<String> get rawJson => $composableBuilder(
    column: $table.rawJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CustomersTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $CustomersTableTable> {
  $$CustomersTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get rawJson =>
      $composableBuilder(column: $table.rawJson, builder: (column) => column);

  GeneratedColumn<DateTime> get cachedAt =>
      $composableBuilder(column: $table.cachedAt, builder: (column) => column);
}

class $$CustomersTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CustomersTableTable,
          CustomersTableData,
          $$CustomersTableTableFilterComposer,
          $$CustomersTableTableOrderingComposer,
          $$CustomersTableTableAnnotationComposer,
          $$CustomersTableTableCreateCompanionBuilder,
          $$CustomersTableTableUpdateCompanionBuilder,
          (
            CustomersTableData,
            BaseReferences<
              _$AppDatabase,
              $CustomersTableTable,
              CustomersTableData
            >,
          ),
          CustomersTableData,
          PrefetchHooks Function()
        > {
  $$CustomersTableTableTableManager(
    _$AppDatabase db,
    $CustomersTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CustomersTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CustomersTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CustomersTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> rawJson = const Value.absent(),
                Value<DateTime> cachedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CustomersTableCompanion(
                id: id,
                rawJson: rawJson,
                cachedAt: cachedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String> rawJson = const Value.absent(),
                Value<DateTime> cachedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CustomersTableCompanion.insert(
                id: id,
                rawJson: rawJson,
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

typedef $$CustomersTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CustomersTableTable,
      CustomersTableData,
      $$CustomersTableTableFilterComposer,
      $$CustomersTableTableOrderingComposer,
      $$CustomersTableTableAnnotationComposer,
      $$CustomersTableTableCreateCompanionBuilder,
      $$CustomersTableTableUpdateCompanionBuilder,
      (
        CustomersTableData,
        BaseReferences<_$AppDatabase, $CustomersTableTable, CustomersTableData>,
      ),
      CustomersTableData,
      PrefetchHooks Function()
    >;
typedef $$ProjectsTableTableCreateCompanionBuilder =
    ProjectsTableCompanion Function({
      required String id,
      required String rawJson,
      required DateTime cachedAt,
      Value<int> rowid,
    });
typedef $$ProjectsTableTableUpdateCompanionBuilder =
    ProjectsTableCompanion Function({
      Value<String> id,
      Value<String> rawJson,
      Value<DateTime> cachedAt,
      Value<int> rowid,
    });

class $$ProjectsTableTableFilterComposer
    extends Composer<_$AppDatabase, $ProjectsTableTable> {
  $$ProjectsTableTableFilterComposer({
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

  ColumnFilters<String> get rawJson => $composableBuilder(
    column: $table.rawJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ProjectsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ProjectsTableTable> {
  $$ProjectsTableTableOrderingComposer({
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

  ColumnOrderings<String> get rawJson => $composableBuilder(
    column: $table.rawJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProjectsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProjectsTableTable> {
  $$ProjectsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get rawJson =>
      $composableBuilder(column: $table.rawJson, builder: (column) => column);

  GeneratedColumn<DateTime> get cachedAt =>
      $composableBuilder(column: $table.cachedAt, builder: (column) => column);
}

class $$ProjectsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProjectsTableTable,
          ProjectsTableData,
          $$ProjectsTableTableFilterComposer,
          $$ProjectsTableTableOrderingComposer,
          $$ProjectsTableTableAnnotationComposer,
          $$ProjectsTableTableCreateCompanionBuilder,
          $$ProjectsTableTableUpdateCompanionBuilder,
          (
            ProjectsTableData,
            BaseReferences<
              _$AppDatabase,
              $ProjectsTableTable,
              ProjectsTableData
            >,
          ),
          ProjectsTableData,
          PrefetchHooks Function()
        > {
  $$ProjectsTableTableTableManager(_$AppDatabase db, $ProjectsTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProjectsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProjectsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProjectsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> rawJson = const Value.absent(),
                Value<DateTime> cachedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProjectsTableCompanion(
                id: id,
                rawJson: rawJson,
                cachedAt: cachedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String rawJson,
                required DateTime cachedAt,
                Value<int> rowid = const Value.absent(),
              }) => ProjectsTableCompanion.insert(
                id: id,
                rawJson: rawJson,
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

typedef $$ProjectsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProjectsTableTable,
      ProjectsTableData,
      $$ProjectsTableTableFilterComposer,
      $$ProjectsTableTableOrderingComposer,
      $$ProjectsTableTableAnnotationComposer,
      $$ProjectsTableTableCreateCompanionBuilder,
      $$ProjectsTableTableUpdateCompanionBuilder,
      (
        ProjectsTableData,
        BaseReferences<_$AppDatabase, $ProjectsTableTable, ProjectsTableData>,
      ),
      ProjectsTableData,
      PrefetchHooks Function()
    >;
typedef $$UsersTableTableCreateCompanionBuilder =
    UsersTableCompanion Function({
      required String id,
      required String rawJson,
      required DateTime cachedAt,
      Value<int> rowid,
    });
typedef $$UsersTableTableUpdateCompanionBuilder =
    UsersTableCompanion Function({
      Value<String> id,
      Value<String> rawJson,
      Value<DateTime> cachedAt,
      Value<int> rowid,
    });

class $$UsersTableTableFilterComposer
    extends Composer<_$AppDatabase, $UsersTableTable> {
  $$UsersTableTableFilterComposer({
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

  ColumnFilters<String> get rawJson => $composableBuilder(
    column: $table.rawJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UsersTableTableOrderingComposer
    extends Composer<_$AppDatabase, $UsersTableTable> {
  $$UsersTableTableOrderingComposer({
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

  ColumnOrderings<String> get rawJson => $composableBuilder(
    column: $table.rawJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UsersTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsersTableTable> {
  $$UsersTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get rawJson =>
      $composableBuilder(column: $table.rawJson, builder: (column) => column);

  GeneratedColumn<DateTime> get cachedAt =>
      $composableBuilder(column: $table.cachedAt, builder: (column) => column);
}

class $$UsersTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UsersTableTable,
          UsersTableData,
          $$UsersTableTableFilterComposer,
          $$UsersTableTableOrderingComposer,
          $$UsersTableTableAnnotationComposer,
          $$UsersTableTableCreateCompanionBuilder,
          $$UsersTableTableUpdateCompanionBuilder,
          (
            UsersTableData,
            BaseReferences<_$AppDatabase, $UsersTableTable, UsersTableData>,
          ),
          UsersTableData,
          PrefetchHooks Function()
        > {
  $$UsersTableTableTableManager(_$AppDatabase db, $UsersTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsersTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsersTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsersTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> rawJson = const Value.absent(),
                Value<DateTime> cachedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UsersTableCompanion(
                id: id,
                rawJson: rawJson,
                cachedAt: cachedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String rawJson,
                required DateTime cachedAt,
                Value<int> rowid = const Value.absent(),
              }) => UsersTableCompanion.insert(
                id: id,
                rawJson: rawJson,
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

typedef $$UsersTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UsersTableTable,
      UsersTableData,
      $$UsersTableTableFilterComposer,
      $$UsersTableTableOrderingComposer,
      $$UsersTableTableAnnotationComposer,
      $$UsersTableTableCreateCompanionBuilder,
      $$UsersTableTableUpdateCompanionBuilder,
      (
        UsersTableData,
        BaseReferences<_$AppDatabase, $UsersTableTable, UsersTableData>,
      ),
      UsersTableData,
      PrefetchHooks Function()
    >;
typedef $$InventoriesTableTableCreateCompanionBuilder =
    InventoriesTableCompanion Function({
      required String id,
      required String rawJson,
      required DateTime cachedAt,
      Value<int> rowid,
    });
typedef $$InventoriesTableTableUpdateCompanionBuilder =
    InventoriesTableCompanion Function({
      Value<String> id,
      Value<String> rawJson,
      Value<DateTime> cachedAt,
      Value<int> rowid,
    });

class $$InventoriesTableTableFilterComposer
    extends Composer<_$AppDatabase, $InventoriesTableTable> {
  $$InventoriesTableTableFilterComposer({
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

  ColumnFilters<String> get rawJson => $composableBuilder(
    column: $table.rawJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$InventoriesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $InventoriesTableTable> {
  $$InventoriesTableTableOrderingComposer({
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

  ColumnOrderings<String> get rawJson => $composableBuilder(
    column: $table.rawJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$InventoriesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $InventoriesTableTable> {
  $$InventoriesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get rawJson =>
      $composableBuilder(column: $table.rawJson, builder: (column) => column);

  GeneratedColumn<DateTime> get cachedAt =>
      $composableBuilder(column: $table.cachedAt, builder: (column) => column);
}

class $$InventoriesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $InventoriesTableTable,
          InventoriesTableData,
          $$InventoriesTableTableFilterComposer,
          $$InventoriesTableTableOrderingComposer,
          $$InventoriesTableTableAnnotationComposer,
          $$InventoriesTableTableCreateCompanionBuilder,
          $$InventoriesTableTableUpdateCompanionBuilder,
          (
            InventoriesTableData,
            BaseReferences<
              _$AppDatabase,
              $InventoriesTableTable,
              InventoriesTableData
            >,
          ),
          InventoriesTableData,
          PrefetchHooks Function()
        > {
  $$InventoriesTableTableTableManager(
    _$AppDatabase db,
    $InventoriesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InventoriesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InventoriesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InventoriesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> rawJson = const Value.absent(),
                Value<DateTime> cachedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => InventoriesTableCompanion(
                id: id,
                rawJson: rawJson,
                cachedAt: cachedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String rawJson,
                required DateTime cachedAt,
                Value<int> rowid = const Value.absent(),
              }) => InventoriesTableCompanion.insert(
                id: id,
                rawJson: rawJson,
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

typedef $$InventoriesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $InventoriesTableTable,
      InventoriesTableData,
      $$InventoriesTableTableFilterComposer,
      $$InventoriesTableTableOrderingComposer,
      $$InventoriesTableTableAnnotationComposer,
      $$InventoriesTableTableCreateCompanionBuilder,
      $$InventoriesTableTableUpdateCompanionBuilder,
      (
        InventoriesTableData,
        BaseReferences<
          _$AppDatabase,
          $InventoriesTableTable,
          InventoriesTableData
        >,
      ),
      InventoriesTableData,
      PrefetchHooks Function()
    >;
typedef $$PermissionSettingsTableTableCreateCompanionBuilder =
    PermissionSettingsTableCompanion Function({
      required String id,
      required String rawJson,
      required DateTime cachedAt,
      Value<int> rowid,
    });
typedef $$PermissionSettingsTableTableUpdateCompanionBuilder =
    PermissionSettingsTableCompanion Function({
      Value<String> id,
      Value<String> rawJson,
      Value<DateTime> cachedAt,
      Value<int> rowid,
    });

class $$PermissionSettingsTableTableFilterComposer
    extends Composer<_$AppDatabase, $PermissionSettingsTableTable> {
  $$PermissionSettingsTableTableFilterComposer({
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

  ColumnFilters<String> get rawJson => $composableBuilder(
    column: $table.rawJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PermissionSettingsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $PermissionSettingsTableTable> {
  $$PermissionSettingsTableTableOrderingComposer({
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

  ColumnOrderings<String> get rawJson => $composableBuilder(
    column: $table.rawJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PermissionSettingsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $PermissionSettingsTableTable> {
  $$PermissionSettingsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get rawJson =>
      $composableBuilder(column: $table.rawJson, builder: (column) => column);

  GeneratedColumn<DateTime> get cachedAt =>
      $composableBuilder(column: $table.cachedAt, builder: (column) => column);
}

class $$PermissionSettingsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PermissionSettingsTableTable,
          PermissionSettingsTableData,
          $$PermissionSettingsTableTableFilterComposer,
          $$PermissionSettingsTableTableOrderingComposer,
          $$PermissionSettingsTableTableAnnotationComposer,
          $$PermissionSettingsTableTableCreateCompanionBuilder,
          $$PermissionSettingsTableTableUpdateCompanionBuilder,
          (
            PermissionSettingsTableData,
            BaseReferences<
              _$AppDatabase,
              $PermissionSettingsTableTable,
              PermissionSettingsTableData
            >,
          ),
          PermissionSettingsTableData,
          PrefetchHooks Function()
        > {
  $$PermissionSettingsTableTableTableManager(
    _$AppDatabase db,
    $PermissionSettingsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PermissionSettingsTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$PermissionSettingsTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$PermissionSettingsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> rawJson = const Value.absent(),
                Value<DateTime> cachedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PermissionSettingsTableCompanion(
                id: id,
                rawJson: rawJson,
                cachedAt: cachedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String rawJson,
                required DateTime cachedAt,
                Value<int> rowid = const Value.absent(),
              }) => PermissionSettingsTableCompanion.insert(
                id: id,
                rawJson: rawJson,
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

typedef $$PermissionSettingsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PermissionSettingsTableTable,
      PermissionSettingsTableData,
      $$PermissionSettingsTableTableFilterComposer,
      $$PermissionSettingsTableTableOrderingComposer,
      $$PermissionSettingsTableTableAnnotationComposer,
      $$PermissionSettingsTableTableCreateCompanionBuilder,
      $$PermissionSettingsTableTableUpdateCompanionBuilder,
      (
        PermissionSettingsTableData,
        BaseReferences<
          _$AppDatabase,
          $PermissionSettingsTableTable,
          PermissionSettingsTableData
        >,
      ),
      PermissionSettingsTableData,
      PrefetchHooks Function()
    >;
typedef $$TimeReportsTableTableCreateCompanionBuilder =
    TimeReportsTableCompanion Function({
      required String id,
      required String rawJson,
      required DateTime cachedAt,
      Value<int> rowid,
    });
typedef $$TimeReportsTableTableUpdateCompanionBuilder =
    TimeReportsTableCompanion Function({
      Value<String> id,
      Value<String> rawJson,
      Value<DateTime> cachedAt,
      Value<int> rowid,
    });

class $$TimeReportsTableTableFilterComposer
    extends Composer<_$AppDatabase, $TimeReportsTableTable> {
  $$TimeReportsTableTableFilterComposer({
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

  ColumnFilters<String> get rawJson => $composableBuilder(
    column: $table.rawJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TimeReportsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $TimeReportsTableTable> {
  $$TimeReportsTableTableOrderingComposer({
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

  ColumnOrderings<String> get rawJson => $composableBuilder(
    column: $table.rawJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TimeReportsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $TimeReportsTableTable> {
  $$TimeReportsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get rawJson =>
      $composableBuilder(column: $table.rawJson, builder: (column) => column);

  GeneratedColumn<DateTime> get cachedAt =>
      $composableBuilder(column: $table.cachedAt, builder: (column) => column);
}

class $$TimeReportsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TimeReportsTableTable,
          TimeReportsTableData,
          $$TimeReportsTableTableFilterComposer,
          $$TimeReportsTableTableOrderingComposer,
          $$TimeReportsTableTableAnnotationComposer,
          $$TimeReportsTableTableCreateCompanionBuilder,
          $$TimeReportsTableTableUpdateCompanionBuilder,
          (
            TimeReportsTableData,
            BaseReferences<
              _$AppDatabase,
              $TimeReportsTableTable,
              TimeReportsTableData
            >,
          ),
          TimeReportsTableData,
          PrefetchHooks Function()
        > {
  $$TimeReportsTableTableTableManager(
    _$AppDatabase db,
    $TimeReportsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TimeReportsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TimeReportsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TimeReportsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> rawJson = const Value.absent(),
                Value<DateTime> cachedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TimeReportsTableCompanion(
                id: id,
                rawJson: rawJson,
                cachedAt: cachedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String rawJson,
                required DateTime cachedAt,
                Value<int> rowid = const Value.absent(),
              }) => TimeReportsTableCompanion.insert(
                id: id,
                rawJson: rawJson,
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

typedef $$TimeReportsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TimeReportsTableTable,
      TimeReportsTableData,
      $$TimeReportsTableTableFilterComposer,
      $$TimeReportsTableTableOrderingComposer,
      $$TimeReportsTableTableAnnotationComposer,
      $$TimeReportsTableTableCreateCompanionBuilder,
      $$TimeReportsTableTableUpdateCompanionBuilder,
      (
        TimeReportsTableData,
        BaseReferences<
          _$AppDatabase,
          $TimeReportsTableTable,
          TimeReportsTableData
        >,
      ),
      TimeReportsTableData,
      PrefetchHooks Function()
    >;
typedef $$PendingUpdatesTableTableCreateCompanionBuilder =
    PendingUpdatesTableCompanion Function({
      Value<int> localId,
      required String targetTable,
      required String recordId,
      required String dataJson,
      Value<String?> schemeOverride,
      Value<int> attempts,
      Value<String?> lastError,
      Value<DateTime> createdAt,
    });
typedef $$PendingUpdatesTableTableUpdateCompanionBuilder =
    PendingUpdatesTableCompanion Function({
      Value<int> localId,
      Value<String> targetTable,
      Value<String> recordId,
      Value<String> dataJson,
      Value<String?> schemeOverride,
      Value<int> attempts,
      Value<String?> lastError,
      Value<DateTime> createdAt,
    });

class $$PendingUpdatesTableTableFilterComposer
    extends Composer<_$AppDatabase, $PendingUpdatesTableTable> {
  $$PendingUpdatesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get localId => $composableBuilder(
    column: $table.localId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get targetTable => $composableBuilder(
    column: $table.targetTable,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recordId => $composableBuilder(
    column: $table.recordId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dataJson => $composableBuilder(
    column: $table.dataJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get schemeOverride => $composableBuilder(
    column: $table.schemeOverride,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PendingUpdatesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $PendingUpdatesTableTable> {
  $$PendingUpdatesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get localId => $composableBuilder(
    column: $table.localId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get targetTable => $composableBuilder(
    column: $table.targetTable,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recordId => $composableBuilder(
    column: $table.recordId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dataJson => $composableBuilder(
    column: $table.dataJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get schemeOverride => $composableBuilder(
    column: $table.schemeOverride,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PendingUpdatesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $PendingUpdatesTableTable> {
  $$PendingUpdatesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get localId =>
      $composableBuilder(column: $table.localId, builder: (column) => column);

  GeneratedColumn<String> get targetTable => $composableBuilder(
    column: $table.targetTable,
    builder: (column) => column,
  );

  GeneratedColumn<String> get recordId =>
      $composableBuilder(column: $table.recordId, builder: (column) => column);

  GeneratedColumn<String> get dataJson =>
      $composableBuilder(column: $table.dataJson, builder: (column) => column);

  GeneratedColumn<String> get schemeOverride => $composableBuilder(
    column: $table.schemeOverride,
    builder: (column) => column,
  );

  GeneratedColumn<int> get attempts =>
      $composableBuilder(column: $table.attempts, builder: (column) => column);

  GeneratedColumn<String> get lastError =>
      $composableBuilder(column: $table.lastError, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$PendingUpdatesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PendingUpdatesTableTable,
          PendingUpdatesTableData,
          $$PendingUpdatesTableTableFilterComposer,
          $$PendingUpdatesTableTableOrderingComposer,
          $$PendingUpdatesTableTableAnnotationComposer,
          $$PendingUpdatesTableTableCreateCompanionBuilder,
          $$PendingUpdatesTableTableUpdateCompanionBuilder,
          (
            PendingUpdatesTableData,
            BaseReferences<
              _$AppDatabase,
              $PendingUpdatesTableTable,
              PendingUpdatesTableData
            >,
          ),
          PendingUpdatesTableData,
          PrefetchHooks Function()
        > {
  $$PendingUpdatesTableTableTableManager(
    _$AppDatabase db,
    $PendingUpdatesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PendingUpdatesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PendingUpdatesTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$PendingUpdatesTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> localId = const Value.absent(),
                Value<String> targetTable = const Value.absent(),
                Value<String> recordId = const Value.absent(),
                Value<String> dataJson = const Value.absent(),
                Value<String?> schemeOverride = const Value.absent(),
                Value<int> attempts = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => PendingUpdatesTableCompanion(
                localId: localId,
                targetTable: targetTable,
                recordId: recordId,
                dataJson: dataJson,
                schemeOverride: schemeOverride,
                attempts: attempts,
                lastError: lastError,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> localId = const Value.absent(),
                required String targetTable,
                required String recordId,
                required String dataJson,
                Value<String?> schemeOverride = const Value.absent(),
                Value<int> attempts = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => PendingUpdatesTableCompanion.insert(
                localId: localId,
                targetTable: targetTable,
                recordId: recordId,
                dataJson: dataJson,
                schemeOverride: schemeOverride,
                attempts: attempts,
                lastError: lastError,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PendingUpdatesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PendingUpdatesTableTable,
      PendingUpdatesTableData,
      $$PendingUpdatesTableTableFilterComposer,
      $$PendingUpdatesTableTableOrderingComposer,
      $$PendingUpdatesTableTableAnnotationComposer,
      $$PendingUpdatesTableTableCreateCompanionBuilder,
      $$PendingUpdatesTableTableUpdateCompanionBuilder,
      (
        PendingUpdatesTableData,
        BaseReferences<
          _$AppDatabase,
          $PendingUpdatesTableTable,
          PendingUpdatesTableData
        >,
      ),
      PendingUpdatesTableData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$WorkOrdersTableTableTableManager get workOrdersTable =>
      $$WorkOrdersTableTableTableManager(_db, _db.workOrdersTable);
  $$CustomersTableTableTableManager get customersTable =>
      $$CustomersTableTableTableManager(_db, _db.customersTable);
  $$ProjectsTableTableTableManager get projectsTable =>
      $$ProjectsTableTableTableManager(_db, _db.projectsTable);
  $$UsersTableTableTableManager get usersTable =>
      $$UsersTableTableTableManager(_db, _db.usersTable);
  $$InventoriesTableTableTableManager get inventoriesTable =>
      $$InventoriesTableTableTableManager(_db, _db.inventoriesTable);
  $$PermissionSettingsTableTableTableManager get permissionSettingsTable =>
      $$PermissionSettingsTableTableTableManager(
        _db,
        _db.permissionSettingsTable,
      );
  $$TimeReportsTableTableTableManager get timeReportsTable =>
      $$TimeReportsTableTableTableManager(_db, _db.timeReportsTable);
  $$PendingUpdatesTableTableTableManager get pendingUpdatesTable =>
      $$PendingUpdatesTableTableTableManager(_db, _db.pendingUpdatesTable);
}
