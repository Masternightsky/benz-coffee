/// Menu item model for inventory management
class InventoryItem {
  final String id;
  final String name;
  final String category;
  final double price;
  final bool isAvailable;

  InventoryItem({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.isAvailable, // Make sure this is required, not optional
  });

  /// Create a copy with updated availability
  InventoryItem copyWith({
    String? id,
    String? name,
    String? category,
    double? price,
    bool? isAvailable,
  }) {
    return InventoryItem(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      price: price ?? this.price,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }

  @override
  String toString() {
    return 'InventoryItem(id: $id, name: $name, category: $category, isAvailable: $isAvailable)';
  }
}