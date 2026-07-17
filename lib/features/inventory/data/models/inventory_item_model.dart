import '../../domain/entities/inventory_item_entity.dart';

class InventoryItemModel extends InventoryItemEntity {
  const InventoryItemModel({
    required super.id,
    required super.itemId,
    required super.itemName,
    required super.defaultQty,
    required super.stockMin,
    required super.isActive,
    required super.createdAt,
    required super.updatedAt,
    required super.rawData,
  });

  factory InventoryItemModel.fromMap(Map<String, dynamic> map) {
    return InventoryItemModel(
      id: (map['_id'] ?? '').toString().trim(),
      itemId: (map['itemId'] ?? '').toString().trim(),
      itemName: (map['text_itemName_id'] ?? '').toString().trim(),
      defaultQty: _toInt(map['num_defaultQty_id']),
      stockMin: _toInt(map['num_stocMin_id']),
      isActive: _toBool(map['swt_state_id']),
      createdAt: (map['createdAt'] ?? '').toString().trim(),
      updatedAt: (map['updatedAt'] ?? '').toString().trim(),
      rawData: Map<String, dynamic>.from(map),
    );
  }

  Map<String, dynamic> toMap() => Map<String, dynamic>.from(rawData);

  static int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is double) return value.toInt();
    return int.tryParse((value ?? '').toString()) ?? 0;
  }

  static bool _toBool(dynamic value) {
    if (value is bool) return value;
    if (value is num) return value != 0;
    final text = (value ?? '').toString().trim().toLowerCase();
    return text == 'true' || text == '1';
  }
}
