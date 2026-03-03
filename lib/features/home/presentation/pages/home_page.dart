import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/home_providers.dart';
import '../state/home_state.dart';
import '../widgets/work_orders_list_widget.dart';
import '../widgets/offline_banner_in_appbar.dart';

import '../../domain/entities/clock_coords.dart';

import '../../../../core/services/location_service.dart';
import '../../../../core/network/internet_status.dart';

import '../../../../app/di/providers.dart'; // locationServiceProvider

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  bool _didFetch = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_didFetch) {
      _didFetch = true;
      Future.microtask(() async {
        final notifier = ref.read(homeControllerProvider.notifier);

        // ✅ MÁS SEGURO: si aún no sabemos, asumimos OFFLINE
        final internetAsync = ref.read(homeInternetStatusProvider);
        final isOffline = internetAsync.when(
          data: (status) => status == InternetStatus.offline,
          loading: () => false,
          error: (_, __) => false,
        );

        await notifier.fetchUser();
        if (!mounted) return;

        // ✅ Work Orders: cache siempre, remoto solo si online confirmado
        await notifier.fetchMyWorkOrders(skipRemote: isOffline);
        if (!mounted) return;

        // ✅ Pedir permisos al iniciar (flujo pro)
        await _ensureLocationPermissionOnStart();
      });
    }
  }

  // ============================
  // Flujo PRO permisos al iniciar
  // ============================
  Future<void> _ensureLocationPermissionOnStart() async {
    final location = ref.read(locationServiceProvider);

    final state = await location.checkPermissionState();
    if (!mounted) return;

    if (state == LocationPermissionState.granted) return;

    if (state == LocationPermissionState.serviceOff) {
      final go = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Ubicación desactivada'),
          content: const Text(
            'Para registrar Clock In/Out necesitas activar la ubicación. '
            '¿Deseas abrir los ajustes de ubicación?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Ahora no'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Abrir ajustes'),
            ),
          ],
        ),
      );
      if (!mounted) return;

      if (go == true) {
        await location.openLocationSettings();
      }
      return;
    }

    if (state == LocationPermissionState.denied) {
      final res = await location.requestPermission();
      if (!mounted) return;

      if (res == LocationPermissionState.granted) return;
      if (res == LocationPermissionState.denied) return;
    }

    final open = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('Permiso requerido'),
        content: const Text(
          'El permiso de ubicación fue denegado permanentemente. '
          'Debes habilitarlo en Ajustes para poder registrar Clock In/Out.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Abrir Ajustes'),
          ),
        ],
      ),
    );
    if (!mounted) return;

    if (open == true) {
      await location.openAppSettings();
    }
  }

  // ============================
  // Dialog Confirm Clock Out
  // ============================
  Future<bool> _confirmClockOut() async {
    final res = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmación'),
        content: const Text('¿Deseas hacer Clock Out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Sí, Clock Out'),
          ),
        ],
      ),
    );

    return res == true;
  }

  // ============================
  // Dialog Reason obligatorio
  // ============================
  Future<String?> _askReason() async {
    return showDialog<String?>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const _ReasonDialog(),
    );
  }

  Future<void> _showWarning(String message) async {
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Atención'),
        content: Text(message),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(homeControllerProvider);
    final notifier = ref.read(homeControllerProvider.notifier);

    final isLoading = state.loadingUser;
    final isSaving = state.savingClock;

    final userName = state.user?.name ?? 'Usuario';
    final stateClock = state.user?.stateClock ?? false;

    // ✅ MÁS SEGURO: si aún no sabemos, asumimos OFFLINE
    final internetAsync = ref.watch(homeInternetStatusProvider);

    final isOffline = internetAsync.when(
      data: (status) => status == InternetStatus.offline,
      loading: () => false, // 👈 mientras carga, no bloqueamos
      error: (_, __) => false,
    );

    final buttonText = isOffline
        ? 'Sin internet'
        : (stateClock ? 'Clock Out' : 'Clock In');

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Kaptura',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        bottom: isOffline
            ? PreferredSize(
                preferredSize: const Size.fromHeight(48),
                child: const OfflineBannerInAppBar(),
              )
            : null,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // ✅ MÁS SEGURO: si aún no sabemos, asumimos OFFLINE
          final offlineNow = ref
              .read(homeInternetStatusProvider)
              .when(
                data: (status) => status == InternetStatus.offline,
                loading: () => false,
                error: (_, __) => false,
              );

          await notifier.fetchUser();
          await notifier.fetchMyWorkOrders(skipRemote: offlineNow);
        },
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              'Hola, $userName',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 24),

            if (state.status == HomeStatus.error && state.errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.red.withValues(alpha: 0.25),
                    ),
                  ),
                  child: Text(
                    state.errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                // ✅ OFFLINE: desactivado
                onPressed: (isLoading || isSaving || isOffline)
                    ? null
                    : () async {
                        final nextAction = stateClock
                            ? 'clock_out'
                            : 'clock_in';

                        if (nextAction == 'clock_out') {
                          final ok = await _confirmClockOut();
                          if (!mounted) return;
                          if (!ok) return;
                        }

                        String? reason;
                        if (nextAction == 'clock_in') {
                          final already = await notifier.hasClockInToday();
                          if (!mounted) return;

                          if (already) {
                            reason = await _askReason();
                            if (!mounted) return;

                            if (reason == null || reason.trim().isEmpty) {
                              return;
                            }
                          }
                        }

                        ClockCoords coords;
                        try {
                          final locationService = ref.read(
                            locationServiceProvider,
                          );

                          coords = await locationService.getRequiredCoords();
                        } catch (e) {
                          if (!mounted) return;

                          await _showWarning(
                            e.toString().replaceFirst('Exception: ', ''),
                          );
                          return;
                        }
                        if (!mounted) return;

                        try {
                          await notifier.toggleClock(
                            coords: coords,
                            reason: reason,
                          );
                          if (!mounted) return;

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                nextAction == 'clock_in'
                                    ? 'Clock In registrado'
                                    : 'Clock Out registrado',
                              ),
                            ),
                          );
                        } catch (e) {
                          if (!mounted) return;

                          await _showWarning(
                            e.toString().replaceFirst('Exception: ', ''),
                          );
                        }
                      },
                child: (isLoading || isSaving)
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(buttonText),
              ),
            ),

            const SizedBox(height: 16),

            Divider(
              height: 24,
              thickness: 1,
              color: Colors.grey.withValues(alpha: 0.25),
            ),

            const SizedBox(height: 8),

            const WorkOrdersListWidget(),
          ],
        ),
      ),
    );
  }
}

class _ReasonDialog extends StatefulWidget {
  const _ReasonDialog();

  @override
  State<_ReasonDialog> createState() => _ReasonDialogState();
}

class _ReasonDialogState extends State<_ReasonDialog> {
  final TextEditingController _controller = TextEditingController();
  String? _errorText;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _confirm() {
    final v = _controller.text.trim();
    if (v.isEmpty) {
      setState(() => _errorText = 'La razón es obligatoria.');
      return;
    }
    Navigator.of(context).pop(v);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Razón requerida'),
      content: TextField(
        controller: _controller,
        maxLines: 3,
        decoration: InputDecoration(
          hintText: 'Escribe la razón del Clock In adicional',
          errorText: _errorText,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(null),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(onPressed: _confirm, child: const Text('Confirmar')),
      ],
    );
  }
}
