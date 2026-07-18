import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/di/providers.dart';
import '../../../home/presentation/providers/home_providers.dart';

Future<void> autosaveWorkOrderField({
  required WidgetRef ref,
  required String workOrderId,
  required String field,
  required dynamic oldValue,
  required dynamic newValue,
}) async {
  if (oldValue == newValue) return;
  await ref
      .read(updateDataByIdServiceProvider)
      .update(
        tableName: 'work_orders',
        id: workOrderId,
        data: {
          field: {'oldValue': oldValue, 'newValue': newValue},
        },
      );
  await ref.read(homeControllerProvider.notifier).applyWorkOrderPatch(
    workOrderId,
    {field: newValue},
  );
}

enum AutosaveFieldStatus { idle, saving, saved, error }

class WorkOrderAutosaveField extends StatefulWidget {
  const WorkOrderAutosaveField({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.onSave,
    this.maxLines = 1,
  });

  final IconData icon;
  final String label;
  final String value;
  final int maxLines;
  final Future<void> Function(String oldValue, String newValue) onSave;

  @override
  State<WorkOrderAutosaveField> createState() => _WorkOrderAutosaveFieldState();
}

class _WorkOrderAutosaveFieldState extends State<WorkOrderAutosaveField> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  late String _savedValue;
  AutosaveFieldStatus _status = AutosaveFieldStatus.idle;

  @override
  void initState() {
    super.initState();
    _savedValue = widget.value;
    _controller = TextEditingController(text: widget.value);
    _focusNode = FocusNode()..addListener(_handleFocusChange);
  }

  @override
  void didUpdateWidget(covariant WorkOrderAutosaveField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_focusNode.hasFocus && widget.value != _savedValue) {
      _savedValue = widget.value;
      _controller.text = widget.value;
    }
  }

  void _handleFocusChange() {
    if (!_focusNode.hasFocus) _save();
  }

  Future<void> _save() async {
    final next = _controller.text.trim();
    if (next == _savedValue || _status == AutosaveFieldStatus.saving) return;
    final previous = _savedValue;
    setState(() => _status = AutosaveFieldStatus.saving);
    try {
      await widget.onSave(previous, next);
      if (!mounted) return;
      _savedValue = next;
      setState(() => _status = AutosaveFieldStatus.saved);
    } catch (_) {
      if (!mounted) return;
      setState(() => _status = AutosaveFieldStatus.error);
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        maxLines: widget.maxLines,
        minLines: widget.maxLines > 1 ? 2 : 1,
        textInputAction: widget.maxLines > 1
            ? TextInputAction.newline
            : TextInputAction.done,
        onTapOutside: (_) => _focusNode.unfocus(),
        onSubmitted: widget.maxLines == 1 ? (_) => _focusNode.unfocus() : null,
        decoration: InputDecoration(
          labelText: widget.label,
          prefixIcon: Icon(widget.icon),
          suffixIcon: _statusIcon(),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 16,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(18)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide(color: Colors.black.withValues(alpha: 0.05)),
          ),
        ),
      ),
    );
  }

  Widget? _statusIcon() => switch (_status) {
    AutosaveFieldStatus.idle => null,
    AutosaveFieldStatus.saving => const Padding(
      padding: EdgeInsets.all(14),
      child: SizedBox.square(
        dimension: 16,
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    ),
    AutosaveFieldStatus.saved => const Icon(Icons.cloud_done_outlined),
    AutosaveFieldStatus.error => const Icon(
      Icons.error_outline,
      color: Colors.red,
    ),
  };
}
