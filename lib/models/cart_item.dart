import 'menu_item.dart';

/// Represents a single item in the customer's cart
class CartItem {
  final MenuItem item;
  String? selectedSize;
  int quantity;
  String specialInstructions;

  CartItem({
    required this.item,
    this.selectedSize,
    this.quantity = 1,
    this.specialInstructions = '',
  });

  /// Total price = unit price (with size adjustment) × quantity
  double get totalPrice => item.priceForSize(selectedSize) * quantity;

  /// Display label for size (empty if no size)
  String get sizeLabel => selectedSize ?? '';

  /// Create a copy with updated fields
  CartItem copyWith({
    String? selectedSize,
    int? quantity,
    String? specialInstructions,
  }) {
    return CartItem(
      item: item,
      selectedSize: selectedSize ?? this.selectedSize,
      quantity: quantity ?? this.quantity,
      specialInstructions: specialInstructions ?? this.specialInstructions,
    );
  }
}
