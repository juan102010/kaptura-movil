import '../../../work_orders/domain/entities/work_order_entity.dart';

class WorkOrderModel extends WorkOrderEntity {
  const WorkOrderModel({
    required super.id,
    required super.name,
    required super.assignedIds,
    required super.startAt,
    required super.endAt,
    required super.rawData,
  });

  factory WorkOrderModel.fromMap(Map<String, dynamic> map) {
    return WorkOrderModel(
      id: (map['_id'] ?? '').toString().trim(),
      name: (map['text_nameWorkOrder_id'] ?? '').toString().trim(),
      assignedIds: _normalizeAssignedIds(map['text_assigned_id']),
      startAt: _tryParseDate(map['date_start_id'] ?? map['__local_startAt']),
      endAt: _tryParseDate(map['date_end_id'] ?? map['__local_endAt']),
      rawData: Map<String, dynamic>.from(map),
    );
  }

  Map<String, dynamic> toMap() => Map<String, dynamic>.from(rawData);

  static List<String> _normalizeAssignedIds(dynamic assigned) {
    if (assigned == null) return <String>[];
    if (assigned is String) {
      final value = assigned.trim();
      return value.isEmpty ? <String>[] : <String>[value];
    }
    if (assigned is List) {
      return assigned
          .map((item) => item.toString().trim())
          .where((item) => item.isNotEmpty)
          .toList();
    }
    return <String>[];
  }

  static DateTime? _tryParseDate(dynamic value) {
    if (value == null) return null;
    final text = value.toString().trim();
    if (text.isEmpty) return null;
    try {
      return DateTime.parse(text);
    } catch (_) {
      return null;
    }
  }
}
