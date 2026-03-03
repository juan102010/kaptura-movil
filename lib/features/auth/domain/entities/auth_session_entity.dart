import 'user_entity.dart';

class AuthSessionEntity {
  const AuthSessionEntity({required this.token, required this.user});

  final String token;
  final UserEntity user;
}
