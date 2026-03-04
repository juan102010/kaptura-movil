import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppScaffoldWithNav extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const AppScaffoldWithNav({super.key, required this.navigationShell});

  static const _bg = Color(0xFFF6F7FB);
  static const _brand = Color(0xFF0B2A4A);
  static const _softBlue = Color(0xFFE7EEF8);

  void _onTap(int index) {
    navigationShell.goBranch(
      index,
      // si vuelves a tocar el tab activo, vuelve al root de ese tab
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final current = navigationShell.currentIndex;

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

            // ✅ Evita splash/highlight raros que a veces se ven "rosados"
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
                  _navItem(
                    selected: current == 0,
                    label: 'Work Orders',
                    icon: Icons.assignment_outlined,
                    selectedIcon: Icons.assignment_rounded,
                  ),
                  _navItem(
                    selected: current == 1,
                    label: 'Home',
                    icon: Icons.home_outlined,
                    selectedIcon: Icons.home_rounded,
                  ),
                  _navItem(
                    selected: current == 2,
                    label: 'Settings',
                    icon: Icons.settings_outlined,
                    selectedIcon: Icons.settings_rounded,
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
    // Icono normal vs icono seleccionado (chip + dot)
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
          // ✅ Dot arriba (premium)
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

          // ✅ Chip del icono
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
