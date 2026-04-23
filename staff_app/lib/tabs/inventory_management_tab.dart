import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/menu_item.dart';
import '../data/mock_data.dart';
import '../widgets/inventory_item_card.dart';
import '../theme/app_theme.dart';

/// Tab for managing menu item availability
class InventoryManagementTab extends StatefulWidget {
  const InventoryManagementTab({super.key});

  @override
  State<InventoryManagementTab> createState() => _InventoryManagementTabState();
}

class _InventoryManagementTabState extends State<InventoryManagementTab>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<InventoryItem> _items = [];
  String _searchQuery = '';
  
  // Track current category to force rebuild
  String _currentCategory = 'Coffee';

  @override
  void initState() {
    super.initState();
    _loadItems();
    _tabController = TabController(
      length: inventoryCategories.length,
      vsync: this,
    );
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {
          _currentCategory = inventoryCategories[_tabController.index];
        });
      }
    });
  }

  void _loadItems() {
    // Create a fresh copy of mock data
    _items = mockInventoryItems.map((item) => 
      InventoryItem(
        id: item.id,
        name: item.name,
        category: item.category,
        price: item.price,
        isAvailable: item.isAvailable,
      )
    ).toList();
  }

  void _toggleAvailability(InventoryItem item) {
    setState(() {
      final index = _items.indexWhere((i) => i.id == item.id);
      if (index != -1) {
        // Create a new item with toggled availability
        _items[index] = InventoryItem(
          id: _items[index].id,
          name: _items[index].name,
          category: _items[index].category,
          price: _items[index].price,
          isAvailable: !_items[index].isAvailable,
        );
      }
    });
    HapticFeedback.selectionClick();
  }

  List<InventoryItem> get _filteredItems {
    // Filter by current category
    List<InventoryItem> items = _items.where((item) => item.category == _currentCategory).toList();

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      items = items
          .where((item) =>
              item.name.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }

    return items;
  }

  int _getAvailableCount(String category) {
    return _items
        .where((item) => item.category == category && item.isAvailable)
        .length;
  }

  int _getTotalCount(String category) {
    return _items.where((item) => item.category == category).length;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search Bar
        Padding(
          padding: const EdgeInsets.all(16),
          child: Container(
            decoration: BoxDecoration(
              color: AppTheme.cardColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: AppTheme.cardShadow,
            ),
            child: TextField(
              onChanged: (value) => setState(() => _searchQuery = value),
              decoration: const InputDecoration(
                hintText: 'Search menu items...',
                prefixIcon: Icon(Icons.search_rounded, color: AppTheme.textLight),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 14),
                suffixIcon: null,
              ),
            ),
          ),
        ),

        // Category Tabs
        Container(
          color: AppTheme.background,
          child: TabBar(
            controller: _tabController,
            isScrollable: true,
            indicatorColor: AppTheme.accent,
            indicatorWeight: 3,
            labelColor: AppTheme.primary,
            unselectedLabelColor: AppTheme.textSecondary,
            labelStyle: const TextStyle(fontWeight: FontWeight.w700),
            onTap: (index) {
              setState(() {
                _currentCategory = inventoryCategories[index];
              });
            },
            tabs: inventoryCategories.map((category) {
              final available = _getAvailableCount(category);
              final total = _getTotalCount(category);
              return Tab(
                child: Row(
                  children: [
                    Text(category),
                    const SizedBox(width: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.surface,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '$available/$total',
                        style: const TextStyle(fontSize: 11),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),

        // Items List - Simple ListView that rebuilds when _currentCategory changes
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: _filteredItems.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inventory_2_outlined,
                          size: 64,
                          color: AppTheme.textLight,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _searchQuery.isEmpty
                              ? 'No items in this category'
                              : 'No items match "$_searchQuery"',
                          style: AppTheme.bodyMedium,
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    key: ValueKey(_currentCategory), // Force rebuild when category changes
                    itemCount: _filteredItems.length,
                    itemBuilder: (context, index) {
                      final item = _filteredItems[index];
                      return InventoryItemCard(
                        key: ValueKey('${item.id}_${item.isAvailable}'), // Force rebuild on toggle
                        item: item,
                        onToggle: () => _toggleAvailability(item),
                      );
                    },
                  ),
          ),
        ),
      ],
    );
  }
}
