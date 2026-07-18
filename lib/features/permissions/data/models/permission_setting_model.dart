import '../../domain/entities/permission_setting_entity.dart';

class PermissionSettingModel extends PermissionSettingEntity {
  const PermissionSettingModel({
    required super.id,
    required super.view,
    required super.type,
    required super.enabled,
    required super.allowedRole,
  });

  factory PermissionSettingModel.fromMap(Map<String, dynamic> map) {
    return PermissionSettingModel(
      id: (map['_id'] ?? map['id'] ?? '').toString().trim(),
      view: (map['vista permisos'] ?? '').toString().trim(),
      type: (map['tipo permiso'] ?? '').toString().trim(),
      enabled: _asBool(map['estado permiso']),
      allowedRole: (map['rol permitido'] ?? '').toString().trim(),
    );
  }

  Map<String, dynamic> toMap() => {
    '_id': id,
    'vista permisos': view,
    'tipo permiso': type,
    'estado permiso': enabled,
    'rol permitido': allowedRole,
  };

  static bool _asBool(dynamic value) {
    if (value is bool) return value;
    if (value is num) return value != 0;
    return value.toString().trim().toLowerCase() == 'true';
  }
}
