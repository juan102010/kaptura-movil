import 'dart:convert';

import 'package:flutter/material.dart';

class UserDetailPage extends StatelessWidget {
  final Map<String, dynamic> user;

  const UserDetailPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final name = _readString(user['name'], fallback: 'User detail');
    final email = _readString(user['email']);
    final identification = _readString(user['identification']);
    final role = _readString(user['role']);
    final scheme = _readString(user['scheme']);
    final companyId = _readString(user['company_id']);
    final clusterKey = _readString(user['clusterKey']);
    final stateClock = user['stateClock'];

    final allowedClusterKeys = user['allowedClusterKeys'];
    final entryAndExitHistory = user['entryAndExitHistory'];

    return Scaffold(
      appBar: AppBar(title: Text(name)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SectionCard(
            title: 'Información principal',
            children: [
              _InfoRow(label: '_id', value: _readString(user['_id'])),
              _InfoRow(label: 'Nombre', value: name),
              _InfoRow(label: 'Email', value: email),
              _InfoRow(label: 'Identificación', value: identification),
              _InfoRow(label: 'Role', value: role),
              _InfoRow(label: 'Status', value: _stringify(user['status'])),
              _InfoRow(label: 'Scheme', value: scheme),
              _InfoRow(label: 'Company ID', value: companyId),
              _InfoRow(label: 'Cluster activo', value: clusterKey),
              _InfoRow(label: 'StateClock', value: _stringify(stateClock)),
            ],
          ),
          const SizedBox(height: 12),
          _SectionCard(
            title: 'Allowed Cluster Keys',
            children: [
              if (allowedClusterKeys is List && allowedClusterKeys.isNotEmpty)
                ...allowedClusterKeys.map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Text(item.toString()),
                  ),
                )
              else
                const Text('Sin datos'),
            ],
          ),
          const SizedBox(height: 12),
          _SectionCard(
            title: 'Entry and Exit History',
            children: [
              if (entryAndExitHistory is List && entryAndExitHistory.isNotEmpty)
                SelectableText(
                  const JsonEncoder.withIndent(
                    '  ',
                  ).convert(entryAndExitHistory),
                  style: const TextStyle(fontFamily: 'monospace'),
                )
              else
                const Text('Sin datos'),
            ],
          ),
          const SizedBox(height: 12),
          _SectionCard(
            title: 'JSON completo',
            children: [
              SelectableText(
                const JsonEncoder.withIndent('  ').convert(user),
                style: const TextStyle(fontFamily: 'monospace'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static String _readString(dynamic value, {String fallback = '-'}) {
    if (value == null) return fallback;
    final text = value.toString().trim();
    if (text.isEmpty) return fallback;
    return text;
  }

  static String _stringify(dynamic value) {
    if (value == null) return '-';
    return value.toString();
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SectionCard({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(child: SelectableText(value)),
        ],
      ),
    );
  }
}
