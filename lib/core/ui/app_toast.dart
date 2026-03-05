import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class AppToast {
  static const _brand = Color(0xFF0B2A4A);
  static const _softBlue = Color(0xFFE7EEF8);

  static void success(BuildContext context, String message) {
    _show(context, message, Icons.check_rounded, const Color(0xFF2E7D32));
  }

  static void error(BuildContext context, String message) {
    _show(context, message, Icons.close_rounded, const Color(0xFFC62828));
  }

  static void info(BuildContext context, String message) {
    _show(context, message, Icons.info_outline_rounded, _brand);
  }

  static void _show(
    BuildContext context,
    String message,
    IconData icon,
    Color iconColor,
  ) {
    toastification.show(
      context: context,
      alignment: Alignment.topCenter,
      autoCloseDuration: const Duration(seconds: 3),
      showProgressBar: false,
      dragToClose: true,

      style: ToastificationStyle.flat,
      backgroundColor: Colors.white,

      borderRadius: BorderRadius.circular(16),

      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.12),
          blurRadius: 16,
          offset: const Offset(0, 8),
        ),
      ],

      icon: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: _softBlue,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: iconColor, size: 18),
      ),

      title: Text(
        message,
        style: const TextStyle(
          fontWeight: FontWeight.w700,
          color: _brand,
          fontSize: 14.5,
        ),
      ),
    );
  }
}
