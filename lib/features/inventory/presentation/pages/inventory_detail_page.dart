import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/localization/localization_extension.dart';
import '../../../../core/ui/widgets/app_section_card.dart';
import '../../domain/entities/inventory_item_entity.dart';
import '../providers/inventory_providers.dart';

class InventoryDetailPage extends ConsumerStatefulWidget {
  const InventoryDetailPage({super.key, required this.inventoryId, this.item});

  final String inventoryId;
  final InventoryItemEntity? item;

  @override
  ConsumerState<InventoryDetailPage> createState() =>
      _InventoryDetailPageState();
}

class _InventoryDetailPageState extends ConsumerState<InventoryDetailPage> {
  late final TextEditingController _defaultQtyCtrl;
  late final TextEditingController _stockMinCtrl;

  @override
  void initState() {
    super.initState();
    final item = widget.item;
    _defaultQtyCtrl = TextEditingController(
      text: item?.defaultQty.toString() ?? '0',
    );
    _stockMinCtrl = TextEditingController(
      text: item?.stockMin.toString() ?? '0',
    );
  }

  @override
  void dispose() {
    _defaultQtyCtrl.dispose();
    _stockMinCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(inventoryControllerProvider);
    final controller = ref.read(inventoryControllerProvider.notifier);
    final item =
        widget.item ??
        controller.findById(widget.inventoryId) ??
        state.selectedItem;

    if (item == null) {
      return Scaffold(
        appBar: AppBar(title: Text(context.l10n.inventoryDetail)),
        body: Center(child: Text(context.l10n.requestedItemNotFound)),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        title: Text(context.l10n.inventoryDetail),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: state.saving
                ? null
                : () async {
                    await controller.refreshRemoteOnly();
                    final refreshed = controller.findById(item.id);
                    if (refreshed == null) return;
                    _defaultQtyCtrl.text = refreshed.defaultQty.toString();
                    _stockMinCtrl.text = refreshed.stockMin.toString();
                  },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AppSectionCard(
            title: '',
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F0FA),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Icon(
                      Icons.inventory_2_rounded,
                      color: Color(0xFF0B2A4A),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.itemName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF0B2A4A),
                          ),
                        ),
                        const SizedBox(height: 6),
                        _StatusBadge(isActive: item.isActive),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          AppSectionCard(
            title: context.l10n.stockAdjustment,
            children: [
              _QuantityAdjuster(
                label: context.l10n.defaultQuantity,
                helperText: context.l10n.defaultQuantityHelp,
                controller: _defaultQtyCtrl,
                icon: Icons.inventory_rounded,
              ),
              const SizedBox(height: 14),
              _QuantityAdjuster(
                label: context.l10n.minimumStock,
                helperText: context.l10n.minimumStockHelp,
                controller: _stockMinCtrl,
                icon: Icons.notification_important_rounded,
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: state.saving
                      ? null
                      : () => _save(context: context, item: item),
                  icon: state.saving
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.save_rounded),
                  label: Text(
                    state.saving
                        ? context.l10n.saving
                        : context.l10n.saveChanges,
                  ),
                ),
              ),
              if (state.error != null && state.error!.trim().isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  context.localizeError(state.error!),
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _save({
    required BuildContext context,
    required InventoryItemEntity item,
  }) async {
    final defaultQty = int.tryParse(_defaultQtyCtrl.text.trim());
    final stockMin = int.tryParse(_stockMinCtrl.text.trim());

    if (defaultQty == null || stockMin == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.invalidNumericValues)),
      );
      return;
    }

    try {
      final updated = await ref
          .read(inventoryControllerProvider.notifier)
          .updateSelectedItemQuantities(
            item: item,
            newDefaultQty: defaultQty,
            newStockMin: stockMin,
          );

      if (!context.mounted) return;
      _defaultQtyCtrl.text = updated.defaultQty.toString();
      _stockMinCtrl.text = updated.stockMin.toString();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.l10n.inventoryUpdated)));
    } catch (_) {}
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.isActive});

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final color = isActive ? const Color(0xFF16835B) : const Color(0xFFB54747);
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          isActive ? context.l10n.active : context.l10n.inactive,
          style: TextStyle(
            color: color,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _QuantityAdjuster extends StatefulWidget {
  const _QuantityAdjuster({
    required this.label,
    required this.helperText,
    required this.controller,
    required this.icon,
  });

  final String label;
  final String helperText;
  final TextEditingController controller;
  final IconData icon;

  @override
  State<_QuantityAdjuster> createState() => _QuantityAdjusterState();
}

class _QuantityAdjusterState extends State<_QuantityAdjuster> {
  static const int _maxValue = 999999;
  late final FixedExtentScrollController _wheelController;
  bool _updatingFromWheel = false;

  int get _value =>
      (int.tryParse(widget.controller.text) ?? 0).clamp(0, _maxValue);

  @override
  void initState() {
    super.initState();
    _wheelController = FixedExtentScrollController(initialItem: _value);
    widget.controller.addListener(_syncWheelWithText);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_syncWheelWithText);
    _wheelController.dispose();
    super.dispose();
  }

  void _syncWheelWithText() {
    if (_updatingFromWheel || !_wheelController.hasClients) return;
    final value = _value;
    if (_wheelController.selectedItem == value) return;
    _wheelController.jumpToItem(value);
  }

  void _onSelectedItemChanged(int value) {
    _updatingFromWheel = true;
    widget.controller.text = value.toString();
    _updatingFromWheel = false;
  }

  Future<void> _openManualInput() async {
    final value = await showDialog<int>(
      context: context,
      builder: (_) => _ManualQuantityDialog(
        title: widget.label,
        initialValue: _value,
        maxValue: _maxValue,
        cancelLabel: context.l10n.cancel,
        acceptLabel: context.l10n.accept,
      ),
    );

    if (value == null || !mounted) return;
    widget.controller.text = value.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F9FC),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE4E9F1)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(widget.icon, size: 21, color: const Color(0xFF315E8C)),
              const SizedBox(width: 9),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.label,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF163A5F),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.helperText,
                      style: const TextStyle(
                        color: Color(0xFF748399),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: _openManualInput,
            child: Container(
              height: 112,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CupertinoPicker.builder(
                    scrollController: _wheelController,
                    itemExtent: 42,
                    diameterRatio: 1.35,
                    squeeze: 1.05,
                    useMagnifier: true,
                    magnification: 1.12,
                    selectionOverlay: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 18),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEAF1F8).withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    childCount: _maxValue + 1,
                    onSelectedItemChanged: _onSelectedItemChanged,
                    itemBuilder: (context, index) => Center(
                      child: Text(
                        '$index',
                        style: const TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF0B2A4A),
                        ),
                      ),
                    ),
                  ),
                  const Positioned(
                    right: 13,
                    child: Icon(
                      Icons.edit_rounded,
                      size: 17,
                      color: Color(0xFF71839A),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ManualQuantityDialog extends StatefulWidget {
  const _ManualQuantityDialog({
    required this.title,
    required this.initialValue,
    required this.maxValue,
    required this.cancelLabel,
    required this.acceptLabel,
  });

  final String title;
  final int initialValue;
  final int maxValue;
  final String cancelLabel;
  final String acceptLabel;

  @override
  State<_ManualQuantityDialog> createState() => _ManualQuantityDialogState();
}

class _ManualQuantityDialogState extends State<_ManualQuantityDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue.toString());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final value = int.tryParse(_controller.text);
    if (value == null) return;
    Navigator.of(context).pop(value.clamp(0, widget.maxValue));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: TextField(
        controller: _controller,
        autofocus: true,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
        decoration: const InputDecoration(border: OutlineInputBorder()),
        onSubmitted: (_) => _submit(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(widget.cancelLabel),
        ),
        FilledButton(onPressed: _submit, child: Text(widget.acceptLabel)),
      ],
    );
  }
}
