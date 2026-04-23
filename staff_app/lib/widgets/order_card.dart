import 'package:flutter/material.dart';
import '../models/order.dart';
import '../theme/app_theme.dart';

/// Card widget displaying a single order
/// Shows order number, items, total amount, timestamp, and status update dropdown
class OrderCard extends StatelessWidget {
  final Order order;
  final Function(OrderStatus) onStatusUpdate;
  final VoidCallback? onRemove;

  const OrderCard({
    super.key,
    required this.order,
    required this.onStatusUpdate,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Order Number, Time & Total Amount
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    order.orderNumber,
                    style: AppTheme.orderNumber,
                  ),
                ),
                const Spacer(),
                // Total Amount Badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.accent.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppTheme.accent.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.receipt_rounded,
                        size: 14,
                        color: AppTheme.accent,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '₱${order.totalAmount.toStringAsFixed(0)}',
                        style: AppTheme.price.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Time and Status Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Icon(
                  Icons.access_time_rounded,
                  size: 14,
                  color: AppTheme.textLight,
                ),
                const SizedBox(width: 4),
                Text(
                  order.formattedTime,
                  style: AppTheme.bodySmall,
                ),
                const Spacer(),
                // Status badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: order.status.color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: order.status.color.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: order.status.color,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        order.status.displayText,
                        style: TextStyle(
                          color: order.status.color,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 16, thickness: 1),

          // Items List
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: order.items.map((item) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    children: [
                      Icon(
                        _getItemIcon(item.name),
                        size: 16,
                        color: AppTheme.accent,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          item.displayString,
                          style: AppTheme.bodyMedium,
                        ),
                      ),
                      // Show individual item price
                      Text(
                        '₱${item.subtotal.toStringAsFixed(0)}',
                        style: AppTheme.bodySmall.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),

          const Divider(height: 8, thickness: 1),

          // Action Buttons Row - SAME SIZE for both buttons
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 14),
            child: Row(
              children: [
                // Mark as Paid button (only for pending orders)
                if (order.status == OrderStatus.pending)
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (order.status.next != null) {
                          onStatusUpdate(order.status.next!);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.accent, // Warm caramel color
                        foregroundColor: AppTheme.primaryDark,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.payment_rounded, size: 18),
                          SizedBox(width: 8),
                          Text('Mark as Paid'),
                        ],
                      ),
                    ),
                  ),

                // Complete Order button (only for paid orders) - SAME SIZE
                if (order.status == OrderStatus.paid && onRemove != null)
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _showRemoveConfirmation(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primary, // Deep espresso brown
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check_circle_rounded, size: 18),
                          SizedBox(width: 8),
                          Text('Complete Order'),
                        ],
                      ),
                    ),
                  ),

                // Paid confirmation badge (when already paid, no button)
                if (order.status == OrderStatus.paid && onRemove == null)
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: AppTheme.statusPaid.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppTheme.statusPaid.withOpacity(0.3),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.check_circle_rounded,
                            size: 18,
                            color: AppTheme.statusPaid,
                          ),
                          SizedBox(width: 8),
                          Text('Payment Confirmed'),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showRemoveConfirmation(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppTheme.cardColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header with X button in corner
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.check_circle_rounded,
                        color: AppTheme.primary,
                        size: 28,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Complete Order',
                        style: AppTheme.headingMedium,
                      ),
                    ],
                  ),
                  // X button to close
                  GestureDetector(
                    onTap: () => Navigator.pop(dialogContext),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppTheme.surface,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close_rounded,
                        size: 20,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Confirmation message
              Text(
                'Has order ${order.orderNumber} been picked up by the customer?',
                style: AppTheme.bodyMedium.copyWith(fontSize: 15),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'This will remove it from the active orders list.',
                style: AppTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              // Confirm button (green)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                    onRemove?.call();
                    // NO SNACKBAR - removed
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.statusReady,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Yes, Complete Order'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getItemIcon(String name) {
    if (name.contains('Latte') || name.contains('Macchiato')) {
      return Icons.coffee_rounded;
    } else if (name.contains('Frappe')) {
      return Icons.local_drink_rounded;
    } else if (name.contains('Tea')) {
      return Icons.emoji_food_beverage_rounded;
    } else {
      return Icons.bakery_dining_rounded;
    }
  }
}