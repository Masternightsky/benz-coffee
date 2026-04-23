import '../models/menu_item.dart';

/// Sample hardcoded menu data for Benz Coffee
/// TODO: Replace with API call to backend in production (Part 2)
final List<MenuItem> sampleMenuItems = [
  // ── COFFEE ────────────────────────────────────────────────────────
  // NOTE: Coffee items should have type selection (Iced/Hot) in the customize screen
  MenuItem(
    id: 'c001',
    name: 'Americano',
    description: 'Classic espresso with hot water – clean and bold',
    price: 110,
    category: 'Coffee',
    isBestSeller: true,
    availableSizes: ['16oz', '22oz'],
  ),
  MenuItem(
    id: 'c002',
    name: 'Caramel Macchiato',
    description: 'Vanilla syrup, steamed milk & caramel drizzle over espresso',
    price: 167,
    category: 'Coffee',
    isBestSeller: true,
    availableSizes: ['16oz', '22oz'],
  ),
  MenuItem(
    id: 'c003',
    name: 'Café Latte',
    description: 'Smooth espresso with velvety steamed milk',
    price: 130,
    category: 'Coffee',
    isBestSeller: false,
    availableSizes: ['16oz', '22oz'],
  ),
  MenuItem(
    id: 'c004',
    name: 'Cappuccino',
    description: 'Equal parts espresso, steamed milk, and foam',
    price: 130,
    category: 'Coffee',
    isBestSeller: false,
    availableSizes: ['16oz', '22oz'],
  ),
  MenuItem(
    id: 'c005',
    name: 'Spanish Latte',
    description: 'Creamy sweet milk meets bold espresso',
    price: 145,
    category: 'Coffee',
    isBestSeller: false,
    availableSizes: ['16oz', '22oz'],
  ),

  // ── FRAPPE ────────────────────────────────────────────────────────
  MenuItem(
    id: 'f001',
    name: 'Strawberry Frappe',
    description: 'Refreshing blended strawberry with cream',
    price: 175,
    category: 'Frappe',
    isBestSeller: true,
    availableSizes: ['16oz', '22oz'],
  ),
  MenuItem(
    id: 'f002',
    name: 'Blackforest Frappe',
    description: 'Chocolate and cherry blended frappe',
    price: 175,
    category: 'Frappe',
    isBestSeller: false,
    availableSizes: ['16oz', '22oz'],
  ),
  MenuItem(
    id: 'f003',
    name: 'Ube Delight Frappe',
    description: 'Creamy purple yam blended frappe',
    price: 175,
    category: 'Frappe',
    isBestSeller: false,
    availableSizes: ['16oz', '22oz'],
  ),
  MenuItem(
    id: 'f004',
    name: 'Walnut Frappe',
    description: 'Nutty walnut flavored blended frappe',
    price: 175,
    category: 'Frappe',
    isBestSeller: false,
    availableSizes: ['16oz', '22oz'],
  ),
  MenuItem(
    id: 'f005',
    name: 'Mango Frappe',
    description: 'Tropical mango blended frappe',
    price: 175,
    category: 'Frappe',
    isBestSeller: false,
    availableSizes: ['16oz', '22oz'],
  ),

  // ── MILK TEA ────────────────────────────────────────────────────────
  MenuItem(
    id: 'm001',
    name: 'Wintermelon Milk Tea',
    description: 'Smooth wintermelon flavor with creamy milk tea',
    price: 120,
    category: 'Milk Tea',
    isBestSeller: true,
    availableSizes: ['16oz', '22oz'],
  ),
  MenuItem(
    id: 'm002',
    name: 'Hokkaido Milk Tea',
    description: 'Rich and creamy Hokkaido flavor',
    price: 120,
    category: 'Milk Tea',
    isBestSeller: false,
    availableSizes: ['16oz', '22oz'],
  ),
  MenuItem(
    id: 'm003',
    name: 'Nutella Milk Tea',
    description: 'Hazelnut chocolate goodness in milk tea',
    price: 120,
    category: 'Milk Tea',
    isBestSeller: false,
    availableSizes: ['16oz', '22oz'],
  ),
  MenuItem(
    id: 'm004',
    name: 'Okinawa Milk Tea',
    description: 'Brown sugar caramel infused milk tea',
    price: 120,
    category: 'Milk Tea',
    isBestSeller: false,
    availableSizes: ['16oz', '22oz'],
  ),
  MenuItem(
    id: 'm005',
    name: 'Sakura Strawberry Milk Tea',
    description: 'Floral sakura with sweet strawberry notes',
    price: 120,
    category: 'Milk Tea',
    isBestSeller: false,
    availableSizes: ['16oz', '22oz'],
  ),

  // ── PASTRY ────────────────────────────────────────────────────────
  MenuItem(
    id: 'p001',
    name: 'Burnt Basque Cheesecake',
    description: 'Creamy cheesecake with caramelized burnt top',
    price: 220,
    category: 'Pastry',
    isBestSeller: true,
    availableSizes: [],
  ),
  MenuItem(
    id: 'p002',
    name: 'Ube Cheese Muffin',
    description: 'Moist ube muffin with cream cheese filling',
    price: 140,
    category: 'Pastry',
    isBestSeller: false,
    availableSizes: [],
  ),
  MenuItem(
    id: 'p003',
    name: 'Red Velvet Cream Cheese Muffin',
    description: 'Rich red velvet muffin with cream cheese swirl',
    price: 140,
    category: 'Pastry',
    isBestSeller: false,
    availableSizes: [],
  ),
  MenuItem(
    id: 'p004',
    name: 'Walnut Brownies',
    description: 'Fudgy brownies loaded with walnut chunks',
    price: 130,
    category: 'Pastry',
    isBestSeller: false,
    availableSizes: [],
  ),
];

/// Quick accessor for best sellers
List<MenuItem> get bestSellers =>
    sampleMenuItems.where((item) => item.isBestSeller).toList();

/// Get items filtered by category
List<MenuItem> itemsByCategory(String category) =>
    sampleMenuItems.where((item) => item.category == category).toList();

/// All unique categories in display order (Non-Coffee removed, Milk Tea added)
const List<String> menuCategories = [
  'Coffee',
  'Frappe',
  'Milk Tea',
  'Pastry',
];

/// Helper function to get price for size
double getPriceForSize(double basePrice, String size) {
  if (size == '22oz') {
    if (basePrice == 120) return 140; // Milk Tea 22oz price
    if (basePrice == 175) return 195; // Frappe 22oz price
    if (basePrice == 110) return 130; // Coffee 22oz price example
    if (basePrice == 130) return 150;
    if (basePrice == 145) return 165;
    if (basePrice == 167) return 187;
    return basePrice + 20;
  }
  return basePrice; // 16oz = base price
}