import '../../domain/entities/user_list_entity.dart';

class UserListModel extends UserListEntity {
  const UserListModel({
    required super.id,
    required super.name,
    required super.email,
    required super.identification,
    required super.role,
    required super.scheme,
    required super.companyId,
    required super.clusterKey,
    required super.status,
    required super.stateClock,
    required super.allowedClusterKeys,
    required super.entryAndExitHistory,
    required super.rawData,
  });

  factory UserListModel.fromMap(Map<String, dynamic> map) {
    return UserListModel(
      id: (map['_id'] ?? '').toString().trim(),
      name: (map['name'] ?? 'No name').toString().trim(),
      email: (map['email'] ?? '').toString().trim(),
      identification: (map['identification'] ?? '').toString().trim(),
      role: (map['role'] ?? '').toString().trim(),
      scheme: (map['scheme'] ?? '').toString().trim(),
      companyId: (map['company_id'] ?? '').toString().trim(),
      clusterKey: (map['clusterKey'] ?? '').toString().trim(),
      status: (map['status'] ?? '').toString().trim(),
      stateClock: (map['stateClock'] ?? '').toString().trim(),
      allowedClusterKeys: (map['allowedClusterKeys'] is List)
          ? (map['allowedClusterKeys'] as List)
                .map((item) => item.toString().trim())
                .where((item) => item.isNotEmpty)
                .toList()
          : const <String>[],
      entryAndExitHistory: (map['entryAndExitHistory'] is List)
          ? List<dynamic>.from(map['entryAndExitHistory'] as List)
          : const <dynamic>[],
      rawData: Map<String, dynamic>.from(map),
    );
  }

  Map<String, dynamic> toMap() => Map<String, dynamic>.from(rawData);
}
