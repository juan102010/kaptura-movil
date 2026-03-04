import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppScaffoldWithNav extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const AppScaffoldWithNav({super.key, required this.navigationShell});

  @override
  State<AppScaffoldWithNav> createState() => _AppScaffoldWithNavState();
}

class _AppScaffoldWithNavState extends State<AppScaffoldWithNav>
    with SingleTickerProviderStateMixin {
  static const _bg = Color(0xFFF6F7FB);
  static const _brand = Color(0xFF0B2A4A);
  static const _softBlue = Color(0xFFE7EEF8);

  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  int _lastIndex = 0;

  @override
  void initState() {
    super.initState();
    _lastIndex = widget.navigationShell.currentIndex;

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 240),
      reverseDuration: const Duration(milliseconds: 180),
    );

    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);

    _slide = Tween<Offset>(
      begin: const Offset(0.015, 0.0), // slide MUY sutil
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    // Primera entrada suave
    _controller.forward(from: 0);
  }

  @override
  void didUpdateWidget(covariant AppScaffoldWithNav oldWidget) {
    super.didUpdateWidget(oldWidget);

    final newIndex = widget.navigationShell.currentIndex;
    if (newIndex != _lastIndex) {
      _lastIndex = newIndex;

      // ✅ Reproduce animación sin recrear navigationShell (sin GlobalKey duplicada)
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTap(int index) {
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final current = widget.navigationShell.currentIndex;

    return Scaffold(
      backgroundColor: _bg,

      // ✅ Animación suave para el contenido (sin AnimatedSwitcher)
      body: FadeTransition(
        opacity: _fade,
        child: SlideTransition(position: _slide, child: widget.navigationShell),
      ),

      // ✅ Bottom bar flotante (pill) + chip seleccionado + dot
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
              // ✅ opcional: elimina “splash” raro de algunos temas (a veces se ve rosado)
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
