class ProjectEntity {
  const ProjectEntity({
    required this.id,
    required this.name,
    required this.status,
    required this.dateCreated,
    required this.customerCode,
    required this.rawData,
  });

  final String id;
  final String name;
  final String status;
  final String dateCreated;
  final String customerCode;
  final Map<String, dynamic> rawData;

  String get firstWorkOrderId => _readPath(['list_workOrder_id', 0, 'id']);
  String get firstWorkOrderName => _readPath(['list_workOrder_id', 0, 'name']);

  bool matchesId(String otherId) => id == otherId.trim();

  String _readPath(List<dynamic> path) {
    dynamic current = rawData;

    for (final segment in path) {
      if (segment is String) {
        if (current is Map) {
          current = current[segment];
        } else {
          return '';
        }
      } else if (segment is int) {
        if (current is List && segment >= 0 && segment < current.length) {
          current = current[segment];
        } else {
          return '';
        }
      }
    }

    return (current ?? '').toString().trim();
  }
}
