import 'dart:convert';

import 'package:flutter/material.dart';

import '../../../../core/ui/widgets/app_key_value_row.dart';
import '../../../../core/ui/widgets/app_section_card.dart';
import '../../domain/entities/user_list_entity.dart';

class UserDetailPage extends StatelessWidget {
  const UserDetailPage({super.key, required this.userId, this.user});

  final String userId;
  final UserListEntity? user;

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('User Detail')),
        body: Center(child: Text('No se encontro el usuario para id: $userId')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(user!.name)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AppSectionCard(
            title: 'Informacion principal',
            children: [
              AppKeyValueRow(label: '_id', value: user!.id),
              AppKeyValueRow(label: 'Nombre', value: user!.name),
              AppKeyValueRow(label: 'Email', value: user!.email),
              AppKeyValueRow(
                label: 'Identificacion',
                value: user!.identification,
              ),
              AppKeyValueRow(label: 'Role', value: user!.role),
              AppKeyValueRow(label: 'Status', value: user!.status),
              AppKeyValueRow(label: 'Scheme', value: user!.scheme),
              AppKeyValueRow(label: 'Company ID', value: user!.companyId),
              AppKeyValueRow(label: 'Cluster activo', value: user!.clusterKey),
              AppKeyValueRow(label: 'StateClock', value: user!.stateClock),
            ],
          ),
          const SizedBox(height: 12),
          AppSectionCard(
            title: 'Allowed Cluster Keys',
            children: [
              if (user!.allowedClusterKeys.isNotEmpty)
                ...user!.allowedClusterKeys.map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Text(item),
                  ),
                )
              else
                const Text('Sin datos'),
            ],
          ),
          const SizedBox(height: 12),
          AppSectionCard(
            title: 'Entry and Exit History',
            children: [
              if (user!.entryAndExitHistory.isNotEmpty)
                SelectableText(
                  const JsonEncoder.withIndent(
                    '  ',
                  ).convert(user!.entryAndExitHistory),
                  style: const TextStyle(fontFamily: 'monospace'),
                )
              else
                const Text('Sin datos'),
            ],
          ),
          const SizedBox(height: 12),
          AppSectionCard(
            title: 'JSON completo',
            children: [
              SelectableText(
                const JsonEncoder.withIndent('  ').convert(user!.rawData),
                style: const TextStyle(fontFamily: 'monospace'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
