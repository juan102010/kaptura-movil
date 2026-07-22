import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../app/di/providers.dart';
import '../../../../core/localization/localization_extension.dart';
import '../../../customers/domain/entities/customer_entity.dart';
import '../../../customers/presentation/providers/customers_providers.dart';
import '../../../projects/domain/entities/project_entity.dart';
import '../../../users/domain/entities/user_list_entity.dart';
import '../../../home/presentation/providers/home_providers.dart';
import '../../domain/entities/work_order_entity.dart';
import 'work_order_customer_sheets.dart';
import 'work_order_history_widgets.dart';
import 'work_order_details_shared_widgets.dart';
import 'work_order_timer_widgets.dart';
import 'work_order_autosave_widgets.dart';

class GeneralTab extends ConsumerWidget {
  const GeneralTab({
    super.key,
    required this.wo,
    required this.users,
    required this.customers,
    required this.projects,
  });

  final WorkOrderEntity wo;
  final List<UserListEntity> users;
  final List<CustomerEntity> customers;
  final List<ProjectEntity> projects;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final assignedText = _assignedToText(
      ref: ref,
      assignedIds: wo.assignedIds,
      users: users,
    );

    final customerResolved = _resolveCustomer(
      ref: ref,
      customerId: wo.customerId,
      customers: customers,
    );

    final projectText = _projectToText(
      ref: ref,
      projectId: wo.projectId,
      projects: projects,
    );

    final customer = customerResolved.customer;
    final customerTitle = customer?.displayName ?? '';
    final customerRows = customer == null
        ? <DisplayRowData>[]
        : _buildCustomerSummaryRows(context, customer);
    final customerNotes = customer == null
        ? <ServiceCategoryNote>[]
        : _extractServiceNotes(customer);

    return WorkOrderSection(
      title: context.l10n.generalInformation,
      children: [
        WorkOrderFieldRow(
          icon: Icons.business_rounded,
          label: context.l10n.customer,
          value: customerResolved.displayText,
          showChevron: customer != null,
          onTap: customer == null
              ? null
              : () {
                  CustomerBottomSheetHelpers.showCustomerBottomSheet(
                    context: context,
                    ref: ref,
                    customer: customer,
                    title: customerTitle,
                    rows: customerRows,
                    notes: customerNotes,
                  );
                },
        ),
        WorkOrderFieldRow(
          icon: Icons.account_tree_rounded,
          label: context.l10n.project,
          value: projectText,
        ),
        WorkOrderFieldRow(
          icon: Icons.groups_rounded,
          label: context.l10n.assignedTo,
          value: assignedText,
        ),
        WorkOrderFieldRow(
          icon: Icons.layers_rounded,
          label: context.l10n.classLabel,
          value: wo.className,
        ),
        WorkOrderFieldRow(
          icon: Icons.category_rounded,
          label: context.l10n.type,
          value: wo.typeName,
        ),
      ],
    );
  }

  List<DisplayRowData> _buildCustomerSummaryRows(
    BuildContext context,
    CustomerEntity customer,
  ) {
    final rows = <DisplayRowData>[];
    final raw = customer.rawData;

    void addRow(String label, dynamic value) {
      final text = _stringifyValue(value);
      if (text.isEmpty) return;
      rows.add(DisplayRowData(label: label, value: text));
    }

    addRow(context.l10n.customerName, raw['text_custName_id']);
    addRow(context.l10n.customerType, raw['rad_clientType_id']);
    addRow(context.l10n.firstName, raw['text_firstName_id']);
    addRow(context.l10n.lastName, raw['text_lastName_id']);
    addRow(context.l10n.mainEmail, raw['text_mainEmail_id']);
    addRow(context.l10n.mobile, raw['text_mobile_id']);
    addRow(context.l10n.mainPhone, raw['text_mainPhone_id']);
    addRow(context.l10n.address, raw['text_street_id']);

    return rows;
  }

  List<ServiceCategoryNote> _extractServiceNotes(CustomerEntity customer) {
    final result = <ServiceCategoryNote>[];
    final raw = customer.rawData['obj_categoriesOfServices_id'];

    if (raw is! Map) return result;

    for (final entry in raw.entries) {
      final categoryName = entry.key.toString().trim();
      final value = entry.value;

      if (value is! List || value.isEmpty) continue;
      final first = value.first;
      if (first is! Map) continue;

      result.add(
        ServiceCategoryNote(
          categoryName: categoryName,
          message: _stringifyValue(first['message']),
          images: _normalizeImages(first['images']),
        ),
      );
    }

    return result;
  }

  List<Map<String, dynamic>> _normalizeImages(dynamic value) {
    if (value is! List) return <Map<String, dynamic>>[];
    return value
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }

  String _stringifyValue(dynamic value) {
    if (value == null) return '';
    if (value is List) {
      return value
          .map((item) => item == null ? '' : item.toString().trim())
          .where((item) => item.isNotEmpty)
          .join(', ');
    }
    if (value is Map) return value.toString();
    return value.toString().trim();
  }

  String _assignedToText({
    required WidgetRef ref,
    required List<String> assignedIds,
    required List<UserListEntity> users,
  }) {
    final logger = ref.watch(loggerProvider);
    logger.i('[GeneralTab][users] idsNormalizados=$assignedIds');
    if (assignedIds.isEmpty) return '';

    final userMap = <String, String>{};
    for (final user in users) {
      final id = user.id.trim();
      if (id.isEmpty) continue;
      final name = user.name.isEmpty ? user.email : user.name;
      userMap[id] = name.isEmpty ? id : name;
    }

    final result = assignedIds.map((id) => userMap[id] ?? id).join(', ');
    logger.i('[GeneralTab][users] Resultado final assignedText=$result');
    return result;
  }

  ResolvedCustomer _resolveCustomer({
    required WidgetRef ref,
    required String customerId,
    required List<CustomerEntity> customers,
  }) {
    final logger = ref.watch(loggerProvider);
    final id = customerId.trim();
    if (id.isEmpty) {
      return const ResolvedCustomer(displayText: '', customer: null);
    }

    CustomerEntity? foundCustomer;
    for (final customer in customers) {
      if (customer.matchesId(id)) {
        foundCustomer = customer;
        break;
      }
    }

    final displayText = foundCustomer == null
        ? id
        : (foundCustomer.displayName.isEmpty ? id : foundCustomer.displayName);

    logger.i(
      '[GeneralTab][customers] customerId=$id -> displayText=$displayText | found=${foundCustomer != null}',
    );

    return ResolvedCustomer(displayText: displayText, customer: foundCustomer);
  }

  String _projectToText({
    required WidgetRef ref,
    required String projectId,
    required List<ProjectEntity> projects,
  }) {
    final logger = ref.watch(loggerProvider);
    final id = projectId.trim();
    if (id.isEmpty) return '';

    final projectMap = <String, String>{};
    for (final project in projects) {
      final pid = project.id.trim();
      if (pid.isEmpty) continue;
      projectMap[pid] = project.name.isEmpty ? pid : project.name;
    }

    final result = projectMap[id] ?? id;
    logger.i('[GeneralTab][projects] projectId=$id -> $result');
    return result;
  }
}

class CredentialsNotesTab extends ConsumerStatefulWidget {
  const CredentialsNotesTab({
    super.key,
    required this.customerId,
    required this.customers,
  });

  final String customerId;
  final List<CustomerEntity> customers;

  @override
  ConsumerState<CredentialsNotesTab> createState() =>
      _CredentialsNotesTabState();
}

class _CredentialsNotesTabState extends ConsumerState<CredentialsNotesTab> {
  CustomerEntity? _customer;
  Map<String, dynamic> _categories = <String, dynamic>{};
  String? _selectedCategory;
  bool _uploading = false;
  double _uploadProgress = 0;

  @override
  void initState() {
    super.initState();
    _loadFromCustomer();
  }

  @override
  void didUpdateWidget(covariant CredentialsNotesTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_uploading) _loadFromCustomer(keepSelection: true);
  }

  void _loadFromCustomer({bool keepSelection = false}) {
    _customer = null;
    for (final customer in widget.customers) {
      if (customer.matchesId(widget.customerId)) {
        _customer = customer;
        break;
      }
    }
    final raw = _customer?.rawData['obj_categoriesOfServices_id'];
    _categories = raw is Map
        ? Map<String, dynamic>.from(_deepCopy(raw) as Map)
        : <String, dynamic>{};
    final names = _categories.keys.toList(growable: false);
    if (!keepSelection || !names.contains(_selectedCategory)) {
      _selectedCategory = names.isEmpty ? null : names.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    final names = _categories.keys.toList(growable: false);
    final records = _recordsFor(_selectedCategory);
    return WorkOrderSection(
      title: context.l10n.credentialsByCategory,
      showHeader: false,
      children: [
        if (names.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 28),
            child: Center(child: Text(context.l10n.noCredentialsNotes)),
          )
        else ...[
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: names
                  .map(
                    (name) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(name),
                        selected: name == _selectedCategory,
                        onSelected: (_) =>
                            setState(() => _selectedCategory = name),
                      ),
                    ),
                  )
                  .toList(growable: false),
            ),
          ),
          const SizedBox(height: 14),
          if (records.isEmpty)
            Center(child: Text(context.l10n.noCategoryContent))
          else
            _buildCategoryCard(category: _selectedCategory!, records: records),
        ],
      ],
    );
  }

  Widget _buildCategoryCard({
    required String category,
    required List<Map<String, dynamic>> records,
  }) {
    final images = _mergedImages(records);
    final message = records
        .map((record) => (record['message'] ?? '').toString().trim())
        .firstWhere((value) => value.isNotEmpty, orElse: () => '');
    return Container(
      key: ValueKey(category),
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WorkOrderAutosaveField(
            key: ValueKey('message-$category'),
            icon: Icons.notes_rounded,
            label: context.l10n.notesCredentials,
            value: message,
            maxLines: 3,
            onSave: (_, newValue) => _updateCategoryMessage(category, newValue),
          ),
          if (images.isNotEmpty)
            SizedBox(
              height: 124,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: images.length,
                separatorBuilder: (_, _) => const SizedBox(width: 10),
                itemBuilder: (_, imageIndex) => Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8, right: 8),
                      child: SignedImagePreview(
                        imageData: images[imageIndex].data,
                      ),
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: IconButton.filled(
                        visualDensity: VisualDensity.compact,
                        iconSize: 16,
                        onPressed: () => _removeImage(
                          category,
                          images[imageIndex].recordIndex,
                          images[imageIndex].imageIndex,
                        ),
                        icon: const Icon(Icons.close_rounded),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 10),
          if (_uploading)
            LinearProgressIndicator(value: _uploadProgress)
          else
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _addImage(category, ImageSource.camera),
                    icon: const Icon(Icons.photo_camera_outlined),
                    label: Text(context.l10n.takePhoto),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _addImage(category, ImageSource.gallery),
                    icon: const Icon(Icons.attach_file_rounded),
                    label: Text(context.l10n.attachImages),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _recordsFor(String? category) {
    final raw = category == null ? null : _categories[category];
    if (raw is! List) return const <Map<String, dynamic>>[];
    return raw
        .whereType<Map>()
        .map((record) => Map<String, dynamic>.from(record))
        .toList(growable: false);
  }

  List<({int recordIndex, int imageIndex, Map<String, dynamic> data})>
  _mergedImages(List<Map<String, dynamic>> records) {
    final result =
        <({int recordIndex, int imageIndex, Map<String, dynamic> data})>[];
    final seen = <String>{};
    for (var recordIndex = 0; recordIndex < records.length; recordIndex++) {
      final rawImages = records[recordIndex]['images'];
      if (rawImages is! List) continue;
      for (var imageIndex = 0; imageIndex < rawImages.length; imageIndex++) {
        final rawImage = rawImages[imageIndex];
        if (rawImage is! Map) continue;
        final image = Map<String, dynamic>.from(rawImage);
        final identity = (image['id'] ?? image['key'] ?? image['url'] ?? '')
            .toString();
        final uniqueKey = identity.isEmpty
            ? '$recordIndex-$imageIndex'
            : identity;
        if (!seen.add(uniqueKey)) continue;
        result.add((
          recordIndex: recordIndex,
          imageIndex: imageIndex,
          data: image,
        ));
      }
    }
    return result;
  }

  Future<void> _updateCategoryMessage(String category, String message) async {
    final next = _copyCategories();
    final records = next[category] as List;
    for (final record in records.whereType<Map>()) {
      record['message'] = message;
    }
    await _saveCategories(next);
  }

  Future<void> _removeImage(
    String category,
    int recordIndex,
    int imageIndex,
  ) async {
    final next = _copyCategories();
    final record = (next[category] as List)[recordIndex] as Map;
    final images = record['images'] as List? ?? <dynamic>[];
    images.removeAt(imageIndex);
    record['images'] = images;
    await _saveCategories(next);
  }

  Future<void> _addImage(String category, ImageSource source) async {
    final file = await ImagePicker().pickImage(
      source: source,
      imageQuality: 85,
      maxWidth: 1920,
    );
    if (file == null || !mounted) return;
    setState(() {
      _uploading = true;
      _uploadProgress = 0;
    });
    try {
      final meta = await ref
          .read(postUploadFileServiceProvider)
          .upload(
            file,
            onSendProgress: (sent, total) {
              if (mounted && total > 0) {
                setState(() => _uploadProgress = sent / total);
              }
            },
          );
      final next = _copyCategories();
      final categoryRecords = next[category] as List;
      if (categoryRecords.isEmpty) return;
      final record = categoryRecords.first as Map;
      final images = record['images'] is List
          ? record['images'] as List
          : <dynamic>[];
      images.add(meta);
      record['images'] = images;
      await _saveCategories(next);
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.toString().replaceFirst('Exception: ', '')),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _uploading = false);
    }
  }

  Future<void> _saveCategories(Map<String, dynamic> next) async {
    final customer = _customer;
    if (customer == null) return;
    final previous = _copyCategories();
    await ref
        .read(updateDataByIdServiceProvider)
        .update(
          tableName: 'customers',
          id: customer.id,
          data: {
            'obj_categoriesOfServices_id': {
              'oldValue': previous,
              'newValue': next,
            },
          },
        );
    await ref.read(customersControllerProvider.notifier).applyCustomerPatch(
      customer.id,
      {'obj_categoriesOfServices_id': next},
    );
    if (mounted) setState(() => _categories = next);
  }

  Map<String, dynamic> _copyCategories() =>
      Map<String, dynamic>.from(_deepCopy(_categories) as Map);

  dynamic _deepCopy(dynamic value) => jsonDecode(jsonEncode(value));
}

class TimeTab extends ConsumerStatefulWidget {
  const TimeTab({super.key, required this.wo});

  final WorkOrderEntity wo;

  @override
  ConsumerState<TimeTab> createState() => _TimeTabState();
}

class _TimeTabState extends ConsumerState<TimeTab> {
  late WorkOrderEntity _woLocal;

  @override
  void initState() {
    super.initState();
    _woLocal = widget.wo;
  }

  @override
  void didUpdateWidget(covariant TimeTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.wo.rawData.toString() != widget.wo.rawData.toString()) {
      _woLocal = widget.wo;
    }
  }

  @override
  Widget build(BuildContext context) {
    final workOrderId = _woLocal.id;
    final historyItems = _woLocal.timeHistory;

    return WorkOrderSection(
      title: context.l10n.timeAndScheduling,
      children: [
        WorkOrderTimerCard(
          workOrderId: workOrderId,
          history: historyItems,
          onHistoryUpdated: (newHistory) {
            setState(() {
              _woLocal = _woLocal.withUpdatedTimeHistory(newHistory);
            });
            unawaited(
              ref
                  .read(homeControllerProvider.notifier)
                  .applyWorkOrderPatch(workOrderId, {
                    'text_dateTime_id': newHistory
                        .map((item) => item.toMap())
                        .toList(),
                  }),
            );
          },
        ),
        WorkOrderTimeHistoryTimeline(history: historyItems),
      ],
    );
  }
}

class TechTab extends ConsumerWidget {
  const TechTab({super.key, required this.wo});

  final WorkOrderEntity wo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return WorkOrderSection(
      title: context.l10n.technicalDetails,
      children: [
        WorkOrderAutosaveField(
          icon: Icons.description_outlined,
          label: context.l10n.technicalNotes,
          value: wo.techNotes,
          maxLines: 3,
          onSave: (oldValue, newValue) => autosaveWorkOrderField(
            ref: ref,
            workOrderId: wo.id,
            field: 'text_workTechNotes_id',
            oldValue: oldValue,
            newValue: newValue,
          ),
        ),
        WorkOrderAutosaveField(
          icon: Icons.checklist_rounded,
          label: context.l10n.tasks,
          value: wo.tasks,
          maxLines: 3,
          onSave: (oldValue, newValue) => autosaveWorkOrderField(
            ref: ref,
            workOrderId: wo.id,
            field: 'text_tasks_id',
            oldValue: oldValue,
            newValue: newValue,
          ),
        ),
        WorkOrderAutosaveField(
          icon: Icons.rule_folder_rounded,
          label: context.l10n.toDo,
          value: wo.todo,
          maxLines: 3,
          onSave: (oldValue, newValue) => autosaveWorkOrderField(
            ref: ref,
            workOrderId: wo.id,
            field: 'text_toDo_id',
            oldValue: oldValue,
            newValue: newValue,
          ),
        ),
      ],
    );
  }
}

class LocationTab extends ConsumerStatefulWidget {
  const LocationTab({
    super.key,
    required this.customerId,
    required this.customers,
    required this.workLocation,
  });

  final String customerId;
  final List<CustomerEntity> customers;
  final String workLocation;

  @override
  ConsumerState<LocationTab> createState() => _LocationTabState();
}

class _LocationTabState extends ConsumerState<LocationTab> {
  bool _saving = false;

  @override
  Widget build(BuildContext context) {
    final customer = _resolveCustomer();
    final coordinates = customer == null
        ? null
        : WorkCoordinates.tryFromCustomer(customer, widget.workLocation);
    final addressIndex = customer == null
        ? null
        : WorkCoordinates.addressIndexFor(customer, widget.workLocation);
    final location = coordinates?.formatted ?? '';
    return WorkOrderSection(
      title: context.l10n.location,
      children: [
        WorkOrderFieldRow(
          icon: Icons.location_on_outlined,
          label: context.l10n.workplace,
          value: location,
        ),
        if (coordinates == null)
          FilledButton.icon(
            onPressed: _saving || customer == null || addressIndex == null
                ? null
                : () => _confirmAndRegisterLocation(customer),
            icon: _saving
                ? const SizedBox.square(
                    dimension: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.my_location_rounded),
            label: Text(context.l10n.registerCustomerLocation),
          )
        else
          FilledButton.tonalIcon(
            onPressed: () => _openMaps(coordinates),
            icon: const Icon(Icons.map_outlined),
            label: Text(context.l10n.showInMaps),
          ),
      ],
    );
  }

  CustomerEntity? _resolveCustomer() {
    final customerId = widget.customerId.trim();
    if (customerId.isEmpty) return null;
    for (final customer in widget.customers) {
      if (customer.matchesId(customerId)) return customer;
    }
    return null;
  }

  Future<void> _confirmAndRegisterLocation(CustomerEntity customer) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.registerCustomerLocation),
        content: Text(context.l10n.customerLocationConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.l10n.no),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(context.l10n.yes),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    setState(() => _saving = true);
    try {
      final coords = await ref
          .read(locationServiceProvider)
          .getRequiredCoords();
      final latitude = coords.lat.toDouble();
      final longitude = coords.lng.toDouble();
      final addressIndex = WorkCoordinates.addressIndexFor(
        customer,
        widget.workLocation,
      );
      if (addressIndex == null) {
        throw Exception(
          'No fue posible identificar la dirección del lugar de trabajo.',
        );
      }
      final latitudes = _updatedCoordinateValues(
        customer.rawData['text_addressLatitude_id'],
        addressIndex,
        latitude,
      );
      final longitudes = _updatedCoordinateValues(
        customer.rawData['text_addressLongitude_id'],
        addressIndex,
        longitude,
      );
      await ref
          .read(updateDataByIdServiceProvider)
          .update(
            tableName: 'customers',
            id: customer.id,
            data: {
              'text_addressLatitude_id': {
                'oldValue': customer.rawData['text_addressLatitude_id'],
                'newValue': latitudes,
              },
              'text_addressLongitude_id': {
                'oldValue': customer.rawData['text_addressLongitude_id'],
                'newValue': longitudes,
              },
            },
          );
      await ref
          .read(customersControllerProvider.notifier)
          .applyCustomerPatch(customer.id, {
            'text_addressLatitude_id': latitudes,
            'text_addressLongitude_id': longitudes,
          });
      if (mounted) {
        setState(() {});
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.toString().replaceFirst('Exception: ', '')),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  List<dynamic> _updatedCoordinateValues(
    dynamic currentValue,
    int index,
    double coordinate,
  ) {
    final values = currentValue is List
        ? List<dynamic>.from(currentValue)
        : <dynamic>[];
    while (values.length <= index) {
      values.add(null);
    }
    values[index] = coordinate;
    return values;
  }

  Future<void> _openMaps(WorkCoordinates coordinates) async {
    final uri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query='
      '${coordinates.latitude},${coordinates.longitude}',
    );
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication) &&
        mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.l10n.couldNotOpenMaps)));
    }
  }
}

class PartsTab extends ConsumerWidget {
  const PartsTab({super.key, required this.wo});

  final WorkOrderEntity wo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return WorkOrderSection(
      title: context.l10n.partsSpareParts,
      children: [
        WorkOrderAutosaveField(
          icon: Icons.inventory_2_outlined,
          label: context.l10n.partsToDeliver,
          value: wo.partsToDeliver,
          maxLines: 3,
          onSave: (oldValue, newValue) => autosaveWorkOrderField(
            ref: ref,
            workOrderId: wo.id,
            field: 'text_partsToDeliver_id',
            oldValue: oldValue,
            newValue: newValue,
          ),
        ),
        WorkOrderAutosaveField(
          icon: Icons.send_rounded,
          label: context.l10n.requestParts,
          value: wo.requestParts,
          maxLines: 3,
          onSave: (oldValue, newValue) => autosaveWorkOrderField(
            ref: ref,
            workOrderId: wo.id,
            field: 'text_requestParts_id',
            oldValue: oldValue,
            newValue: newValue,
          ),
        ),
        WorkOrderAutosaveField(
          icon: Icons.done_all_rounded,
          label: context.l10n.usedParts,
          value: wo.donePartsUsed,
          maxLines: 3,
          onSave: (oldValue, newValue) => autosaveWorkOrderField(
            ref: ref,
            workOrderId: wo.id,
            field: 'text_donePartsUsed_id',
            oldValue: oldValue,
            newValue: newValue,
          ),
        ),
        WorkOrderAutosaveField(
          icon: Icons.pending_rounded,
          label: context.l10n.requiredParts,
          value: wo.leftToDoPartsNeeded,
          maxLines: 3,
          onSave: (oldValue, newValue) => autosaveWorkOrderField(
            ref: ref,
            workOrderId: wo.id,
            field: 'text_leftToDoPartsNeeded_id',
            oldValue: oldValue,
            newValue: newValue,
          ),
        ),
      ],
    );
  }
}

class EvidenceTab extends ConsumerStatefulWidget {
  const EvidenceTab({super.key, required this.wo});

  final WorkOrderEntity wo;

  @override
  ConsumerState<EvidenceTab> createState() => _EvidenceTabState();
}

class _EvidenceTabState extends ConsumerState<EvidenceTab> {
  late List<Map<String, dynamic>> _images;
  bool _uploading = false;
  double _progress = 0;

  @override
  void initState() {
    super.initState();
    _images = widget.wo.evidenceImages;
  }

  @override
  void didUpdateWidget(covariant EvidenceTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_uploading &&
        oldWidget.wo.evidenceImages != widget.wo.evidenceImages) {
      _images = widget.wo.evidenceImages;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WorkOrderSection(
      title: context.l10n.evidence,
      children: [
        if (_images.isNotEmpty)
          SizedBox(
            height: 116,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _images.length,
              separatorBuilder: (_, _) => const SizedBox(width: 10),
              itemBuilder: (context, index) =>
                  _EvidenceThumbnail(imageInfo: _images[index]),
            ),
          )
        else
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 18),
            child: Center(child: Text(context.l10n.noEvidenceImages)),
          ),
        const SizedBox(height: 8),
        if (_uploading)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox.square(
                  dimension: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                const SizedBox(width: 10),
                Text(
                  context.l10n.uploadingImagePercent((_progress * 100).round()),
                ),
              ],
            ),
          )
        else
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: () => _pickAndUpload(ImageSource.camera),
                  icon: const Icon(Icons.photo_camera_outlined),
                  label: Text(context.l10n.takePhoto),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: FilledButton.tonalIcon(
                  onPressed: () => _pickAndUpload(ImageSource.gallery),
                  icon: const Icon(Icons.attach_file_rounded),
                  label: Text(context.l10n.attachImages),
                ),
              ),
            ],
          ),
      ],
    );
  }

  Future<void> _pickAndUpload(ImageSource source) async {
    final file = await ImagePicker().pickImage(
      source: source,
      imageQuality: 85,
      maxWidth: 1920,
    );
    if (file == null || !mounted) return;

    setState(() {
      _uploading = true;
      _progress = 0;
    });
    try {
      final meta = await ref
          .read(postUploadFileServiceProvider)
          .upload(
            file,
            onSendProgress: (sent, total) {
              if (mounted && total > 0) {
                setState(() => _progress = sent / total);
              }
            },
          );
      final updated = <Map<String, dynamic>>[
        ..._images,
        {'name': file.name, 'meta': meta},
      ];
      await autosaveWorkOrderField(
        ref: ref,
        workOrderId: widget.wo.id,
        field: 'files_infoImagesUpload_id',
        oldValue: _images,
        newValue: updated,
      );
      if (mounted) setState(() => _images = updated);
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.toString().replaceFirst('Exception: ', '')),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _uploading = false);
    }
  }
}

class _EvidenceThumbnail extends ConsumerWidget {
  const _EvidenceThumbnail({required this.imageInfo});

  final Map<String, dynamic> imageInfo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final meta = imageInfo['meta'];
    final params = meta is Map
        ? Map<String, dynamic>.from(meta)
        : <String, dynamic>{};
    return FutureBuilder<String?>(
      future: ref.read(signedDownloadUrlServiceProvider).getSignedDownloadUrl({
        ...params,
        'disposition': 'inline',
        'filename': imageInfo['name']?.toString(),
      }),
      builder: (context, snapshot) {
        final fallback = params['url']?.toString();
        final url = snapshot.data?.trim().isNotEmpty == true
            ? snapshot.data!
            : fallback;
        return InkWell(
          onTap: url == null || url.isEmpty
              ? null
              : () => showDialog<void>(
                  context: context,
                  builder: (_) => Dialog(
                    child: InteractiveViewer(child: Image.network(url)),
                  ),
                ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Container(
              width: 116,
              color: Colors.black12,
              child: url == null || url.isEmpty
                  ? const Icon(Icons.broken_image_outlined)
                  : Image.network(
                      url,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) =>
                          const Icon(Icons.broken_image_outlined),
                    ),
            ),
          ),
        );
      },
    );
  }
}

class WorkCoordinates {
  const WorkCoordinates(this.latitude, this.longitude);

  final double latitude;
  final double longitude;

  String get formatted => '$latitude,$longitude';

  static WorkCoordinates? tryFromCustomer(
    CustomerEntity customer, [
    String workLocation = '',
  ]) {
    final validCoordinates = _validCustomerCoordinates(customer);
    if (customer.addressCount <= 1) {
      return validCoordinates.isEmpty ? null : validCoordinates.first.$2;
    }

    final embedded = tryParseWorkLocation(workLocation);
    if (embedded != null) return embedded;

    if (validCoordinates.isEmpty) return null;

    final addressIndex = addressIndexFor(customer, workLocation);
    if (addressIndex == null) return null;
    for (final item in validCoordinates) {
      if (item.$1 == addressIndex) return item.$2;
    }
    return null;
  }

  static int? addressIndexFor(CustomerEntity customer, String workLocation) {
    if (customer.addressCount <= 1) return 0;

    final embedded = tryParseWorkLocation(workLocation);
    if (embedded != null) {
      for (final item in _validCustomerCoordinates(customer)) {
        if ((item.$2.latitude - embedded.latitude).abs() < 0.000001 &&
            (item.$2.longitude - embedded.longitude).abs() < 0.000001) {
          return item.$1;
        }
      }
    }

    final normalizedLocation = workLocation.toLowerCase().trim();
    if (normalizedLocation.isEmpty) return null;
    final candidates = <({int index, String value})>[];
    for (var index = 0; index < customer.addressCount; index++) {
      if (index < customer.streets.length) {
        candidates.add((index: index, value: customer.streets[index]));
      }
      if (index < customer.addresses.length) {
        candidates.add((index: index, value: customer.addresses[index]));
      }
    }
    candidates.sort((a, b) => b.value.length.compareTo(a.value.length));
    for (final candidate in candidates) {
      final address = candidate.value.toLowerCase().trim();
      if (address.isNotEmpty && normalizedLocation.contains(address)) {
        return candidate.index;
      }
    }
    return null;
  }

  static WorkCoordinates? tryParseWorkLocation(String value) {
    final match = RegExp(
      r'Lat\s*:\s*(-?\d+(?:\.\d+)?)\s*\|\s*Lng\s*:\s*(-?\d+(?:\.\d+)?)',
      caseSensitive: false,
    ).firstMatch(value);
    if (match == null) return null;
    return tryParse('${match.group(1)},${match.group(2)}');
  }

  static List<(int, WorkCoordinates)> _validCustomerCoordinates(
    CustomerEntity customer,
  ) {
    final result = <(int, WorkCoordinates)>[];
    final length =
        customer.addressLatitudes.length < customer.addressLongitudes.length
        ? customer.addressLatitudes.length
        : customer.addressLongitudes.length;
    for (var index = 0; index < length; index++) {
      final latitude = customer.addressLatitudes[index];
      final longitude = customer.addressLongitudes[index];
      if (latitude != null && longitude != null) {
        result.add((index, WorkCoordinates(latitude, longitude)));
      }
    }
    return result;
  }

  static WorkCoordinates? tryParse(String value) {
    final parts = value.split(',').map((part) => part.trim()).toList();
    if (parts.length != 2) return null;
    final latitude = double.tryParse(parts[0]);
    final longitude = double.tryParse(parts[1]);
    if (latitude == null || longitude == null) return null;
    if (latitude < -90 || latitude > 90) return null;
    if (longitude < -180 || longitude > 180) return null;
    return WorkCoordinates(latitude, longitude);
  }
}
