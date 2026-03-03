import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  static const Color _bgTop = Color(0xFF001D39);
  static const Color _bgBottom = Color(0xFF0A4174);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [_bgTop, _bgBottom],
          ),
        ),
        child: Stack(
          children: [
            // 🖼️ Imagen superior
            Positioned(
              top: size.height * 0.12,
              left: 0,
              right: 0,
              child: Center(
                child: Image.asset(
                  'assets/images/logo_black.png',
                  width: size.width * 0.65,
                  fit: BoxFit.contain,
                ),
              ),
            ),

            // “ola” blanca inferior
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: size.height * 0.52,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFFF7FAFF),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.elliptical(900, 260),
                    topRight: Radius.elliptical(900, 260),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 40, 24, 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Welcome',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1B2633),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Inicia sesión para continuar.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade700,
                          height: 1.4,
                        ),
                      ),
                      const Spacer(),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(28),
                          onTap: () => context.go('/login'),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF7BBDE8),
                              borderRadius: BorderRadius.circular(28),
                              boxShadow: const [
                                BoxShadow(
                                  blurRadius: 18,
                                  offset: Offset(0, 10),
                                  color: Color(0x33000000),
                                ),
                              ],
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Continue',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Icon(Icons.arrow_forward, color: Colors.white),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
