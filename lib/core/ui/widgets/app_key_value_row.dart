import 'package:flutter/material.dart';

class AppKeyValueRow extends StatelessWidget {
  const AppKeyValueRow({
    super.key,
    required this.label,
    required this.value,
    this.labelWidth = 140,
    this.selectable = false,
  });

  final String label;
  final String value;
  final double labelWidth;
  final bool selectable;

  @override
  Widget build(BuildContext context) {
    final displayValue = value.trim().isEmpty ? '-' : value;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: labelWidth,
            child: Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
          Expanded(
            child: selectable
                ? SelectableText(displayValue)
                : Text(displayValue),
          ),
        ],
      ),
    );
  }
}
