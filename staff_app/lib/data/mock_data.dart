import '../models/order.dart';
import '../models/menu_item.dart';

/// Mock orders with different statuses for demonstration
final List<Order> mockOrders = [
  Order(
    id: '1',
    orderNumber: 'BC-1001',
    timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
    status: OrderStatus.pending,
    totalAmount: 277, // Caramel Macchiato (167) + Croissant (110)
    items: [
      OrderItem(
        name: 'Caramel Macchiato',
        quantity: 1,
        size: '16oz',
        customization: 'Hot',
        price: 167,
      ),
      OrderItem(
        name: 'Croissant',
        quantity: 1,
        price: 110,
      ),
    ],
  ),
  Order(
    id: '2',
    orderNumber: 'BC-1002',
    timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
    status: OrderStatus.pending,
    totalAmount: 510, // Spanish Latte x2 (145 each = 290) + Cheesecake (220)
    items: [
      OrderItem(
        name: 'Spanish Latte',
        quantity: 2,
        size: '22oz',
        customization: 'Iced',
        price: 145,
      ),
      OrderItem(
        name: 'Burnt Basque Cheesecake',
        quantity: 1,
        price: 220,
      ),
    ],
  ),
  Order(
    id: '3',
    orderNumber: 'BC-1003',
    timestamp: DateTime.now().subtract(const Duration(minutes: 28)),
    status: OrderStatus.paid,
    totalAmount: 295, // Strawberry Frappe (175) + Wintermelon Milk Tea (120)
    items: [
      OrderItem(
        name: 'Strawberry Frappe',
        quantity: 1,
        size: '16oz',
        price: 175,
      ),
      OrderItem(
        name: 'Wintermelon Milk Tea',
        quantity: 1,
        size: '22oz',
        price: 120,
      ),
    ],
  ),
  Order(
    id: '4',
    orderNumber: 'BC-1004',
    timestamp: DateTime.now().subtract(const Duration(minutes: 45)),
    status: OrderStatus.paid,
    totalAmount: 110,
    items: [
      OrderItem(
        name: 'Americano',
        quantity: 1,
        size: '16oz',
        customization: 'Hot',
        price: 110,
      ),
    ],
  ),
  Order(
    id: '5',
    orderNumber: 'BC-1005',
    timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 10)),
    status: OrderStatus.paid,
    totalAmount: 315, // Ube Frappe (175) + Red Velvet Muffin x2 (140 = 280? Wait, fix)
    items: [
      OrderItem(
        name: 'Ube Delight Frappe',
        quantity: 1,
        size: '22oz',
        price: 175,
      ),
      OrderItem(
        name: 'Red Velvet Cream Cheese Muffin',
        quantity: 2,
        price: 140,
      ),
    ],
  ),
];

/// Mock menu items for inventory management
final List<InventoryItem> mockInventoryItems = [
  InventoryItem(id: 'c001', name: 'Americano', category: 'Coffee', price: 110, isAvailable: true),
  InventoryItem(id: 'c002', name: 'Caramel Macchiato', category: 'Coffee', price: 167, isAvailable: true),
  InventoryItem(id: 'c003', name: 'Café Latte', category: 'Coffee', price: 130, isAvailable: true),
  InventoryItem(id: 'c004', name: 'Cappuccino', category: 'Coffee', price: 130, isAvailable: true),
  InventoryItem(id: 'c005', name: 'Spanish Latte', category: 'Coffee', price: 145, isAvailable: false),
  InventoryItem(id: 'f001', name: 'Strawberry Frappe', category: 'Frappe', price: 175, isAvailable: true),
  InventoryItem(id: 'f002', name: 'Blackforest Frappe', category: 'Frappe', price: 175, isAvailable: true),
  InventoryItem(id: 'f003', name: 'Ube Delight Frappe', category: 'Frappe', price: 175, isAvailable: true),
  InventoryItem(id: 'f004', name: 'Walnut Frappe', category: 'Frappe', price: 175, isAvailable: false),
  InventoryItem(id: 'f005', name: 'Mango Frappe', category: 'Frappe', price: 175, isAvailable: true),
  InventoryItem(id: 'm001', name: 'Wintermelon Milk Tea', category: 'Milk Tea', price: 120, isAvailable: true),
  InventoryItem(id: 'm002', name: 'Hokkaido Milk Tea', category: 'Milk Tea', price: 120, isAvailable: true),
  InventoryItem(id: 'm003', name: 'Nutella Milk Tea', category: 'Milk Tea', price: 120, isAvailable: true),
  InventoryItem(id: 'm004', name: 'Okinawa Milk Tea', category: 'Milk Tea', price: 120, isAvailable: false),
  InventoryItem(id: 'm005', name: 'Sakura Strawberry Milk Tea', category: 'Milk Tea', price: 120, isAvailable: true),
  InventoryItem(id: 'p001', name: 'Burnt Basque Cheesecake', category: 'Pastry', price: 220, isAvailable: true),
  InventoryItem(id: 'p002', name: 'Ube Cheese Muffin', category: 'Pastry', price: 140, isAvailable: true),
  InventoryItem(id: 'p003', name: 'Red Velvet Cream Cheese Muffin', category: 'Pastry', price: 140, isAvailable: true),
  InventoryItem(id: 'p004', name: 'Walnut Brownies', category: 'Pastry', price: 130, isAvailable: true),
  InventoryItem(id: 'p005', name: 'Croissant', category: 'Pastry', price: 110, isAvailable: true),
];

/// Helper to get categories
List<String> get inventoryCategories => ['Coffee', 'Frappe', 'Milk Tea', 'Pastry'];

/// Helper to filter items by category
List<InventoryItem> getItemsByCategory(String category) {
  return mockInventoryItems.where((item) => item.category == category).toList();
}