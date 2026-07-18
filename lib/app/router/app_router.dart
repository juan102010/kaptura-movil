import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/localization/localization_extension.dart';

import '../../features/auth/presentation/controllers/auth_state.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/welcome_page.dart';
import '../../features/auth/presentation/providers/auth_providers.dart';
import '../../features/customers/domain/entities/customer_entity.dart';
import '../../features/customers/presentation/pages/customer_detail_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/inventory/domain/entities/inventory_item_entity.dart';
import '../../features/inventory/presentation/pages/inventory_detail_page.dart';
import '../../features/inventory/presentation/pages/inventory_page.dart';
import '../../features/inventory/presentation/pages/inventory_qr_scanner_page.dart';
import '../../features/projects/domain/entities/project_entity.dart';
import '../../features/permissions/presentation/controllers/permission_settings_controller.dart';
import '../../features/permissions/presentation/widgets/permission_gate.dart';
import '../../features/projects/presentation/pages/project_detail_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/time_reports/presentation/pages/time_reports_page.dart';
import '../../features/users/domain/entities/user_list_entity.dart';
import '../../features/users/presentation/pages/user_detail_page.dart';
import '../../features/work_orders/presentation/pages/work_order_details_page.dart';
import '../../features/work_orders/presentation/pages/work_orders_page.dart';
import 'widgets/app_scaffold_with_nav.dart';

class GoRouterRefreshNotifier extends ChangeNotifier {
  GoRouterRefreshNotifier(this._ref) {
    _sub = _ref.listen<AuthState>(
      authControllerProvider,
      (previous, next) => notifyListeners(),
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
  bool isAuthed(AuthState state) => state is AuthAuthenticated;

  return GoRouter(
    initialLocation: '/',
    refreshListenable: refreshNotifier,
    redirect: (context, state) {
      final authState = ref.read(authControllerProvider);
      final location = state.uri.toString();
      final onWelcome = location == '/';

      final inProtected =
          location.startsWith('/home') ||
          location.startsWith('/work-orders') ||
          location.startsWith('/settings') ||
          location.startsWith('/inventory') ||
          location.startsWith('/time-reports') ||
          location.startsWith('/customers') ||
          location.startsWith('/projects') ||
          location.startsWith('/users');

      final authed = isAuthed(authState);

      if (!authed && inProtected) {
        return '/login';
      }

      if (authed && onWelcome) {
        return '/home';
      }

      return null;
    },
    routes: [
      GoRoute(path: '/', builder: (context, state) => const WelcomePage()),
      GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
      GoRoute(
        path: '/customers/:id',
        builder: (context, state) {
          final customer = state.extra as CustomerEntity?;
          final customerId = state.pathParameters['id'] ?? '';
          return CustomerDetailPage(customerId: customerId, customer: customer);
        },
      ),
      GoRoute(
        path: '/projects/:id',
        builder: (context, state) {
          final project = state.extra as ProjectEntity?;
          final projectId = state.pathParameters['id'] ?? '';
          return ProjectDetailPage(projectId: projectId, project: project);
        },
      ),
      GoRoute(
        path: '/users/:id',
        builder: (context, state) {
          final user = state.extra as UserListEntity?;
          final userId = state.pathParameters['id'] ?? '';
          return UserDetailPage(userId: userId, user: user);
        },
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppScaffoldWithNav(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/work-orders',
                builder: (context, state) => PermissionGate(
                  module: ProtectedModule.workOrders,
                  title: context.l10n.workOrders,
                  child: const WorkOrdersPage(),
                ),
                routes: [
                  GoRoute(
                    path: ':id',
                    builder: (context, state) {
                      final id = state.pathParameters['id'] ?? '';
                      return PermissionGate(
                        module: ProtectedModule.workOrders,
                        title: context.l10n.workOrders,
                        child: WorkOrderDetailsPage(workOrderId: id),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                builder: (context, state) => const HomePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/inventory',
                builder: (context, state) => PermissionGate(
                  module: ProtectedModule.inventory,
                  title: context.l10n.inventory,
                  child: const InventoryPage(),
                ),
                routes: [
                  GoRoute(
                    path: 'scan',
                    builder: (context, state) => PermissionGate(
                      module: ProtectedModule.inventory,
                      title: context.l10n.inventory,
                      child: const InventoryQrScannerPage(),
                    ),
                  ),
                  GoRoute(
                    path: ':id',
                    builder: (context, state) {
                      final item = state.extra as InventoryItemEntity?;
                      final inventoryId = state.pathParameters['id'] ?? '';
                      return PermissionGate(
                        module: ProtectedModule.inventory,
                        title: context.l10n.inventory,
                        child: InventoryDetailPage(
                          inventoryId: inventoryId,
                          item: item,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/time-reports',
                builder: (context, state) => PermissionGate(
                  module: ProtectedModule.timeReports,
                  title: context.l10n.timeReports,
                  child: const TimeReportsPage(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/settings',
                builder: (context, state) => const SettingsPage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
