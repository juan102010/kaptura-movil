import 'work_order_time_entry_entity.dart';

class WorkOrderEntity {
  const WorkOrderEntity({
    required this.id,
    required this.name,
    required this.assignedIds,
    required this.startAt,
    required this.endAt,
    required this.rawData,
  });

  final String id;
  final String name;
  final List<String> assignedIds;
  final DateTime? startAt;
  final DateTime? endAt;
  final Map<String, dynamic> rawData;

  String get customerId => _string(rawData['sel_customer_id']);
  String get projectId => _string(rawData['sel_project_id']);
  String get className => _string(rawData['sel_class_id']);
  String get typeName => _string(rawData['sel_type_id']);
  String get techNotes => _string(rawData['text_workTechNotes_id']);
  String get tasks => _string(rawData['text_tasks_id']);
  String get todo => _string(rawData['text_toDo_id']);
  String get workLocation => _string(rawData['text_workLocation_id']);
  String get partsToDeliver => _string(rawData['text_partsToDeliver_id']);
  String get requestParts => _string(rawData['text_requestParts_id']);
  String get donePartsUsed => _string(rawData['text_donePartsUsed_id']);
  String get leftToDoPartsNeeded =>
      _string(rawData['text_leftToDoPartsNeeded_id']);

  List<WorkOrderTimeEntryEntity> get timeHistory {
    final rawHistory = rawData['text_dateTime_id'];
    if (rawHistory is! List) return const <WorkOrderTimeEntryEntity>[];

    return rawHistory
        .whereType<Map>()
        .map(
          (item) =>
              WorkOrderTimeEntryEntity.fromMap(Map<String, dynamic>.from(item)),
        )
        .toList();
  }

  List<Map<String, dynamic>> get evidenceImages {
    final files = rawData['files_infoImagesUpload_id'];
    if (files is! List) return const <Map<String, dynamic>>[];

    return files
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }

  WorkOrderEntity withUpdatedTimeHistory(
    List<WorkOrderTimeEntryEntity> newHistory,
  ) {
    final updatedRaw = Map<String, dynamic>.from(rawData);
    updatedRaw['text_dateTime_id'] = newHistory
        .map((item) => item.toMap())
        .toList();

    return WorkOrderEntity(
      id: id,
      name: name,
      assignedIds: List<String>.from(assignedIds),
      startAt: startAt,
      endAt: endAt,
      rawData: updatedRaw,
    );
  }

  WorkOrderEntity withPatchedRawData(Map<String, dynamic> patch) {
    final updatedRaw = Map<String, dynamic>.from(rawData)..addAll(patch);
    return WorkOrderEntity(
      id: id,
      name: _string(updatedRaw['text_nameWorkOrder_id']),
      assignedIds: List<String>.from(assignedIds),
      startAt: _tryParseDate(updatedRaw['date_start_id']),
      endAt: _tryParseDate(updatedRaw['date_end_id']),
      rawData: updatedRaw,
    );
  }

  bool matchesId(String otherId) => id == otherId.trim();

  static String _string(dynamic value) => (value ?? '').toString().trim();

  static DateTime? _tryParseDate(dynamic value) {
    final text = _string(value);
    return text.isEmpty ? null : DateTime.tryParse(text);
  }
}
