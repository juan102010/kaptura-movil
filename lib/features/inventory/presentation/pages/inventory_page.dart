import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/localization/localization_extension.dart';
import '../../domain/entities/inventory_item_entity.dart';
import '../controllers/inventory_controller.dart';
import '../providers/inventory_providers.dart';
import '../widgets/inventory_page_sections.dart';

class InventoryPage extends ConsumerStatefulWidget {
  const InventoryPage({super.key});

  @override
  ConsumerState<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends ConsumerState<InventoryPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(inventoryControllerProvider.notifier).loadCacheThenRemote();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(inventoryControllerProvider);
    final controller = ref.read(inventoryControllerProvider.notifier);
    final activeItems = state.items.where((item) => item.isActive).length;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        title: Text(context.l10n.inventory),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => controller.refreshRemoteOnly(),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: controller.refreshRemoteOnly,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            InventoryHeroCard(
              totalItems: state.items.length,
              activeItems: activeItems,
            ),
            const SizedBox(height: 14),
            InventoryActionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    context.l10n.selectOrScanInventory,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF0B2A4A),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    context.l10n.inventoryInstructions,
                    style: TextStyle(
                      height: 1.35,
                      color: const Color(0xFF0B2A4A).withValues(alpha: 0.70),
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    key: ValueKey(_selectedValue(state) ?? 'inventory-empty'),
                    initialValue: _selectedValue(state),
                    isExpanded: true,
                    items: state.items
                        .map(
                          (item) => DropdownMenuItem<String>(
                            value: item.id,
                            child: Text(
                              item.itemName.isEmpty ? item.id : item.itemName,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        )
                        .toList(),
                    selectedItemBuilder: (context) {
                      return state.items.map((item) {
                        return Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            item.itemName.isEmpty ? item.id : item.itemName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList();
                    },
                    onChanged: state.loading
                        ? null
                        : (value) => _openSelectedItem(
                            context: context,
                            controller: controller,
                            id: value,
                          ),
                    decoration: InputDecoration(
                      labelText: context.l10n.inventoryItem,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Align(
                    alignment: Alignment.center,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(24),
                      onTap: state.loading ? null : () => _scanQr(context),
                      child: Container(
                        width: 88,
                        height: 88,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE7EEF8),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: const Icon(
                          Icons.qr_code_scanner_rounded,
                          size: 38,
                          color: Color(0xFF0B2A4A),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    context.l10n.openCamera,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0B2A4A),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            if (state.loading && state.items.isEmpty)
              const SizedBox(
                height: 220,
                child: Center(child: CircularProgressIndicator()),
              )
            else if (state.error != null && state.items.isEmpty)
              _InventoryMessageCard(
                icon: Icons.error_outline_rounded,
                title: context.l10n.inventoryLoadError,
                message: context.localizeError(state.error!),
              )
            else if (state.items.isEmpty)
              _InventoryMessageCard(
                icon: Icons.inventory_2_outlined,
                title: context.l10n.noItems,
                message: context.l10n.noInventoryAvailable,
              )
            else
              InventoryActionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            context.l10n.quickView,
                            style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 16,
                              color: Color(0xFF0B2A4A),
                            ),
                          ),
                        ),
                        if (state.fromCache)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE7EEF8),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              context.l10n.cache,
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF0B2A4A),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ...state.items
                        .take(6)
                        .map(
                          (item) => _InventoryPreviewTile(
                            item: item,
                            onTap: () => _openSelectedItem(
                              context: context,
                              controller: controller,
                              id: item.id,
                            ),
                          ),
                        ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  String? _selectedValue(InventoryState state) {
    final item = state.selectedItem;
    if (item == null) return null;
    final exists = state.items.any((current) => current.matchesId(item.id));
    return exists ? item.id : null;
  }

  Future<void> _scanQr(BuildContext context) async {
    final result = await context.push<String>('/inventory/scan');
    if (!context.mounted || result == null || result.trim().isEmpty) return;

    _openSelectedItem(
      context: context,
      controller: ref.read(inventoryControllerProvider.notifier),
      id: result,
      sourceLabel: 'QR',
    );
  }

  void _openSelectedItem({
    required BuildContext context,
    required InventoryController controller,
    required String? id,
    String sourceLabel = 'selector',
  }) {
    final cleanId = (id ?? '').trim();
    if (cleanId.isEmpty) return;

    final item = controller.findById(cleanId);
    if (item == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.inventoryItemNotFound(sourceLabel)),
        ),
      );
      return;
    }

    controller.selectItemById(item.id);
    context.push('/inventory/${item.id}', extra: item);
  }
}

class _InventoryPreviewTile extends StatelessWidget {
  const _InventoryPreviewTile({required this.item, required this.onTap});

  final InventoryItemEntity item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: item.isActive
                      ? const Color(0xFFE7F7EE)
                      : const Color(0xFFFFF1F1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  item.isActive ? Icons.check_rounded : Icons.block_rounded,
                  color: item.isActive ? Colors.green : Colors.red,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.itemName.isEmpty ? item.id : item.itemName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0B2A4A),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      context.l10n.inventoryQuantities(
                        item.defaultQty,
                        item.stockMin,
                      ),
                      style: TextStyle(
                        color: const Color(0xFF0B2A4A).withValues(alpha: 0.68),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              const Icon(Icons.chevron_right_rounded),
            ],
          ),
        ),
      ),
    );
  }
}

class _InventoryMessageCard extends StatelessWidget {
  const _InventoryMessageCard({
    required this.icon,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return InventoryActionCard(
      child: Column(
        children: [
          Icon(icon, size: 36, color: const Color(0xFF0B2A4A)),
          const SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 16,
              color: Color(0xFF0B2A4A),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              height: 1.35,
              color: const Color(0xFF0B2A4A).withValues(alpha: 0.70),
            ),
          ),
        ],
      ),
    );
  }
}
