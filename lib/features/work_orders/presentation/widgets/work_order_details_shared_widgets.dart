import 'package:flutter/material.dart';

import '../../../../core/localization/localization_extension.dart';
import '../../../customers/domain/entities/customer_entity.dart';

class WorkOrderDetailsUiUtils {
  const WorkOrderDetailsUiUtils._();

  static String s(dynamic value) => (value ?? '').toString().trim();

  static String initialsFrom(String text) {
    final clean = text.trim();
    if (clean.isEmpty) return '?';

    final parts = clean
        .split(RegExp(r'\s+'))
        .where((e) => e.isNotEmpty)
        .toList();

    final first = parts.isNotEmpty ? parts[0][0] : '';
    final second = parts.length > 1 ? parts[1][0] : '';
    final out = (first + second).toUpperCase();

    return out.isEmpty ? '?' : out;
  }
}

class WorkOrderDetailsColors {
  const WorkOrderDetailsColors._();

  static const bg = Color(0xFFF6F7FB);
  static const brand = Color(0xFF0B2A4A);
  static const softBlue = Color(0xFFE7EEF8);
}

class WorkOrderHeader extends StatelessWidget {
  const WorkOrderHeader({
    super.key,
    required this.displayTitle,
    required this.workOrderId,
    required this.initials,
  });

  final String displayTitle;
  final String workOrderId;
  final String initials;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 120,
          decoration: const BoxDecoration(color: WorkOrderDetailsColors.brand),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            height: 46,
            decoration: const BoxDecoration(
              color: WorkOrderDetailsColors.bg,
              borderRadius: BorderRadius.vertical(
                top: Radius.elliptical(700, 120),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.18),
                  ),
                ),
                child: Center(
                  child: Text(
                    initials,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 16.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    InfoPill(
                      text: 'ID: $workOrderId',
                      bg: Colors.white.withValues(alpha: 0.14),
                      fg: Colors.white.withValues(alpha: 0.92),
                      border: Colors.white.withValues(alpha: 0.18),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.work_outline_rounded,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class WorkOrderTabBar extends StatelessWidget {
  const WorkOrderTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
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
      child: TabBar(
        isScrollable: true,
        indicator: BoxDecoration(
          color: WorkOrderDetailsColors.softBlue,
          borderRadius: BorderRadius.circular(14),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: WorkOrderDetailsColors.brand,
        unselectedLabelColor: WorkOrderDetailsColors.brand.withValues(
          alpha: 0.55,
        ),
        labelStyle: const TextStyle(fontWeight: FontWeight.w900),
        tabs: [
          Tab(text: context.l10n.general),
          Tab(text: context.l10n.location),
          Tab(text: context.l10n.notesCredentials),
          Tab(text: context.l10n.time),
          Tab(text: context.l10n.technician),
          Tab(text: context.l10n.parts),
          Tab(text: context.l10n.evidence),
        ],
      ),
    );
  }
}

class InfoPill extends StatelessWidget {
  const InfoPill({
    super.key,
    required this.text,
    required this.bg,
    required this.fg,
    required this.border,
  });

  final String text;
  final Color bg;
  final Color fg;
  final Color border;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: border),
      ),
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: fg, fontWeight: FontWeight.w800, fontSize: 12),
      ),
    );
  }
}

class WorkOrderSection extends StatelessWidget {
  const WorkOrderSection({
    super.key,
    required this.title,
    required this.children,
    this.showHeader = true,
  });

  final String title;
  final List<Widget> children;
  final bool showHeader;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 18),
      children: [
        if (showHeader) ...[
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: WorkOrderDetailsColors.softBlue,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.info_outline_rounded,
                  color: WorkOrderDetailsColors.brand,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                    color: WorkOrderDetailsColors.brand,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
        ],
        ...children,
      ],
    );
  }
}

class WorkOrderFieldRow extends StatelessWidget {
  const WorkOrderFieldRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.onTap,
    this.showChevron = false,
  });

  final IconData icon;
  final String label;
  final String value;
  final VoidCallback? onTap;
  final bool showChevron;

  @override
  Widget build(BuildContext context) {
    final trimmed = value.trim();
    final displayValue = trimmed.isEmpty ? '—' : trimmed;

    final content = Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
        boxShadow: [
          BoxShadow(
            blurRadius: 14,
            offset: const Offset(0, 8),
            color: Colors.black.withValues(alpha: 0.04),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: WorkOrderDetailsColors.softBlue,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: WorkOrderDetailsColors.brand, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    color: WorkOrderDetailsColors.brand,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  displayValue,
                  style: TextStyle(
                    color: WorkOrderDetailsColors.brand.withValues(alpha: 0.85),
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          if (showChevron) ...[
            const SizedBox(width: 10),
            Icon(
              Icons.chevron_right_rounded,
              color: WorkOrderDetailsColors.brand.withValues(alpha: 0.55),
            ),
          ],
        ],
      ),
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: onTap == null
          ? content
          : Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: onTap,
                child: content,
              ),
            ),
    );
  }
}

class WorkOrderActionButtonRow extends StatelessWidget {
  const WorkOrderActionButtonRow({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
              boxShadow: [
                BoxShadow(
                  blurRadius: 14,
                  offset: const Offset(0, 8),
                  color: Colors.black.withValues(alpha: 0.04),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: WorkOrderDetailsColors.softBlue,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    icon,
                    color: WorkOrderDetailsColors.brand,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    label,
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      color: WorkOrderDetailsColors.brand,
                      fontSize: 13,
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: WorkOrderDetailsColors.brand.withValues(alpha: 0.55),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ModalInfoRow extends StatelessWidget {
  const ModalInfoRow({super.key, required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: WorkOrderDetailsColors.bg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: WorkOrderDetailsColors.brand.withValues(alpha: 0.65),
                fontWeight: FontWeight.w800,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                color: WorkOrderDetailsColors.brand,
                fontWeight: FontWeight.w700,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryBadge extends StatelessWidget {
  const CategoryBadge({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: WorkOrderDetailsColors.softBlue,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: WorkOrderDetailsColors.brand,
          fontWeight: FontWeight.w900,
          fontSize: 12.5,
        ),
      ),
    );
  }
}

class DisplayRowData {
  const DisplayRowData({required this.label, required this.value});

  final String label;
  final String value;
}

class ResolvedCustomer {
  const ResolvedCustomer({required this.displayText, required this.customer});

  final String displayText;
  final CustomerEntity? customer;
}

class ServiceCategoryNote {
  const ServiceCategoryNote({
    required this.categoryName,
    required this.message,
    required this.images,
  });

  final String categoryName;
  final String message;
  final List<Map<String, dynamic>> images;
}
