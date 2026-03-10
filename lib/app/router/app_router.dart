import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/welcome_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/auth/presentation/state/auth_controller.dart';
import '../../features/auth/presentation/state/auth_state.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/work_orders/presentation/pages/work_order_details_page.dart';
import '../../features/work_orders/presentation/pages/work_orders_page.dart';

// ✅ IMPORTA el scaffold correcto (el PRO)
import 'widgets/app_scaffold_with_nav.dart';

// -------------------------------------------------------------
// 🧪 PRUEBA TEMPORAL: CUSTOMERS
// -------------------------------------------------------------
// Esta vista es SOLO PARA PRUEBAS de la nueva feature customers.
// Se eliminará cuando se integre correctamente al flujo final.
// -------------------------------------------------------------
import '../../features/customers/presentation/pages/customers_page.dart';

// -------------------------------------------------------------
// 🧪 PRUEBA TEMPORAL: PROJECTS
// -------------------------------------------------------------
// Esta vista es SOLO PARA PRUEBAS de la nueva feature projects.
// Se eliminará cuando se integre correctamente al flujo final.
// -------------------------------------------------------------
import '../../features/projects/presentation/pages/projects_page.dart';

/// ✅ refresca GoRouter cuando cambie auth state
class GoRouterRefreshNotifier extends ChangeNotifier {
  GoRouterRefreshNotifier(this._ref) {
    _sub = _ref.listen<AuthState>(
      authControllerProvider,
      (prev, next) => notifyListeners(),
    );
  }

  final Ref _ref;
  late final ProviderSubscription<AuthState> _sub;

  @override
  void dispose() {
    _sub.close();
    super.dispose();
  }
}

final appRouterProvider = Provider<GoRouter>((ref) {
  final refreshNotifier = GoRouterRefreshNotifier(ref);

  final authState = ref.watch(authControllerProvider);
  bool isAuthed(AuthState s) => s is AuthAuthenticated;

  return GoRouter(
    initialLocation: '/',
    refreshListenable: refreshNotifier,
    redirect: (context, state) {
      final location = state.uri.toString();

      final loggingIn = location == '/login';
      final onWelcome = location == '/';

      final inProtected =
          location.startsWith('/home') ||
          location.startsWith('/work-orders') ||
          location.startsWith('/settings') ||
          location.startsWith('/customers') || // 🧪 PRUEBA TEMPORAL
          location.startsWith('/projects'); // 🧪 PRUEBA TEMPORAL

      final authed = isAuthed(authState);

      // ✅ Si NO está autenticado y quiere entrar a protegido → /login
      if (!authed && inProtected) return '/login';

      // ✅ Si está autenticado y está en / o /login → /home
      if (authed && (loggingIn || onWelcome)) return '/home';

      return null;
    },
    routes: [
      // ----------------------------
      // Públicas
      // ----------------------------
      GoRoute(path: '/', builder: (context, state) => const WelcomePage()),

      GoRoute(
        path: '/login',
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: const LoginPage(),
            transitionDuration: const Duration(milliseconds: 420),
            reverseTransitionDuration: const Duration(milliseconds: 320),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  final fade = CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOutCubic,
                  );

                  final slide =
                      Tween<Offset>(
                        begin: const Offset(0, 0.06),
                        end: Offset.zero,
                      ).animate(
                        CurvedAnimation(
                          parent: animation,
                          curve: Curves.easeOutCubic,
                        ),
                      );

                  final scale = Tween<double>(begin: 0.985, end: 1.0).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOutCubic,
                    ),
                  );

                  return FadeTransition(
                    opacity: fade,
                    child: SlideTransition(
                      position: slide,
                      child: ScaleTransition(scale: scale, child: child),
                    ),
                  );
                },
          );
        },
      ),

      // ----------------------------
      // Shell (protegido por redirect)
      // ----------------------------
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppScaffoldWithNav(navigationShell: navigationShell);
        },
        branches: [
          // -------------------------------------------------------------
          // WORK ORDERS
          // -------------------------------------------------------------
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/work-orders',
                builder: (context, state) => const WorkOrdersPage(),
                routes: [
                  GoRoute(
                    path: ':id',
                    builder: (context, state) {
                      final id = state.pathParameters['id'] ?? '';
                      return WorkOrderDetailsPage(workOrderId: id);
                    },
                  ),
                ],
              ),
            ],
          ),

          // -------------------------------------------------------------
          // HOME
          // -------------------------------------------------------------
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                builder: (context, state) => const HomePage(),
              ),
            ],
          ),

          // -------------------------------------------------------------
          // SETTINGS
          // -------------------------------------------------------------
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/settings',
                builder: (context, state) => const SettingsPage(),
              ),
            ],
          ),

          // -------------------------------------------------------------
          // 🧪 CUSTOMERS (VISTA DE PRUEBA)
          // -------------------------------------------------------------
          // Esta sección es SOLO PARA TESTEAR:
          // - API customers
          // - cache SQLite
          // - lectura de campos anidados
          //
          // ⚠️ Esta ruta se eliminará cuando se integre
          // correctamente al módulo final.
          // -------------------------------------------------------------
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/customers',
                builder: (context, state) => const CustomersPage(),
              ),
            ],
          ),

          // -------------------------------------------------------------
          // 🧪 PROJECTS (VISTA DE PRUEBA)
          // -------------------------------------------------------------
          // Esta sección es SOLO PARA TESTEAR:
          // - API projects
          // - cache SQLite
          // - lectura de rawJson
          // - lectura de campos anidados como list_workOrder_id[0].name
          //
          // ⚠️ Esta ruta se eliminará cuando se integre
          // correctamente al módulo final.
          // -------------------------------------------------------------
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/projects',
                builder: (context, state) => const ProjectsPage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
