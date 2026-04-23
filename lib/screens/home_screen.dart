import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/sample_menu_data.dart';
import '../theme/app_theme.dart';
import '../widgets/menu_item_card.dart';

/// Home screen showing the shop info, best sellers, and menu categories.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sellers = bestSellers;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.navBar,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
              onPressed: () {
                // Navigate back to welcome screen and clear navigation stack
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/',
                  (route) => false,
                );
              },
              tooltip: 'Back to Welcome',
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
            const SizedBox(width: 8),
            Text(
              'benz coffee',
              style: GoogleFonts.nunitoSans(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ],
        ),
        centerTitle: false,
      ),
      body: CustomScrollView(
        slivers: [
          // ── Content ─────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                // ── Best Sellers Section ─────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text('Best Sellers', style: AppTheme.headingLarge),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 150,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.only(left: 16),
                    itemCount: sellers.length,
                    itemBuilder: (context, index) {
                      final item = sellers[index];
                      return BestSellerCard(
                        item: item,
                        onTap: () => Navigator.of(context).pushNamed(
                          '/customize',
                          arguments: item,
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 28),

                // ── Menu Categories Section (ULTRA COMPACT) ──────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text('Menu Categories', style: AppTheme.headingLarge),
                ),
                const SizedBox(height: 8), // Tighter spacing
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 6,  // Very tight
                    mainAxisSpacing: 6,   // Very tight
                    childAspectRatio: 4.5, // Even shorter boxes
                    children: menuCategories.map((category) {
                      return _CategoryChip(
                        category: category,
                        onTap: () => Navigator.of(context).pushNamed(
                          '/menu',
                          arguments: category,
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Tappable category card on the home screen grid (COMPACT BOX, LARGER TEXT & ICON)
class _CategoryChip extends StatelessWidget {
  final String category;
  final VoidCallback onTap;

  const _CategoryChip({required this.category, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.cardColor,
          borderRadius: BorderRadius.circular(8), // Smaller radius
          boxShadow: AppTheme.cardShadow,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4), // Minimal padding
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center, // Center the content
          children: [
            Icon(
              _categoryIcon(category),
              color: AppTheme.primary,
              size: 28, // LARGER icon (was 16, now 28)
            ),
            const SizedBox(width: 8), // Slightly more spacing
            Flexible(
              child: Text(
                category,
                style: AppTheme.headingMedium.copyWith(
                  fontSize: 15, // LARGER text (was 11, now 15)
                  fontWeight: FontWeight.w700,
                ),
                maxLines: 1, // Single line
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _categoryIcon(String category) {
    switch (category) {
      case 'Coffee':
        return Icons.coffee_rounded;
      case 'Frappe':
        return Icons.local_drink_rounded;
      case 'Pastry':
        return Icons.bakery_dining_rounded;
      case 'Cakes':
        return Icons.cake_rounded;
      case 'Non-Coffee':
        return Icons.emoji_food_beverage_rounded;
      default:
        return Icons.fastfood_rounded;
    }
  }
}