import '../../domain/entities/time_report_entity.dart';

class TimeReportModel extends TimeReportEntity {
  const TimeReportModel({
    required super.id,
    required super.userId,
    required super.type,
    required super.atIso,
    required super.coords,
    required super.reason,
    required super.rawData,
  });

  factory TimeReportModel.fromJson(Map<String, dynamic> json) {
    final coords = json['coords'];

    return TimeReportModel(
      id: (json['_id'] ?? '').toString(),
      userId: (json['userId'] ?? '').toString(),
      type: (json['type'] ?? '').toString(),
      atIso: (json['atISO'] ?? '').toString(),
      coords: coords is Map<String, dynamic>
          ? Map<String, dynamic>.from(coords)
          : coords is Map
          ? coords.cast<String, dynamic>()
          : <String, dynamic>{},
      reason: json['reason']?.toString(),
      rawData: Map<String, dynamic>.from(json),
    );
  }
}
