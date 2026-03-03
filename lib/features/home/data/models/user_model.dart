class UserModel {
  const UserModel({
    required this.id,
    required this.name,
    required this.stateClock,
  });

  final String id;
  final String name;
  final bool stateClock;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: (json['_id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      stateClock: (json['stateClock'] ?? false) == true,
    );
  }
}
