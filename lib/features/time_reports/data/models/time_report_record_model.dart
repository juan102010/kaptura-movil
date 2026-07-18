import '../../domain/entities/time_report_record_entity.dart';

class TimeReportRecordModel extends TimeReportRecordEntity {
  const TimeReportRecordModel({
    required super.id,
    required super.userId,
    required super.type,
    required super.atIso,
    required super.atLocal,
    required super.timeZone,
    required super.reason,
    required super.rawData,
  });

  factory TimeReportRecordModel.fromMap(Map<String, dynamic> map) {
    return TimeReportRecordModel(
      id: (map['_id'] ?? map['id'] ?? '').toString().trim(),
      userId: (map['userId'] ?? '').toString().trim(),
      type: (map['type'] ?? '').toString().trim(),
      atIso: (map['atISO'] ?? '').toString().trim(),
      atLocal: (map['atLocal'] ?? '').toString().trim(),
      timeZone: (map['tz'] ?? '').toString().trim(),
      reason: map['reason']?.toString(),
      rawData: Map<String, dynamic>.from(map),
    );
  }
}
