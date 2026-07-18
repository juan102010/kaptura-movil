import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/events/app_event.dart';
import '../core/constants/locale_constants.dart';
import '../l10n/generated/app_localizations.dart';
import 'di/providers.dart';
import 'localization/locale_controller.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';
import 'package:toastification/toastification.dart';
import '../features/auth/presentation/controllers/auth_state.dart';
import '../features/auth/presentation/providers/auth_providers.dart';
import '../features/permissions/presentation/providers/permission_settings_providers.dart';

class AppRoot extends ConsumerStatefulWidget {
  const AppRoot({super.key});

  @override
  ConsumerState<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends ConsumerState<AppRoot> {
  StreamSubscription<AppEvent>? _sub;

  @override
  void initState() {
    super.initState();

    final eventBus = ref.read(eventBusProvider);
    ref.read(pendingUpdateSyncServiceProvider);
    _sub = eventBus.stream.listen((event) {
      if (event == AppEvent.sessionExpired) {
        ref.read(appRouterProvider).go('/login');
      }
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    if (authState is AuthAuthenticated) {
      ref.watch(permissionSettingsControllerProvider);
    }
    final router = ref.watch(appRouterProvider);
    final locale = ref.watch(localeControllerProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      locale: locale,
      supportedLocales: LocaleConstants.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      theme: AppTheme.light(),
      builder: (context, child) {
        return ToastificationWrapper(child: child!);
      },
    );
  }
}
