import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/menu_item.dart';
import '../theme/app_theme.dart';

/// Card widget displayed in the menu list/grid.
/// Shows item name, description, price, and an add (+) button.
class MenuItemCard extends StatelessWidget {
  final MenuItem item;
  final VoidCallback onTap;      // Opens customize screen
  final VoidCallback onAddQuick; // Quick add to cart (no customization)

  const MenuItemCard({
    super.key,
    required this.item,
    required this.onTap,
    required this.onAddQuick,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: AppTheme.cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: AppTheme.cardShadow,
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              // ── Item Icon ──────────────────────────────────────────
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _categoryIcon(item.category),
                  color: AppTheme.primary,
                  size: 28,
                ),
              ),
              const SizedBox(width: 14),
              // ── Item Info ──────────────────────────────────────────
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.name,
                            style: AppTheme.headingMedium.copyWith(
                              fontSize: 15,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (item.isBestSeller)
                          Container(
                            margin: const EdgeInsets.only(left: 6),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.accentLight,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Best',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                                color: AppTheme.primaryDark,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.description,
                      style: AppTheme.bodySmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '₱${item.price.toStringAsFixed(0)}',
                      style: AppTheme.price,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              // ── Add Button ─────────────────────────────────────────
              GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  // If item has sizes, open customization; else quick-add
                  if (item.availableSizes.isNotEmpty) {
                    onTap();
                  } else {
                    onAddQuick();
                  }
                },
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppTheme.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.add_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ),
            ],
          ),
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

/// Compact horizontal card used in the Best Sellers section on Home.
class BestSellerCard extends StatelessWidget {
  final MenuItem item;
  final VoidCallback onTap;

  const BestSellerCard({
    super.key,
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 130,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: AppTheme.cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: AppTheme.cardShadow,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppTheme.surface,
                shape: BoxShape.circle,
              ),
              child: Icon(
                _categoryIcon(item.category),
                color: AppTheme.primary,
                size: 28,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                item.name,
                style: AppTheme.bodyLarge.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '₱${item.price.toStringAsFixed(0)}',
              style: AppTheme.price.copyWith(fontSize: 13),
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
