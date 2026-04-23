import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../data/sample_menu_data.dart';
import '../models/menu_item.dart';
import '../providers/cart_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/menu_item_card.dart';

/// Menu screen showing items grouped by category tabs at the top.
class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late TabController _tabController;
  int _selectedTabIndex = 0;
  
  // Keep the state of the menu screen when navigating away
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: menuCategories.length,
      vsync: this,
    );
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() => _selectedTabIndex = _tabController.index);
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Only set initial category if coming from home screen chip
    final category = ModalRoute.of(context)?.settings.arguments as String?;
    if (category != null && _selectedTabIndex == 0) {
      final idx = menuCategories.indexOf(category);
      if (idx >= 0 && idx != _selectedTabIndex) {
        _tabController.animateTo(idx);
        _selectedTabIndex = idx;
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    final cartCount = context.watch<CartProvider>().totalItemCount;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.navBar,
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Menu'),
        actions: [
          // Cart button with badge
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_rounded, color: Colors.white),
                onPressed: () => Navigator.of(context).pushNamed('/cart'),
              ),
              if (cartCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: AppTheme.awaitingPayment,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '$cartCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Container(
            color: AppTheme.navBar,
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              indicatorColor: AppTheme.accentLight,
              indicatorWeight: 3,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white54,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
              tabs: menuCategories
                  .map((cat) => Tab(text: cat))
                  .toList(),
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: menuCategories.map((category) {
          return _CategoryItemList(category: category);
        }).toList(),
      ),
    );
  }
}

/// Shows the list of menu items for a given category
class _CategoryItemList extends StatelessWidget {
  final String category;

  const _CategoryItemList({required this.category});

  void _quickAdd(BuildContext context, MenuItem item) {
    HapticFeedback.mediumImpact();
    context.read<CartProvider>().addItem(item);
    
    final snackBar = SnackBar(
      content: Text(
        '${item.name} added to cart!',
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      backgroundColor: AppTheme.primary,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      duration: const Duration(seconds: 2),
      action: SnackBarAction(
        label: 'View Cart',
        textColor: AppTheme.accentLight,
        onPressed: () {
          // Hide snackbar before navigating
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          Navigator.of(context).pushNamed('/cart');
        },
      ),
    );
    
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    final items = itemsByCategory(category);

    if (items.isEmpty) {
      return Center(
        child: Text(
          'No items in this category yet.',
          style: AppTheme.bodyMedium,
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 12),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return MenuItemCard(
          item: item,
          onTap: () => Navigator.of(context).pushNamed(
            '/customize',
            arguments: item,
          ),
          onAddQuick: () => _quickAdd(context, item),
        );
      },
    );
  }
}