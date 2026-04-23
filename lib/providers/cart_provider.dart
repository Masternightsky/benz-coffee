import 'package:flutter/foundation.dart';
import '../models/cart_item.dart';
import '../models/menu_item.dart';

/// CartProvider manages all cart state across the app.
/// Persists across screen navigation via Provider at the app root.
class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];
  String? _lastOrderNumber;

  // ── Getters ───────────────────────────────────────────────────────

  List<CartItem> get items => List.unmodifiable(_items);

  bool get isEmpty => _items.isEmpty;

  int get totalItemCount =>
      _items.fold(0, (sum, item) => sum + item.quantity);

  double get subtotal =>
      _items.fold(0, (sum, item) => sum + item.totalPrice);

  double get total => subtotal; // No delivery fee – pay at counter

  String? get lastOrderNumber => _lastOrderNumber;

  // ── Mutation Methods ──────────────────────────────────────────────

  /// Add an item to the cart. If same item+size exists, increase quantity.
  void addItem(MenuItem menuItem, {String? size, String instructions = ''}) {
    final existingIndex = _items.indexWhere(
      (ci) => ci.item.id == menuItem.id && ci.selectedSize == size,
    );

    if (existingIndex >= 0) {
      _items[existingIndex].quantity += 1;
    } else {
      _items.add(CartItem(
        item: menuItem,
        selectedSize: size,
        quantity: 1,
        specialInstructions: instructions,
      ));
    }
    notifyListeners();
  }

  /// Increase quantity of a cart item
  void increaseQuantity(int index) {
    if (index < 0 || index >= _items.length) return;
    _items[index].quantity += 1;
    notifyListeners();
  }

  /// Decrease quantity; removes item if it reaches 0
  void decreaseQuantity(int index) {
    if (index < 0 || index >= _items.length) return;
    if (_items[index].quantity <= 1) {
      removeItem(index);
    } else {
      _items[index].quantity -= 1;
      notifyListeners();
    }
  }

  /// Remove item entirely by index
  void removeItem(int index) {
    if (index < 0 || index >= _items.length) return;
    _items.removeAt(index);
    notifyListeners();
  }

  /// Generate a BC-XXXX order number and clear the cart.
  /// Returns the generated order number.
  String placeOrder() {
    final rand = (1000 + (DateTime.now().millisecondsSinceEpoch % 9000));
    _lastOrderNumber = 'BC-$rand';
    // TODO: Send order to staff app backend (Part 2)
    _items.clear();
    notifyListeners();
    return _lastOrderNumber!;
  }

  /// Clear cart (e.g., on "Back to Home" from receipt)
  void clearCart() {
    _items.clear();
    _lastOrderNumber = null;
    notifyListeners();
  }
}
