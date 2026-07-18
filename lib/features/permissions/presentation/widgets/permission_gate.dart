import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/localization/localization_extension.dart';
import '../controllers/permission_settings_controller.dart';
import '../providers/permission_settings_providers.dart';

class PermissionGate extends ConsumerWidget {
  const PermissionGate({
    super.key,
    required this.module,
    required this.title,
    required this.child,
  });

  final ProtectedModule module;
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(permissionSettingsControllerProvider);

    if (!state.initialized) {
      return Scaffold(
        backgroundColor: const Color(0xFFF6F7FB),
        appBar: AppBar(title: Text(title)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (!state.canAccess(module)) {
      return Scaffold(
        backgroundColor: const Color(0xFFF6F7FB),
        appBar: AppBar(title: Text(title)),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 84,
                  height: 84,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE7EEF8),
                    borderRadius: BorderRadius.circular(26),
                  ),
                  child: const Icon(
                    Icons.lock_outline_rounded,
                    size: 40,
                    color: Color(0xFF0B2A4A),
                  ),
                ),
                const SizedBox(height: 22),
                Text(
                  context.l10n.accessDenied,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFF0B2A4A),
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  context.l10n.modulePermissionRequired,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFF64748B),
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return child;
  }
}
