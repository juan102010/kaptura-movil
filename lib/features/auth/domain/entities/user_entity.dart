class UserEntity {
  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    this.role = '',
    this.scheme = '',
    this.schemeId = '',
    this.idPlans = '',
  });

  final String id;
  final String name;
  final String email;

  // ✅ nuevos (según tu response)
  final String role;
  final String scheme;
  final String schemeId;
  final String idPlans;
}
