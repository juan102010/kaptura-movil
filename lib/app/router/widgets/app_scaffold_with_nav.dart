import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/localization/localization_extension.dart';
import '../../../features/permissions/presentation/controllers/permission_settings_controller.dart';
import '../../../features/permissions/presentation/providers/permission_settings_providers.dart';

class AppScaffoldWithNav extends ConsumerWidget {
  const AppScaffoldWithNav({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  static const _bg = Color(0xFFF6F7FB);

  void _onTap(int branchIndex) {
    navigationShell.goBranch(
      branchIndex,
      initialLocation: branchIndex == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final permissions = ref.watch(permissionSettingsControllerProvider);
    final current = navigationShell.currentIndex;
    final items = <_NavDestination>[
      if (permissions.hasPermission(ProtectedModule.workOrders, 'View'))
        _NavDestination(
          branchIndex: 0,
          label: context.l10n.workOrders,
          icon: Icons.assignment_outlined,
          selectedIcon: Icons.assignment_rounded,
        ),
      _NavDestination(
        branchIndex: 1,
        label: context.l10n.home,
        icon: Icons.home_outlined,
        selectedIcon: Icons.home_rounded,
      ),
      if (permissions.hasPermission(ProtectedModule.inventory, 'View'))
        _NavDestination(
          branchIndex: 2,
          label: context.l10n.inventory,
          icon: Icons.inventory_2_outlined,
          selectedIcon: Icons.inventory_2_rounded,
        ),
      if (permissions.hasPermission(ProtectedModule.timeReports, 'View'))
        _NavDestination(
          branchIndex: 3,
          label: context.l10n.timeReports,
          icon: Icons.timeline_outlined,
          selectedIcon: Icons.timeline_rounded,
        ),
      _NavDestination(
        branchIndex: 4,
        label: context.l10n.settings,
        icon: Icons.settings_outlined,
        selectedIcon: Icons.settings_rounded,
      ),
    ];

    return Scaffold(
      backgroundColor: _bg,
      body: navigationShell,
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
          child: Container(
            height: 76,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.10),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              children: items
                  .map(
                    (item) => Expanded(
                      child: _NavButton(
                        destination: item,
                        selected: current == item.branchIndex,
                        onTap: () => _onTap(item.branchIndex),
                      ),
                    ),
                  )
                  .toList(growable: false),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavDestination {
  const _NavDestination({
    required this.branchIndex,
    required this.label,
    required this.icon,
    required this.selectedIcon,
  });

  final int branchIndex;
  final String label;
  final IconData icon;
  final IconData selectedIcon;
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.destination,
    required this.selected,
    required this.onTap,
  });

  final _NavDestination destination;
  final bool selected;
  final VoidCallback onTap;

  static const _brand = Color(0xFF0B2A4A);

  @override
  Widget build(BuildContext context) {
    final color = selected ? _brand : _brand.withValues(alpha: 0.55);

    return Semantics(
      button: true,
      selected: selected,
      label: destination.label,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (selected)
              _SelectedNavIcon(icon: destination.selectedIcon)
            else
              SizedBox(
                height: 34,
                child: Center(child: Icon(destination.icon, color: color)),
              ),
            const SizedBox(height: 3),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Text(
                destination.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: color, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SelectedNavIcon extends StatelessWidget {
  const _SelectedNavIcon({required this.icon});

  final IconData icon;

  static const _brand = Color(0xFF0B2A4A);
  static const _softBlue = Color(0xFFE7EEF8);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 34,
      width: 56,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 0,
            child: Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: _brand,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 10,
                    color: _brand.withValues(alpha: 0.25),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                color: _softBlue,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.black.withValues(alpha: 0.04)),
              ),
              child: Icon(icon, color: _brand, size: 22),
            ),
          ),
        ],
      ),
    );
  }
}
