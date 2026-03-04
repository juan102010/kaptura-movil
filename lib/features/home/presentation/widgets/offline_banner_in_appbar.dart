import 'package:flutter/material.dart';

class OfflineBannerInAppBar extends StatefulWidget {
  const OfflineBannerInAppBar({super.key});

  @override
  State<OfflineBannerInAppBar> createState() => _OfflineBannerInAppBarState();
}

class _OfflineBannerInAppBarState extends State<OfflineBannerInAppBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;

  static const _brand = Color(0xFF0B2A4A); // mismo azul del AppBar
  static const _warn = Color(0xFFFFB020); // warning elegante

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Importante: este widget vive dentro del AppBar.bottom.
    // Por eso usamos un contenedor con padding y una "capsule" centrada.
    return Container(
      height: 48,
      width: double.infinity,
      color: _brand, // integra perfecto con AppBar oscuro
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Dot pulsante (se mantiene la lógica)
              AnimatedBuilder(
                animation: _pulse,
                builder: (_, __) {
                  final t = _pulse.value;
                  final scale = 0.85 + (t * 0.25);
                  final alpha = 0.55 + (t * 0.45);

                  return Transform.scale(
                    scale: scale,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _warn.withValues(alpha: alpha),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 10,
                            color: _warn.withValues(alpha: 0.22),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(width: 10),

              const Icon(Icons.wifi_off_rounded, size: 16, color: Colors.white),

              const SizedBox(width: 8),

              const Text(
                'Sin conexión a internet',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 12.5,
                  letterSpacing: 0.1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
