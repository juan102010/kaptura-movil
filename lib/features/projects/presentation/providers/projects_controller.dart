import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/usecases/get_projects_usecase.dart';

class ProjectsState {
  final bool loading;
  final List<Map<String, dynamic>> projects;
  final String? error;
  final bool fromCache;

  const ProjectsState({
    required this.loading,
    required this.projects,
    required this.error,
    required this.fromCache,
  });

  factory ProjectsState.initial() {
    return const ProjectsState(
      loading: false,
      projects: [],
      error: null,
      fromCache: false,
    );
  }

  ProjectsState copyWith({
    bool? loading,
    List<Map<String, dynamic>>? projects,
    String? error,
    bool clearError = false,
    bool? fromCache,
  }) {
    return ProjectsState(
      loading: loading ?? this.loading,
      projects: projects ?? this.projects,
      error: clearError ? null : (error ?? this.error),
      fromCache: fromCache ?? this.fromCache,
    );
  }
}

class ProjectsController extends StateNotifier<ProjectsState> {
  ProjectsController({required GetProjectsUsecase getProjectsUsecase})
    : _getProjectsUsecase = getProjectsUsecase,
      super(ProjectsState.initial());

  final GetProjectsUsecase _getProjectsUsecase;

  Future<void> loadCacheThenRemote() async {
    state = state.copyWith(loading: true, clearError: true);

    try {
      final cache = await _getProjectsUsecase.getCache();

      if (cache.isNotEmpty) {
        state = state.copyWith(
          loading: true,
          projects: cache,
          fromCache: true,
          clearError: true,
        );
      }

      final remote = await _getProjectsUsecase.getRemote();
      await _getProjectsUsecase.saveCache(remote);

      state = state.copyWith(
        loading: false,
        projects: remote,
        fromCache: false,
        clearError: true,
      );
    } catch (e) {
      final cache = await _getProjectsUsecase.getCache();

      if (cache.isNotEmpty) {
        state = state.copyWith(
          loading: false,
          projects: cache,
          fromCache: true,
          error:
              'No se pudo actualizar desde la API. Mostrando datos en caché.',
        );
      } else {
        state = state.copyWith(
          loading: false,
          projects: [],
          fromCache: false,
          error: 'No se pudieron cargar los proyectos: $e',
        );
      }
    }
  }

  Future<void> refreshRemoteOnly() async {
    state = state.copyWith(loading: true, clearError: true);

    try {
      final remote = await _getProjectsUsecase.getRemote();
      await _getProjectsUsecase.saveCache(remote);

      state = state.copyWith(
        loading: false,
        projects: remote,
        fromCache: false,
        clearError: true,
      );
    } catch (e) {
      state = state.copyWith(
        loading: false,
        error: 'No se pudo refrescar projects: $e',
      );
    }
  }

  Future<void> clearCache() async {
    await _getProjectsUsecase.clearCache();

    state = state.copyWith(projects: [], fromCache: false, clearError: true);
  }
}
