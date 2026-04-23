/// Data model for a menu item at Benz Coffee
class MenuItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final String category; // 'Coffee', 'Frappe', 'Milk Tea', 'Pastry'
  final bool isBestSeller;
  final String imageAsset; // placeholder path; use Icons for now
  final List<String> availableSizes; // e.g. ['16oz', '22oz'] or []

  const MenuItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    this.isBestSeller = false,
    this.imageAsset = '',
    this.availableSizes = const [],
  });

  /// Returns price adjusted for size selection
  double priceForSize(String? size) {
    if (availableSizes.isEmpty || size == null) return price;
    
    // Size pricing logic for 16oz/22oz
    switch (size) {
      case '22oz':
        // Milk Tea items (₱120 base → ₱140 for 22oz)
        if (category == 'Milk Tea') return price + 20;
        // Frappe items (₱175 base → ₱195 for 22oz)
        if (category == 'Frappe') return price + 20;
        // Coffee items - add ₱20 for larger size
        if (category == 'Coffee') return price + 20;
        return price + 20;
      default:
        return price; // 16oz = base price
    }
  }
}