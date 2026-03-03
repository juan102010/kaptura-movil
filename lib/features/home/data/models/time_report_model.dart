class TimeReportModel {
  const TimeReportModel({
    required this.id,
    required this.userId,
    required this.type,
    required this.atISO,
    required this.coords,
    required this.reason,
  });

  final String id;
  final String userId;
  final String type;
  final String atISO;
  final Map<String, dynamic> coords;
  final String? reason;

  factory TimeReportModel.fromJson(Map<String, dynamic> json) {
    return TimeReportModel(
      id: (json['_id'] ?? '').toString(),
      userId: (json['userId'] ?? '').toString(),
      type: (json['type'] ?? '').toString(),
      atISO: (json['atISO'] ?? '').toString(),
      coords: (json['coords'] is Map<String, dynamic>)
          ? (json['coords'] as Map<String, dynamic>)
          : <String, dynamic>{},
      reason: json['reason']?.toString(),
    );
  }
}
