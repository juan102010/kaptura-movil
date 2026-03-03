import 'package:flutter/material.dart';

class OfflineBannerInAppBar extends StatefulWidget {
  const OfflineBannerInAppBar({super.key});

  @override
  State<OfflineBannerInAppBar> createState() => _OfflineBannerInAppBarState();
}

class _OfflineBannerInAppBarState extends State<OfflineBannerInAppBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;

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
    return Container(
      height: 44,
      width: double.infinity,
      color: Colors.orange.withValues(alpha: 0.12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: _pulse,
            builder: (_, __) {
              final t = _pulse.value;
              final scale = 0.9 + (t * 0.2);
              final alpha = 0.55 + (t * 0.45);

              return Transform.scale(
                scale: scale,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: alpha),
                    shape: BoxShape.circle,
                  ),
                ),
              );
            },
          ),
          const SizedBox(width: 10),
          const Text(
            'Sin conexión a internet',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
