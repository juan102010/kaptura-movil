import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/events/app_event.dart';
import 'di/providers.dart';
import 'router/app_router.dart';
import 'package:toastification/toastification.dart';

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
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      builder: (context, child) {
        return ToastificationWrapper(child: child!);
      },
    );
  }
}
