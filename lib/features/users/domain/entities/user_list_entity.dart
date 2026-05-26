class UserListEntity {
  const UserListEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.identification,
    required this.role,
    required this.scheme,
    required this.companyId,
    required this.clusterKey,
    required this.status,
    required this.stateClock,
    required this.allowedClusterKeys,
    required this.entryAndExitHistory,
    required this.rawData,
  });

  final String id;
  final String name;
  final String email;
  final String identification;
  final String role;
  final String scheme;
  final String companyId;
  final String clusterKey;
  final String status;
  final String stateClock;
  final List<String> allowedClusterKeys;
  final List<dynamic> entryAndExitHistory;
  final Map<String, dynamic> rawData;

  bool matchesId(String otherId) => id == otherId.trim();
}
