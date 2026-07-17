import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../providers/home_providers.dart';
import '../controllers/home_state.dart';
import '../widgets/home_page_sections.dart';
import '../widgets/offline_banner_in_appbar.dart';
import '../widgets/work_orders_list_widget.dart';

import '../../domain/entities/clock_coords.dart';

import '../../../../app/di/providers.dart';
import '../../../../core/network/internet_status.dart';
import '../../../../core/services/location_service.dart';
import '../../../../core/localization/localization_extension.dart';

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

        final internetAsync = ref.read(homeInternetStatusProvider);
        final isOffline = internetAsync.when(
          data: (status) => status == InternetStatus.offline,
          loading: () => false,
          error: (error, stackTrace) => false,
        );

        await notifier.fetchUser();
        if (!mounted) return;

        await notifier.fetchLatestTimeReport();
        if (!mounted) return;

        await notifier.fetchMyWorkOrders(skipRemote: isOffline);
        if (!mounted) return;

        await _ensureLocationPermissionOnStart();
      });
    }
  }

  Future<void> _ensureLocationPermissionOnStart() async {
    final location = ref.read(locationServiceProvider);

    final state = await location.checkPermissionState();
    if (!mounted) return;

    if (state == LocationPermissionState.granted) return;

    if (state == LocationPermissionState.serviceOff) {
      final go = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(context.l10n.locationDisabled),
          content: Text(context.l10n.locationDisabledMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(context.l10n.notNow),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(context.l10n.openSettings),
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
        title: Text(context.l10n.permissionRequired),
        content: Text(context.l10n.locationPermissionMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(context.l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(context.l10n.openSettings),
          ),
        ],
      ),
    );
    if (!mounted) return;

    if (open == true) {
      await location.openAppSettings();
    }
  }

  Future<bool> _confirmClockOut() async {
    final res = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(context.l10n.confirmation),
        content: Text(context.l10n.clockOutConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(context.l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(context.l10n.yesClockOut),
          ),
        ],
      ),
    );

    return res == true;
  }

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
        title: Text(context.l10n.attention),
        content: Text(message),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(context.l10n.ok),
          ),
        ],
      ),
    );
  }

  String _mapClockType(String? type) {
    switch (type) {
      case 'clock_in':
        return context.l10n.lastClockIn;
      case 'clock_out':
        return context.l10n.lastClockOut;
      default:
        return context.l10n.lastRecord;
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(homeControllerProvider);
    final notifier = ref.read(homeControllerProvider.notifier);

    final isLoading = state.loadingUser;
    final isSaving = state.savingClock;

    final userName = state.user?.name ?? context.l10n.user;
    final stateClock = state.user?.stateClock ?? false;
    final latestTimeReport = state.latestTimeReport;
    final latestTimeReportLabel = latestTimeReport?.atDateTime == null
        ? (latestTimeReport?.atLocalLabel ?? '')
        : DateFormat.yMd(
            Localizations.localeOf(context).languageCode,
          ).add_jm().format(latestTimeReport!.atDateTime!.toLocal());

    final internetAsync = ref.watch(homeInternetStatusProvider);

    final isOffline = internetAsync.when(
      data: (status) => status == InternetStatus.offline,
      loading: () => false,
      error: (error, stackTrace) => false,
    );

    final buttonText = isOffline
        ? context.l10n.noInternet
        : (stateClock ? context.l10n.clockOut : context.l10n.clockIn);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF0B2A4A),
        title: const Text(
          'Kaptura',
          style: TextStyle(fontWeight: FontWeight.w800, color: Colors.white),
        ),
        centerTitle: false,
        bottom: isOffline
            ? const PreferredSize(
                preferredSize: Size.fromHeight(48),
                child: OfflineBannerInAppBar(),
              )
            : null,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          final offlineNow = ref
              .read(homeInternetStatusProvider)
              .when(
                data: (status) => status == InternetStatus.offline,
                loading: () => false,
                error: (error, stackTrace) => false,
              );

          await notifier.fetchUser();
          await notifier.fetchLatestTimeReport();
          await notifier.fetchMyWorkOrders(skipRemote: offlineNow);
        },
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          children: [
            HomePageHeader(userName: userName, isOffline: isOffline),
            const SizedBox(height: 14),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (state.status == HomeStatus.error &&
                      state.errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: HomePageErrorCard(
                        message: context.localizeError(state.errorMessage!),
                      ),
                    ),

                  HomePageSectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                color: const Color(0xFFE7EEF8),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.access_time_rounded,
                                color: Color(0xFF0B2A4A),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                stateClock
                                    ? context.l10n.activeWorkday
                                    : context.l10n.noActiveWorkday,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 16,
                                  color: Color(0xFF0B2A4A),
                                ),
                              ),
                            ),
                            if (isOffline)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFF0F0),
                                  borderRadius: BorderRadius.circular(999),
                                  border: Border.all(
                                    color: Colors.red.withValues(alpha: 0.20),
                                  ),
                                ),
                                child: Text(
                                  context.l10n.offline,
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                          ],
                        ),

                        if (latestTimeReport != null) ...[
                          const SizedBox(height: 12),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF6F7FB),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: Colors.black.withValues(alpha: 0.05),
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 34,
                                  height: 34,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE7EEF8),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(
                                    (latestTimeReport.type == 'clock_in')
                                        ? Icons.login_rounded
                                        : Icons.logout_rounded,
                                    size: 18,
                                    color: const Color(0xFF0B2A4A),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _mapClockType(latestTimeReport.type),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 13.5,
                                          color: Color(0xFF0B2A4A),
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        latestTimeReportLabel.isEmpty
                                            ? context.l10n.noTime
                                            : latestTimeReportLabel,
                                        style: TextStyle(
                                          color: const Color(
                                            0xFF0B2A4A,
                                          ).withValues(alpha: 0.70),
                                          fontSize: 12.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],

                        const SizedBox(height: 12),

                        SizedBox(
                          height: 52,
                          child: ElevatedButton(
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
                                      final already = await notifier
                                          .hasClockInToday();
                                      if (!mounted) return;

                                      if (already) {
                                        reason = await _askReason();
                                        if (!mounted) return;

                                        if (reason == null ||
                                            reason.trim().isEmpty) {
                                          return;
                                        }
                                      }
                                    }

                                    ClockCoords coords;
                                    try {
                                      final locationService = ref.read(
                                        locationServiceProvider,
                                      );
                                      coords = await locationService
                                          .getRequiredCoords();
                                    } catch (e) {
                                      if (!mounted) return;
                                      await _showWarning(
                                        e.toString().replaceFirst(
                                          'Exception: ',
                                          '',
                                        ),
                                      );
                                      return;
                                    }
                                    if (!mounted) return;

                                    try {
                                      await notifier.toggleClock(
                                        coords: coords,
                                        reason: reason,
                                      );
                                      if (!context.mounted) return;

                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            nextAction == 'clock_in'
                                                ? context.l10n.clockInRecorded
                                                : context.l10n.clockOutRecorded,
                                          ),
                                        ),
                                      );
                                    } catch (e) {
                                      if (!mounted) return;
                                      await _showWarning(
                                        e.toString().replaceFirst(
                                          'Exception: ',
                                          '',
                                        ),
                                      );
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0B2A4A),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: (isLoading || isSaving)
                                ? const SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        stateClock
                                            ? Icons.logout_rounded
                                            : Icons.login_rounded,
                                        size: 18,
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        buttonText,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 15.5,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),

                        const SizedBox(height: 8),
                        Text(
                          isOffline
                              ? context.l10n.connectForClock
                              : (stateClock
                                    ? context.l10n.rememberClockOut
                                    : context.l10n.clockInToStart),
                          style: TextStyle(
                            color: const Color(
                              0xFF0B2A4A,
                            ).withValues(alpha: 0.65),
                            fontSize: 12.5,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  Row(
                    children: [
                      Text(
                        context.l10n.todayWorkOrders,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF0B2A4A),
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.today_rounded,
                        size: 18,
                        color: const Color(0xFF0B2A4A).withValues(alpha: 0.55),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  const WorkOrdersListWidget(),

                  const SizedBox(height: 18),
                ],
              ),
            ),
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
      setState(() => _errorText = context.l10n.reasonRequiredValidation);
      return;
    }
    Navigator.of(context).pop(v);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(context.l10n.reasonRequired),
      content: TextField(
        controller: _controller,
        maxLines: 3,
        decoration: InputDecoration(
          hintText: context.l10n.additionalClockInReasonHint,
          errorText: _errorText,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(null),
          child: Text(context.l10n.cancel),
        ),
        ElevatedButton(onPressed: _confirm, child: Text(context.l10n.confirm)),
      ],
    );
  }
}
