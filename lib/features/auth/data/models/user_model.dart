import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    super.role = '',
    super.scheme = '',
    super.schemeId = '',
    super.idPlans = '',
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: (json['id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      role: (json['role'] ?? '').toString(),
      scheme: (json['scheme'] ?? '').toString(),
      schemeId: (json['schemeId'] ?? '').toString(),
      idPlans: (json['idPlans'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'scheme': scheme,
      'schemeId': schemeId,
      'idPlans': idPlans,
    };
  }
}
