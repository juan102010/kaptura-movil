import '../../domain/entities/auth_session_entity.dart';

sealed class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

/// ✅ Authenticated por token (sesión persistida)
class AuthAuthenticated extends AuthState {
  const AuthAuthenticated({required this.token});
  final String token;
}

/// ✅ No autenticado (no hay token o expiró)
class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

class AuthSuccess extends AuthState {
  const AuthSuccess(this.session);
  final AuthSessionEntity session;
}

class AuthError extends AuthState {
  const AuthError(this.message);
  final String message;
}

class AuthEmpty extends AuthState {
  const AuthEmpty();
}
