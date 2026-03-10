import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppScaffoldWithNav extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const AppScaffoldWithNav({super.key, required this.navigationShell});

  static const _bg = Color(0xFFF6F7FB);
  static const _brand = Color(0xFF0B2A4A);
  static const _softBlue = Color(0xFFE7EEF8);

  void _onTap(int index) {
    debugPrint(
      '[BottomNav] tap -> targetIndex: $index | currentIndex: ${navigationShell.currentIndex}',
    );

    navigationShell.goBranch(
      index,
      // si vuelves a tocar el tab activo, vuelve al root de ese tab
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final current = navigationShell.currentIndex;

    debugPrint('[BottomNav] build -> currentIndex: $current');

    return Scaffold(
      backgroundColor: _bg,

      // ✅ IMPORTANTE:
      // Con StatefulShellRoute.indexedStack NO animamos el body para evitar "flash".
      // El cambio de tab debe ser instantáneo y limpio (como apps reales).
      body: navigationShell,

      // ✅ Bottom bar flotante (pill) + chip seleccionado + dot arriba
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
            child: Theme(
              data: Theme.of(context).copyWith(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
              ),
              child: BottomNavigationBar(
                currentIndex: current,
                onTap: _onTap,
                type: BottomNavigationBarType.fixed,
                backgroundColor: Colors.transparent,
                elevation: 0,
                selectedFontSize: 12,
                unselectedFontSize: 12,
                selectedItemColor: _brand,
                unselectedItemColor: _brand.withValues(alpha: 0.55),
                showUnselectedLabels: true,
                items: [
                  // 0) Work Orders
                  _navItem(
                    selected: current == 0,
                    label: 'Work Orders',
                    icon: Icons.assignment_outlined,
                    selectedIcon: Icons.assignment_rounded,
                  ),

                  // 1) Home
                  _navItem(
                    selected: current == 1,
                    label: 'Home',
                    icon: Icons.home_outlined,
                    selectedIcon: Icons.home_rounded,
                  ),

                  // 2) Settings
                  _navItem(
                    selected: current == 2,
                    label: 'Settings',
                    icon: Icons.settings_outlined,
                    selectedIcon: Icons.settings_rounded,
                  ),

                  // 3) Customers
                  _navItem(
                    selected: current == 3,
                    label: 'Customers',
                    icon: Icons.people_outline,
                    selectedIcon: Icons.people_rounded,
                  ),

                  // 4) Projects
                  _navItem(
                    selected: current == 4,
                    label: 'Projects',
                    icon: Icons.folder_open_outlined,
                    selectedIcon: Icons.folder_rounded,
                  ),

                  // 5) Users
                  _navItem(
                    selected: current == 5,
                    label: 'Users',
                    icon: Icons.person_outline,
                    selectedIcon: Icons.person,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _navItem({
    required bool selected,
    required String label,
    required IconData icon,
    required IconData selectedIcon,
  }) {
    final widgetIcon = selected
        ? _SelectedNavIcon(
            icon: selectedIcon,
            brand: _brand,
            softBlue: _softBlue,
          )
        : Icon(icon);

    return BottomNavigationBarItem(icon: widgetIcon, label: label);
  }
}

class _SelectedNavIcon extends StatelessWidget {
  const _SelectedNavIcon({
    required this.icon,
    required this.brand,
    required this.softBlue,
  });

  final IconData icon;
  final Color brand;
  final Color softBlue;

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
                color: brand,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 10,
                    color: brand.withValues(alpha: 0.25),
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
                color: softBlue,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.black.withValues(alpha: 0.04)),
              ),
              child: Icon(icon, color: brand, size: 22),
            ),
          ),
        ],
      ),
    );
  }
}
