class InventoryItemEntity {
  const InventoryItemEntity({
    required this.id,
    required this.itemId,
    required this.itemName,
    required this.defaultQty,
    required this.stockMin,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    required this.rawData,
  });

  final String id;
  final String itemId;
  final String itemName;
  final int defaultQty;
  final int stockMin;
  final bool isActive;
  final String createdAt;
  final String updatedAt;
  final Map<String, dynamic> rawData;

  bool matchesId(String otherId) => id == otherId.trim();

  InventoryItemEntity copyWith({
    String? id,
    String? itemId,
    String? itemName,
    int? defaultQty,
    int? stockMin,
    bool? isActive,
    String? createdAt,
    String? updatedAt,
    Map<String, dynamic>? rawData,
  }) {
    return InventoryItemEntity(
      id: id ?? this.id,
      itemId: itemId ?? this.itemId,
      itemName: itemName ?? this.itemName,
      defaultQty: defaultQty ?? this.defaultQty,
      stockMin: stockMin ?? this.stockMin,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rawData: rawData ?? this.rawData,
    );
  }
}
