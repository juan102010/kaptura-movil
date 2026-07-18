class PermissionSettingEntity {
  const PermissionSettingEntity({
    required this.id,
    required this.view,
    required this.type,
    required this.enabled,
    required this.allowedRole,
  });

  final String id;
  final String view;
  final String type;
  final bool enabled;
  final String allowedRole;
}
