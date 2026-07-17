import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/di/providers.dart';
import '../../../../core/localization/localization_extension.dart';
import '../../../customers/domain/entities/customer_entity.dart';
import '../widgets/work_order_details_shared_widgets.dart';

class CustomerBottomSheetHelpers {
  const CustomerBottomSheetHelpers._();

  static void showCustomerBottomSheet({
    required BuildContext context,
    required WidgetRef ref,
    required CustomerEntity customer,
    required String title,
    required List<DisplayRowData> rows,
    required List<ServiceCategoryNote> notes,
  }) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SafeArea(
            top: false,
            child: DraggableScrollableSheet(
              expand: false,
              initialChildSize: 0.72,
              minChildSize: 0.45,
              maxChildSize: 0.92,
              builder: (context, scrollController) {
                return Column(
                  children: [
                    const SizedBox(height: 10),
                    Container(
                      width: 48,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
                      child: Row(
                        children: [
                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: WorkOrderDetailsColors.softBlue,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(
                              Icons.business_rounded,
                              color: WorkOrderDetailsColors.brand,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              title.isEmpty ? context.l10n.customer : title,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w900,
                                color: WorkOrderDetailsColors.brand,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1),
                    Expanded(
                      child: ListView(
                        controller: scrollController,
                        padding: const EdgeInsets.all(16),
                        children: [
                          if (rows.isEmpty)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 24),
                              child: Center(
                                child: Text(context.l10n.noCustomerInformation),
                              ),
                            )
                          else
                            ...rows.map(
                              (row) => ModalInfoRow(
                                label: row.label,
                                value: row.value,
                              ),
                            ),
                          if (rows.isNotEmpty) const SizedBox(height: 4),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  static void showCredentialsBottomSheet({
    required BuildContext context,
    required String title,
    required List<ServiceCategoryNote> notes,
  }) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return CredentialsNotesSheet(title: title, notes: notes);
      },
    );
  }
}

class CredentialsNotesSheet extends ConsumerStatefulWidget {
  const CredentialsNotesSheet({
    super.key,
    required this.title,
    required this.notes,
  });

  final String title;
  final List<ServiceCategoryNote> notes;

  @override
  ConsumerState<CredentialsNotesSheet> createState() =>
      _CredentialsNotesSheetState();
}

class _CredentialsNotesSheetState extends ConsumerState<CredentialsNotesSheet> {
  late final Map<String, TextEditingController> _controllers;
  late final Map<String, String> _originalMessages;
  late bool _hasPendingChangesCache;

  @override
  void initState() {
    super.initState();

    _controllers = {
      for (final note in widget.notes)
        note.categoryName: TextEditingController(text: note.message),
    };

    _originalMessages = {
      for (final note in widget.notes) note.categoryName: note.message,
    };

    _hasPendingChangesCache = false;

    for (final controller in _controllers.values) {
      controller.addListener(_onTextChanged);
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller
        ..removeListener(_onTextChanged)
        ..dispose();
    }
    super.dispose();
  }

  void _onTextChanged() {
    final nextHasChanges = _computeHasPendingChanges();
    if (nextHasChanges != _hasPendingChangesCache) {
      setState(() {
        _hasPendingChangesCache = nextHasChanges;
      });
    }
  }

  bool _computeHasPendingChanges() {
    for (final entry in _controllers.entries) {
      final category = entry.key;
      final current = entry.value.text.trim();
      final original = (_originalMessages[category] ?? '').trim();

      if (current != original) return true;
    }
    return false;
  }

  bool get _hasPendingChanges => _hasPendingChangesCache;

  void _handleSave() {
    final logger = ref.read(loggerProvider);

    for (final entry in _controllers.entries) {
      final category = entry.key;
      final before = (_originalMessages[category] ?? '').trim();
      final after = entry.value.text.trim();

      if (before != after) {
        logger.i(
          '[CredentialsNotes][SAVE] categoria=$category | before="$before" | after="$after"',
        );

        _originalMessages[category] = after;
      }
    }

    setState(() {
      _hasPendingChangesCache = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.82,
          minChildSize: 0.50,
          maxChildSize: 0.96,
          builder: (context, scrollController) {
            return Column(
              children: [
                const SizedBox(height: 10),
                Container(
                  width: 48,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
                  child: Row(
                    children: [
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(14),
                          onTap: () => Navigator.of(context).pop(),
                          child: Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: WorkOrderDetailsColors.softBlue,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(
                              Icons.arrow_back_rounded,
                              color: WorkOrderDetailsColors.brand,
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
                              widget.title.isEmpty
                                  ? context.l10n.clientNotes
                                  : widget.title,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w900,
                                color: WorkOrderDetailsColors.brand,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    context.l10n.credentialsByCategory,
                                    style: TextStyle(
                                      color: WorkOrderDetailsColors.brand
                                          .withValues(alpha: 0.65),
                                      fontSize: 12.5,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                IconButton(
                                  tooltip: context.l10n.saveChanges,
                                  onPressed: _hasPendingChanges
                                      ? _handleSave
                                      : null,
                                  icon: Icon(
                                    Icons.save_rounded,
                                    color: _hasPendingChanges
                                        ? WorkOrderDetailsColors.brand
                                        : WorkOrderDetailsColors.brand
                                              .withValues(alpha: 0.25),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: widget.notes.isEmpty
                      ? Center(child: Text(context.l10n.noCredentialsNotes))
                      : ListView.separated(
                          controller: scrollController,
                          padding: const EdgeInsets.all(16),
                          itemCount: widget.notes.length,
                          separatorBuilder: (_, separatorIndex) =>
                              const SizedBox(height: 14),
                          itemBuilder: (context, index) {
                            final item = widget.notes[index];
                            final controller = _controllers[item.categoryName]!;

                            return EditableServiceCategoryCard(
                              item: item,
                              controller: controller,
                            );
                          },
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class EditableServiceCategoryCard extends StatelessWidget {
  const EditableServiceCategoryCard({
    super.key,
    required this.item,
    required this.controller,
  });

  final ServiceCategoryNote item;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final scrollController = ScrollController();

    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CategoryBadge(text: item.categoryName),
          const SizedBox(height: 12),
          if (item.message.trim().isNotEmpty ||
              controller.text.trim().isNotEmpty) ...[
            Text(
              context.l10n.notesCredentials,
              style: const TextStyle(
                fontWeight: FontWeight.w900,
                color: WorkOrderDetailsColors.brand,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: WorkOrderDetailsColors.softBlue.withValues(alpha: 0.55),
                borderRadius: BorderRadius.circular(14),
              ),
              child: TextField(
                controller: controller,
                minLines: 4,
                maxLines: null,
                style: TextStyle(
                  color: WorkOrderDetailsColors.brand.withValues(alpha: 0.88),
                  height: 1.35,
                ),
                decoration: InputDecoration(
                  hintText: context.l10n.notesHint,
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
          if (item.images.isNotEmpty) ...[
            const SizedBox(height: 14),
            Text(
              context.l10n.imagesCount(item.images.length),
              style: const TextStyle(
                fontWeight: FontWeight.w900,
                color: WorkOrderDetailsColors.brand,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 10),
            Scrollbar(
              controller: scrollController,
              thumbVisibility: true,
              child: SizedBox(
                height: 110,
                child: SingleChildScrollView(
                  controller: scrollController,
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    children: item.images.map((img) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: SignedImagePreview(imageData: img),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ],
          if (controller.text.trim().isEmpty && item.images.isEmpty)
            Text(
              context.l10n.noCategoryContent,
              style: TextStyle(
                color: WorkOrderDetailsColors.brand.withValues(alpha: 0.60),
              ),
            ),
        ],
      ),
    );
  }
}

class SignedImagePreview extends ConsumerStatefulWidget {
  const SignedImagePreview({super.key, required this.imageData});

  final Map<String, dynamic> imageData;

  @override
  ConsumerState<SignedImagePreview> createState() => _SignedImagePreviewState();
}

class _SignedImagePreviewState extends ConsumerState<SignedImagePreview> {
  late Future<String?> _future;

  @override
  void initState() {
    super.initState();
    _future = _resolveUrl();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _future,
      builder: (context, snapshot) {
        final url = snapshot.data;

        return InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: url == null || url.isEmpty
              ? null
              : () {
                  showDialog<void>(
                    context: context,
                    builder: (_) => Dialog(
                      backgroundColor: Colors.black,
                      insetPadding: const EdgeInsets.all(16),
                      child: InteractiveViewer(
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: Image.network(
                            url,
                            fit: BoxFit.contain,
                            errorBuilder: (_, error, stackTrace) => Center(
                              child: Padding(
                                padding: const EdgeInsets.all(24),
                                child: Text(
                                  context.l10n.imageLoadError,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
          child: Container(
            width: 108,
            height: 108,
            decoration: BoxDecoration(
              color: WorkOrderDetailsColors.bg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: _buildContent(snapshot, url),
            ),
          ),
        );
      },
    );
  }

  Widget _buildContent(AsyncSnapshot<String?> snapshot, String? url) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator(strokeWidth: 2));
    }

    if (url == null || url.isEmpty) {
      return const Center(child: Icon(Icons.broken_image_outlined));
    }

    return Image.network(
      url,
      fit: BoxFit.cover,
      errorBuilder: (_, error, stackTrace) =>
          const Center(child: Icon(Icons.broken_image_outlined)),
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return const Center(child: CircularProgressIndicator(strokeWidth: 2));
      },
    );
  }

  Future<String?> _resolveUrl() async {
    final service = ref.read(signedDownloadUrlServiceProvider);

    try {
      final signedUrl = await service.getSignedDownloadUrl({
        'key': widget.imageData['key'],
        '_id': widget.imageData['_id'],
        'filename': widget.imageData['key']?.toString().split('/').last,
        'disposition': 'inline',
      });

      if (signedUrl != null && signedUrl.isNotEmpty) {
        return signedUrl;
      }
    } catch (_) {}

    final fallback = (widget.imageData['url'] ?? '').toString().trim();
    return fallback.isEmpty ? null : fallback;
  }
}
