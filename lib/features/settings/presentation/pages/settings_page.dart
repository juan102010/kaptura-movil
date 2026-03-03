import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/state/auth_controller.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  Future<bool> _confirmLogout() async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Confirmación'),
          content: const Text('¿Estás seguro de que deseas cerrar sesión?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: const Text('Cerrar sesión'),
            ),
          ],
        );
      },
    );

    return result ?? false;
  }

  /// Overlay profesional con fade + scale (sin “golpe”)
  void _showLoggingOutOverlay() {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: 'logging_out',
      // ✅ withOpacity deprecated -> withValues(alpha: ...)
      barrierColor: Colors.black.withValues(alpha: 0.35),
      transitionDuration: const Duration(milliseconds: 220),
      pageBuilder: (ctx, a1, a2) => const _LoggingOutOverlay(),
      transitionBuilder: (ctx, animation, secondaryAnimation, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        );

        return FadeTransition(
          opacity: curved,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.985, end: 1.0).animate(curved),
            child: child,
          ),
        );
      },
    );
  }

  void _hideOverlayIfAny() {
    if (!mounted) return;

    final nav = Navigator.of(context, rootNavigator: true);
    if (nav.canPop()) {
      nav.pop();
    }
  }

  Future<void> _handleLogoutPressed() async {
    final confirmed = await _confirmLogout();
    if (!mounted) return;
    if (!confirmed) return;

    _showLoggingOutOverlay();

    // Pequeña pausa para que el overlay se vea “pro” (no instantáneo)
    await Future.delayed(const Duration(milliseconds: 180));
    if (!mounted) return;

    // Ejecuta logout (esto dispara redirect a /login)
    await ref.read(authControllerProvider.notifier).logout();
    if (!mounted) return;

    // Por si el overlay sigue un instante, lo cerramos.
    // (si el router desmonta la pantalla, mounted será false y no intentamos usar context)
    _hideOverlayIfAny();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FilledButton.icon(
              icon: const Icon(Icons.logout_rounded),
              label: const Text('Cerrar sesión'),
              onPressed: _handleLogoutPressed,
            ),
          ],
        ),
      ),
    );
  }
}

class _LoggingOutOverlay extends StatelessWidget {
  const _LoggingOutOverlay();

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 320),
            child: Card(
              elevation: 12,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 18,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(strokeWidth: 2.6),
                    ),
                    SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        'Cerrando sesión…',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
