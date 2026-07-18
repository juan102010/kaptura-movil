import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/storage/secure_storage_service.dart';
import '../../domain/entities/permission_setting_entity.dart';
import '../../domain/repositories/permission_settings_repository.dart';

enum ProtectedModule { workOrders, inventory, timeReports }

class PermissionSettingsState {
  const PermissionSettingsState({
    required this.initialized,
    required this.permissions,
    required this.role,
  });

  const PermissionSettingsState.initial()
    : initialized = false,
      permissions = const <PermissionSettingEntity>[],
      role = '';

  final bool initialized;
  final List<PermissionSettingEntity> permissions;
  final String role;

  bool hasPermission(ProtectedModule module, String type) {
    return _grantedTypes(module).contains(type.trim().toLowerCase());
  }

  bool canAccess(ProtectedModule module) {
    final grantedTypes = _grantedTypes(module);
    return grantedTypes.contains('view') && grantedTypes.contains('read');
  }

  Set<String> _grantedTypes(ProtectedModule module) {
    if (!initialized || role.trim().isEmpty) return const <String>{};

    final aliases = switch (module) {
      ProtectedModule.inventory => const {'inventories'},
      ProtectedModule.workOrders => const {'work_orders'},
      ProtectedModule.timeReports => const {'time_reports'},
    };

    return permissions
        .where(
          (permission) =>
              permission.enabled &&
              permission.allowedRole.trim() == role.trim() &&
              aliases.contains(permission.view.trim().toLowerCase()),
        )
        .map((permission) => permission.type.trim().toLowerCase())
        .toSet();
  }
}

class PermissionSettingsController
    extends StateNotifier<PermissionSettingsState> {
  PermissionSettingsController({
    required PermissionSettingsRepository repository,
    required SecureStorageService secureStorage,
  }) : _repository = repository,
       _secureStorage = secureStorage,
       super(const PermissionSettingsState.initial());

  static const refreshInterval = Duration(minutes: 5);

  final PermissionSettingsRepository _repository;
  final SecureStorageService _secureStorage;

  Timer? _timer;
  bool _started = false;
  bool _refreshing = false;
  int _generation = 0;

  Future<void> start() async {
    if (_started) return;
    _started = true;
    final generation = ++_generation;

    final session = await _secureStorage.readSession();
    if (!_isCurrent(generation)) return;
    if (session == null) {
      stop();
      return;
    }

    final role = (session.user['role'] ?? '').toString().trim();
    final cached = await _repository.getCachedPermissionSettings();
    if (!_isCurrent(generation)) return;

    if (cached.isNotEmpty) {
      state = PermissionSettingsState(
        initialized: true,
        permissions: cached,
        role: role,
      );
    }

    await _refreshSilently(
      role: role,
      generation: generation,
      markInitializedOnFailure: true,
    );
    if (!_isCurrent(generation)) return;

    _timer = Timer.periodic(refreshInterval, (_) {
      unawaited(_refreshSilently(role: role, generation: generation));
    });
  }

  void stop() {
    _started = false;
    _generation++;
    _timer?.cancel();
    _timer = null;
    _refreshing = false;
    state = const PermissionSettingsState.initial();
  }

  Future<void> _refreshSilently({
    required String role,
    required int generation,
    bool markInitializedOnFailure = false,
  }) async {
    if (!_isCurrent(generation) || _refreshing) return;
    _refreshing = true;

    try {
      final remote = await _repository.refreshPermissionSettings();
      if (!_isCurrent(generation)) return;
      state = PermissionSettingsState(
        initialized: true,
        permissions: remote,
        role: role,
      );
    } catch (_) {
      if (_isCurrent(generation) &&
          markInitializedOnFailure &&
          !state.initialized) {
        state = PermissionSettingsState(
          initialized: true,
          permissions: const <PermissionSettingEntity>[],
          role: role,
        );
      }
    } finally {
      _refreshing = false;
    }
  }

  bool _isCurrent(int generation) => _started && _generation == generation;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
