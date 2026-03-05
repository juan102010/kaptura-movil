import 'package:flutter/material.dart';

class CustomerDetailPage extends StatelessWidget {
  const CustomerDetailPage({super.key, required this.customer});

  final Map<String, dynamic> customer;

  @override
  Widget build(BuildContext context) {
    final id = (customer['_id'] ?? '').toString();
    final type = (customer['rad_clientType_id'] ?? '').toString();

    final email = (customer['text_mainEmail_id'] ?? '').toString();
    final phone = (customer['text_mainPhone_id'] ?? '').toString();
    final mobile = (customer['text_mobile_id'] ?? '').toString();

    final city = _firstStringFromList(customer['text_city_id']);
    final state = _firstStringFromList(customer['text_state_id']);
    final country = _firstStringFromList(customer['text_country_id']);
    final street = _firstStringFromList(customer['text_street_id']);

    // ✅ ANIDADO PROFUNDO (Camaras[0])
    final cameraMessage = _readNestedString(customer, [
      'obj_categoriesOfServices_id',
      'Camaras',
      0,
      'message',
    ]);

    final firstCameraImageUrl = _readNestedString(customer, [
      'obj_categoriesOfServices_id',
      'Camaras',
      0,
      'images',
      0,
      'url',
    ]);

    return Scaffold(
      appBar: AppBar(title: const Text('Customer Detail')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _kv('ID', id),
          _kv('Tipo', type),
          const Divider(),

          _kv('Email', email),
          _kv('Phone', phone),
          _kv('Mobile', mobile),
          const Divider(),

          _kv('City', city ?? ''),
          _kv('State', state ?? ''),
          _kv('Country', country ?? ''),
          _kv('Street', street ?? ''),
          const Divider(),

          // ✅ NUEVO: mostrar message + image url (si existe)
          _kv('Camera Message (nested)', cameraMessage ?? ''),
          _kv('First camera image URL (nested)', firstCameraImageUrl ?? ''),
          const SizedBox(height: 12),

          Text(
            'Tip: este detalle viene del Map decodificado desde rawJson.\n'
            'Si está offline, sigue funcionando porque sale de SQLite.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _kv(String k, String v) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 160,
            child: Text(k, style: const TextStyle(fontWeight: FontWeight.w700)),
          ),
          Expanded(child: Text(v.isEmpty ? '-' : v)),
        ],
      ),
    );
  }

  String? _firstStringFromList(dynamic value) {
    if (value is List && value.isNotEmpty) {
      final v = value.first?.toString().trim();
      if (v != null && v.isNotEmpty) return v;
    }
    return null;
  }

  /// Lee seguro un string de un Map anidado.
  /// path soporta keys (String) y indexes (int) para listas.
  String? _readNestedString(Map<String, dynamic> root, List<dynamic> path) {
    dynamic current = root;

    for (final step in path) {
      if (step is String) {
        if (current is Map) {
          current = current[step];
        } else {
          return null;
        }
      } else if (step is int) {
        if (current is List && current.length > step) {
          current = current[step];
        } else {
          return null;
        }
      } else {
        return null;
      }

      if (current == null) return null;
    }

    final s = current.toString().trim();
    return s.isEmpty ? null : s;
  }
}
