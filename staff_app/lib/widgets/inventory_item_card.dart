import 'package:flutter/material.dart';
import '../models/menu_item.dart';
import '../theme/app_theme.dart';

/// Card widget for inventory items
/// Shows item name, category, price, and availability toggle
class InventoryItemCard extends StatelessWidget {
  final InventoryItem item;
  final VoidCallback onToggle;

  const InventoryItemCard({
    super.key,
    required this.item,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    // Get icon and color based on category - these are stable values
    final IconData categoryIcon = _getCategoryIcon(item.category);
    final Color categoryColor = _getCategoryColor(item.category);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(14),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Row(
        children: [
          // Category Icon - now using local variables
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: categoryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              categoryIcon,
              color: categoryColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),

          // Item Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: AppTheme.headingMedium.copyWith(fontSize: 14),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      item.category,
                      style: AppTheme.bodySmall.copyWith(fontSize: 11),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      width: 3,
                      height: 3,
                      decoration: BoxDecoration(
                        color: AppTheme.textLight,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '₱${item.price.toStringAsFixed(0)}',
                      style: AppTheme.price.copyWith(fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Compact Custom Switch
          GestureDetector(
            onTap: onToggle,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 120,
              height: 30,
              decoration: BoxDecoration(
                color: item.isAvailable
                    ? AppTheme.statusReady  // Green when IN STOCK
                    : const Color(0xFFEF4444),  // Red when OUT OF STOCK
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Sliding pill - covers text
                  AnimatedAlign(
                    duration: const Duration(milliseconds: 200),
                    alignment: item.isAvailable
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    curve: Curves.easeInOut,
                    child: Container(
                      width: 62,  // Covers text on opposite side
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 2,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Text labels
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Left side text
                        SizedBox(
                          width: 60,
                          child: Center(
                            child: Text(
                              'IN STOCK',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 7,
                                fontWeight: FontWeight.w800,
                                color: item.isAvailable
                                    ? Colors.white
                                    : Colors.white.withOpacity(0.35),
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                        ),
                        // Right side text
                        SizedBox(
                          width: 60,
                          child: Center(
                            child: Text(
                              'NO STOCK',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 7,
                                fontWeight: FontWeight.w800,
                                color: !item.isAvailable
                                    ? Colors.white
                                    : Colors.white.withOpacity(0.35),
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Coffee':
        return Icons.coffee_rounded;
      case 'Frappe':
        return Icons.local_drink_rounded;
      case 'Milk Tea':
        return Icons.emoji_food_beverage_rounded;
      case 'Pastry':
        return Icons.bakery_dining_rounded;
      default:
        return Icons.fastfood_rounded;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Coffee':
        return AppTheme.primary;
      case 'Frappe':
        return AppTheme.accent;
      case 'Milk Tea':
        return Colors.purple.shade300;
      case 'Pastry':
        return Colors.orange.shade400;
      default:
        return AppTheme.textSecondary;
    }
  }
}