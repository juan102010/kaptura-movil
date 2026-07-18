import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppDateFilterBar extends StatelessWidget {
  const AppDateFilterBar({
    super.key,
    required this.selectedDate,
    required this.onPrevious,
    required this.onNext,
    required this.onTapDate,
  });

  final DateTime selectedDate;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onTapDate;

  static const _brand = Color(0xFF0B2A4A);
  static const _bg = Color(0xFFF6F7FB);

  @override
  Widget build(BuildContext context) {
    final date = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
    );
    final text = DateFormat.yMMMMEEEEd(
      Localizations.localeOf(context).languageCode,
    ).format(date);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
        boxShadow: [
          BoxShadow(
            blurRadius: 16,
            offset: const Offset(0, 8),
            color: Colors.black.withValues(alpha: 0.05),
          ),
        ],
      ),
      child: Row(
        children: [
          _NavButton(icon: Icons.chevron_left_rounded, onTap: onPrevious),
          const SizedBox(width: 10),
          Expanded(
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: onTapDate,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: _bg,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.calendar_today_rounded,
                      size: 18,
                      color: _brand,
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        text,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          color: _brand,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          _NavButton(icon: Icons.chevron_right_rounded, onTap: onNext),
        ],
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFF6F7FB),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: SizedBox(
          width: 44,
          height: 44,
          child: Icon(icon, color: const Color(0xFF0B2A4A)),
        ),
      ),
    );
  }
}
