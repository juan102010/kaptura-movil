import 'package:flutter_kaptura/features/permissions/domain/entities/permission_setting_entity.dart';
import 'package:flutter_kaptura/features/permissions/presentation/controllers/permission_settings_controller.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const role = 'role-token';

  PermissionSettingEntity permission({
    required String id,
    required String view,
    required String type,
    bool enabled = true,
    String allowedRole = role,
  }) {
    return PermissionSettingEntity(
      id: id,
      view: view,
      type: type,
      enabled: enabled,
      allowedRole: allowedRole,
    );
  }

  test('inventory requires active View and Read permissions for the role', () {
    final state = PermissionSettingsState(
      initialized: true,
      role: role,
      permissions: [
        permission(id: '1', view: 'inventories', type: 'View'),
        permission(id: '2', view: 'inventories', type: 'Read'),
      ],
    );

    expect(state.hasPermission(ProtectedModule.inventory, 'View'), isTrue);
    expect(state.canAccess(ProtectedModule.inventory), isTrue);
  });

  test('View keeps the tab visible but access is denied without Read', () {
    final state = PermissionSettingsState(
      initialized: true,
      role: role,
      permissions: [permission(id: '1', view: 'inventories', type: 'View')],
    );

    expect(state.hasPermission(ProtectedModule.inventory, 'View'), isTrue);
    expect(state.canAccess(ProtectedModule.inventory), isFalse);
  });

  test('Read without View hides the tab and denies access', () {
    final state = PermissionSettingsState(
      initialized: true,
      role: role,
      permissions: [permission(id: '1', view: 'inventories', type: 'Read')],
    );

    expect(state.hasPermission(ProtectedModule.inventory, 'View'), isFalse);
    expect(state.canAccess(ProtectedModule.inventory), isFalse);
  });

  test('no permissions hides the tab and denies access', () {
    const state = PermissionSettingsState(
      initialized: true,
      role: role,
      permissions: [],
    );

    expect(state.hasPermission(ProtectedModule.inventory, 'View'), isFalse);
    expect(state.canAccess(ProtectedModule.inventory), isFalse);
  });

  test('items permissions do not grant inventories access', () {
    final state = PermissionSettingsState(
      initialized: true,
      role: role,
      permissions: [
        permission(id: '1', view: 'items', type: 'View'),
        permission(id: '2', view: 'items', type: 'Read'),
      ],
    );

    expect(state.canAccess(ProtectedModule.inventory), isFalse);
  });

  test('access is denied for permissions assigned to another role', () {
    final state = PermissionSettingsState(
      initialized: true,
      role: role,
      permissions: [
        permission(
          id: '1',
          view: 'work_orders',
          type: 'View',
          allowedRole: 'other-role',
        ),
        permission(
          id: '2',
          view: 'work_orders',
          type: 'Read',
          allowedRole: 'other-role',
        ),
      ],
    );

    expect(state.canAccess(ProtectedModule.workOrders), isFalse);
  });

  test('disabled permissions do not grant access', () {
    final state = PermissionSettingsState(
      initialized: true,
      role: role,
      permissions: [
        permission(id: '1', view: 'inventories', type: 'View'),
        permission(id: '2', view: 'inventories', type: 'Read', enabled: false),
      ],
    );

    expect(state.canAccess(ProtectedModule.inventory), isFalse);
  });

  test('time reports use exact permissions and Update is independent', () {
    final state = PermissionSettingsState(
      initialized: true,
      role: role,
      permissions: [
        permission(id: '1', view: 'time_reports', type: 'View'),
        permission(id: '2', view: 'time_reports', type: 'Read'),
        permission(id: '3', view: 'time_reports', type: 'Update'),
      ],
    );

    expect(state.canAccess(ProtectedModule.timeReports), isTrue);
    expect(state.hasPermission(ProtectedModule.timeReports, 'Update'), isTrue);
  });
}
