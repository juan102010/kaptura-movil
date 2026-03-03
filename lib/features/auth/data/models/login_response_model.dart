import '../../domain/entities/auth_session_entity.dart';
import 'user_model.dart';

class LoginResponseModel extends AuthSessionEntity {
  const LoginResponseModel({required super.token, required super.user});

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    final data =
        (json['data'] as Map?)?.cast<String, dynamic>() ?? <String, dynamic>{};

    return LoginResponseModel(
      token: (data['token'] ?? '').toString(),
      user: UserModel.fromJson(
        (data['user'] as Map?)?.cast<String, dynamic>() ?? <String, dynamic>{},
      ),
    );
  }
}
