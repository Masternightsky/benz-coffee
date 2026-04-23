import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../theme/app_theme.dart';

/// Widget representing a single item row inside the Cart screen.
class CartItemWidget extends StatelessWidget {
  final CartItem cartItem;
  final int index;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;
  final VoidCallback onRemove;

  const CartItemWidget({
    super.key,
    required this.cartItem,
    required this.index,
    required this.onIncrease,
    required this.onDecrease,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
            // ── Icon ───────────────────────────────────────────────
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.coffee_rounded,
                color: AppTheme.primary,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            // ── Info ───────────────────────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cartItem.item.name,
                    style: AppTheme.headingMedium.copyWith(fontSize: 15),
                  ),
                  if (cartItem.sizeLabel.isNotEmpty)
                    Text(
                      cartItem.sizeLabel,
                      style: AppTheme.bodySmall,
                    ),
                  if (cartItem.specialInstructions.isNotEmpty)
                    Text(
                      cartItem.specialInstructions,
                      style: AppTheme.bodySmall.copyWith(
                        fontStyle: FontStyle.italic,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  const SizedBox(height: 4),
                  Text(
                    '₱${cartItem.totalPrice.toStringAsFixed(0)}',
                    style: AppTheme.price,
                  ),
                ],
              ),
            ),
            // ── Qty Controls ───────────────────────────────────────
            Column(
              children: [
                // Remove button
                GestureDetector(
                  onTap: onRemove,
                  child: Icon(
                    Icons.close_rounded,
                    color: AppTheme.textLight,
                    size: 18,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _QtyButton(
                      icon: Icons.remove_rounded,
                      onTap: onDecrease,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        '${cartItem.quantity}',
                        style: AppTheme.headingMedium.copyWith(fontSize: 16),
                      ),
                    ),
                    _QtyButton(
                      icon: Icons.add_rounded,
                      onTap: onIncrease,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _QtyButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppTheme.accentLight, width: 1),
        ),
        child: Icon(icon, size: 16, color: AppTheme.primary),
      ),
    );
  }
}
