import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/cart_item_widget.dart';

/// Cart screen showing all added items, totals, and order placement.
class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.navBar,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Your Order'),
      ),
      body: cart.isEmpty ? _buildEmptyCart(context) : _buildCartContent(context, cart),
    );
  }

  // ── Empty Cart State ────────────────────────────────────────────

  Widget _buildEmptyCart(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              size: 80,
              color: AppTheme.textLight,
            ),
            const SizedBox(height: 20),
            Text(
              'Your cart is empty',
              style: AppTheme.headingLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Browse items and add something to get started.',
              style: AppTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pushNamed('/menu'),
              child: const Text('Browse Menu'),
            ),
          ],
        ),
      ),
    );
  }

  // ── Cart Content ────────────────────────────────────────────────

  Widget _buildCartContent(BuildContext context, CartProvider cart) {
    return Column(
      children: [
        // ── Items List ────────────────────────────────────────────
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.only(top: 12, bottom: 8),
            itemCount: cart.items.length,
            itemBuilder: (context, index) {
              return CartItemWidget(
                cartItem: cart.items[index],
                index: index,
                onIncrease: () => context.read<CartProvider>().increaseQuantity(index),
                onDecrease: () => context.read<CartProvider>().decreaseQuantity(index),
                onRemove: () => context.read<CartProvider>().removeItem(index),
              );
            },
          ),
        ),

        // ── Summary + Buttons ─────────────────────────────────────
        Container(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
          decoration: BoxDecoration(
            color: AppTheme.cardColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primary.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Column(
            children: [
              // Summary card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.navBar,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    _SummaryRow(
                      label: 'Subtotal',
                      value: '₱${cart.subtotal.toStringAsFixed(0)}',
                      isSmall: true,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Pay at the counter after placing',
                      style: TextStyle(
                        color: AppTheme.accentLight,
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    Divider(
                      color: Colors.white.withOpacity(0.15),
                      height: 20,
                    ),
                    _SummaryRow(
                      label: 'Total',
                      value: '₱${cart.total.toStringAsFixed(0)}',
                      isSmall: false,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Place Order button
              ElevatedButton(
                onPressed: () => _placeOrder(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accent,
                  foregroundColor: AppTheme.primaryDark,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  'Place Order',
                  style: AppTheme.labelLarge.copyWith(
                    color: AppTheme.primaryDark,
                    fontSize: 17,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Add More Items button
              OutlinedButton(
                onPressed: () => Navigator.of(context).pushNamed('/menu'),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppTheme.primary, width: 1.5),
                  minimumSize: const Size(double.infinity, 52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  'Add More Items',
                  style: AppTheme.bodyLarge.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _placeOrder(BuildContext context) {
    HapticFeedback.heavyImpact();
    // Snapshot the order items before clearing the cart
    final cart = context.read<CartProvider>();
    final items = List.from(cart.items);
    final total = cart.total;
    final orderNumber = cart.placeOrder(); // Clears cart and returns order #

    Navigator.of(context).pushNamedAndRemoveUntil(
      '/receipt',
      (route) => route.settings.name == '/home',
      arguments: {
        'orderNumber': orderNumber,
        'items': items,
        'total': total,
      },
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isSmall;

  const _SummaryRow({
    required this.label,
    required this.value,
    required this.isSmall,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isSmall ? Colors.white70 : Colors.white,
            fontSize: isSmall ? 14 : 16,
            fontWeight: isSmall ? FontWeight.w400 : FontWeight.w700,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: isSmall ? AppTheme.accentLight : Colors.white,
            fontSize: isSmall ? 14 : 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
