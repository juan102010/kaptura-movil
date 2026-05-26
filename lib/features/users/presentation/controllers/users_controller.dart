import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/user_list_entity.dart';
import '../../domain/repositories/users_repository.dart';
import '../../domain/usecases/get_users_usecase.dart';

class UsersState {
  const UsersState({
    required this.loading,
    required this.users,
    required this.error,
    required this.fromCache,
  });

  final bool loading;
  final List<UserListEntity> users;
  final String? error;
  final bool fromCache;

  factory UsersState.initial() {
    return const UsersState(
      loading: false,
      users: <UserListEntity>[],
      error: null,
      fromCache: false,
    );
  }

  UsersState copyWith({
    bool? loading,
    List<UserListEntity>? users,
    String? error,
    bool? fromCache,
    bool clearError = false,
  }) {
    return UsersState(
      loading: loading ?? this.loading,
      users: users ?? this.users,
      error: clearError ? null : (error ?? this.error),
      fromCache: fromCache ?? this.fromCache,
    );
  }
}

class UsersController extends StateNotifier<UsersState> {
  UsersController({
    required this.getUsersUseCase,
    required this.usersRepository,
  }) : super(UsersState.initial());

  final GetUsersUseCase getUsersUseCase;
  final UsersRepository usersRepository;

  Future<void> loadCacheThenRemote() async {
    state = state.copyWith(loading: true, clearError: true);

    try {
      final cachedUsers = await usersRepository.getCachedUsers();

      if (cachedUsers.isNotEmpty) {
        state = state.copyWith(
          loading: true,
          users: cachedUsers,
          fromCache: true,
          clearError: true,
        );
      }

      final remoteUsers = await getUsersUseCase();

      state = state.copyWith(
        loading: false,
        users: remoteUsers,
        fromCache: false,
        clearError: true,
      );
    } catch (e) {
      final cachedUsers = await usersRepository.getCachedUsers();

      if (cachedUsers.isNotEmpty) {
        state = state.copyWith(
          loading: false,
          users: cachedUsers,
          fromCache: true,
          error:
              'No se pudo actualizar desde remoto. Mostrando datos en cache.',
        );
        return;
      }

      state = state.copyWith(loading: false, error: e.toString());
    }
  }

  Future<void> refreshRemoteOnly() async {
    state = state.copyWith(loading: true, clearError: true);

    try {
      final remoteUsers = await getUsersUseCase();

      state = state.copyWith(
        loading: false,
        users: remoteUsers,
        fromCache: false,
        clearError: true,
      );
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }

  Future<void> clearCache() async {
    await usersRepository.clearUsers();

    state = state.copyWith(
      users: const <UserListEntity>[],
      fromCache: false,
      clearError: true,
    );
  }
}
