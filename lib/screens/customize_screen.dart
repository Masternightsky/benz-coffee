import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/menu_item.dart';
import '../providers/cart_provider.dart';
import '../theme/app_theme.dart';

/// Customize screen: select size, quantity, then add to cart.
class CustomizeScreen extends StatefulWidget {
  const CustomizeScreen({super.key});

  @override
  State<CustomizeScreen> createState() => _CustomizeScreenState();
}

class _CustomizeScreenState extends State<CustomizeScreen> {
  String? _selectedSize;
  int _quantity = 1;
  String _selectedType = 'Hot'; // For Coffee items: 'Hot' or 'Iced'

  MenuItem get _item =>
      ModalRoute.of(context)!.settings.arguments as MenuItem;

  double get _unitPrice => _item.priceForSize(_selectedSize);
  double get _totalPrice => _unitPrice * _quantity;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final item = ModalRoute.of(context)?.settings.arguments as MenuItem?;
    if (item != null && item.availableSizes.isNotEmpty && _selectedSize == null) {
      _selectedSize = item.availableSizes.first;
    }
  }

  void _addToCart() {
    HapticFeedback.heavyImpact();
    final cart = context.read<CartProvider>();
    
    // Build customization string for the selected type (Coffee only)
    String customization = '';
    if (_item.category == 'Coffee') {
      customization = _selectedType;
    }
    
    for (int i = 0; i < _quantity; i++) {
      cart.addItem(
        _item,
        size: _selectedSize,
        instructions: customization,
      );
    }
    
    final snackBar = SnackBar(
      content: Text(
        '${_item.name} added to cart!',
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      backgroundColor: AppTheme.primary,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      duration: const Duration(seconds: 2),
    );
    
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    
    // Delay navigation slightly so snackbar is visible
    Future.delayed(const Duration(milliseconds: 100), () {
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    final item = _item;
    final isCoffee = item.category == 'Coffee';

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.navBar,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Customize'),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Item Header ──────────────────────────────────
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppTheme.cardColor,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: AppTheme.cardShadow,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Item Name
                        Text(item.name, style: AppTheme.headingLarge),
                        const SizedBox(height: 8),
                        // Description
                        Text(
                          item.description,
                          style: AppTheme.bodyMedium.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Price (shows updated price based on selected size)
                        Text(
                          '₱${_unitPrice.toStringAsFixed(0)}',
                          style: AppTheme.price.copyWith(fontSize: 24),
                        ),
                        const SizedBox(height: 16),
                        // No Image Available placeholder
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 40),
                          decoration: BoxDecoration(
                            color: AppTheme.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppTheme.accentLight,
                              width: 1,
                            ),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.image_not_supported_rounded,
                                color: AppTheme.textLight,
                                size: 48,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'NO IMAGE AVAILABLE',
                                style: AppTheme.bodySmall.copyWith(
                                  color: AppTheme.textLight,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ── Type Selector (Only for Coffee) ───────────────────────────
                  if (isCoffee) ...[
                    const SizedBox(height: 24),
                    Text('Type', style: AppTheme.headingMedium),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              HapticFeedback.selectionClick();
                              setState(() => _selectedType = 'Hot');
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              decoration: BoxDecoration(
                                color: _selectedType == 'Hot'
                                    ? AppTheme.primary
                                    : AppTheme.cardColor,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: _selectedType == 'Hot'
                                      ? AppTheme.primary
                                      : AppTheme.accentLight,
                                  width: 1.5,
                                ),
                                boxShadow: _selectedType == 'Hot'
                                    ? AppTheme.cardShadow
                                    : null,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.local_fire_department_rounded,
                                    color: _selectedType == 'Hot'
                                        ? Colors.white
                                        : AppTheme.primary,
                                    size: 24,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Hot',
                                    style: TextStyle(
                                      color: _selectedType == 'Hot'
                                          ? Colors.white
                                          : AppTheme.textPrimary,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              HapticFeedback.selectionClick();
                              setState(() => _selectedType = 'Iced');
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              decoration: BoxDecoration(
                                color: _selectedType == 'Iced'
                                    ? AppTheme.primary
                                    : AppTheme.cardColor,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: _selectedType == 'Iced'
                                      ? AppTheme.primary
                                      : AppTheme.accentLight,
                                  width: 1.5,
                                ),
                                boxShadow: _selectedType == 'Iced'
                                    ? AppTheme.cardShadow
                                    : null,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.ac_unit_rounded,
                                    color: _selectedType == 'Iced'
                                        ? Colors.white
                                        : AppTheme.primary,
                                    size: 24,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Iced',
                                    style: TextStyle(
                                      color: _selectedType == 'Iced'
                                          ? Colors.white
                                          : AppTheme.textPrimary,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],

                  // ── Size Selector (No price shown) ────────────────────────────
                  if (item.availableSizes.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    Text('Size', style: AppTheme.headingMedium),
                    const SizedBox(height: 12),
                    Row(
                      children: item.availableSizes.map((size) {
                        final isSelected = _selectedSize == size;
                        return Expanded(
                          child: GestureDetector(
                            onTap: () {
                              HapticFeedback.selectionClick();
                              setState(() => _selectedSize = size);
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              margin: const EdgeInsets.only(right: 8),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppTheme.primary
                                    : AppTheme.cardColor,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected
                                      ? AppTheme.primary
                                      : AppTheme.accentLight,
                                  width: 1.5,
                                ),
                                boxShadow:
                                    isSelected ? AppTheme.cardShadow : null,
                              ),
                              child: Text(
                                size,
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : AppTheme.textPrimary,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],

                  // ── Quantity ─────────────────────────────────────
                  const SizedBox(height: 24),
                  Text('Quantity', style: AppTheme.headingMedium),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: AppTheme.cardColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppTheme.accentLight, width: 1),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _QtyButton(
                          icon: Icons.remove_rounded,
                          onTap: () {
                            if (_quantity > 1) {
                              HapticFeedback.selectionClick();
                              setState(() => _quantity--);
                            }
                          },
                        ),
                        Container(
                          width: 60,
                          child: Text(
                            '$_quantity',
                            style: AppTheme.displayMedium,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        _QtyButton(
                          icon: Icons.add_rounded,
                          onTap: () {
                            HapticFeedback.selectionClick();
                            setState(() => _quantity++);
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          // ── Add to Cart Button ──────────────────────────────────
          Container(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
            decoration: BoxDecoration(
              color: AppTheme.background,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primary.withOpacity(0.08),
                  blurRadius: 12,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: _addToCart,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accent,
                foregroundColor: AppTheme.primaryDark,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Add to Cart',
                    style: AppTheme.labelLarge.copyWith(
                      color: AppTheme.primaryDark,
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryDark.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '₱${_totalPrice.toStringAsFixed(0)}',
                      style: TextStyle(
                        color: AppTheme.primaryDark,
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                      ),
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
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: AppTheme.primary, size: 24),
      ),
    );
  }
}