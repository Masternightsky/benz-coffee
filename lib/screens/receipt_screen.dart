import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/cart_item.dart';
import '../theme/app_theme.dart';
import 'dart:async';

/// Receipt/confirmation screen shown after placing an order.
class ReceiptScreen extends StatefulWidget {
  const ReceiptScreen({super.key});

  @override
  State<ReceiptScreen> createState() => _ReceiptScreenState();
}

class _ReceiptScreenState extends State<ReceiptScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _checkController;
  late Animation<double> _checkScale;
  late Animation<double> _checkFade;
  int _countdown = 60;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _checkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _checkScale = CurvedAnimation(
      parent: _checkController,
      curve: Curves.elasticOut,
    );
    _checkFade = CurvedAnimation(
      parent: _checkController,
      curve: Curves.easeIn,
    );
    _checkController.forward();

    // Start countdown timer
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown > 1) {
        setState(() {
          _countdown--;
        });
      } else {
        _timer.cancel();
        if (mounted) {
          _returnToWelcome();
        }
      }
    });
  }

  @override
  void dispose() {
    _checkController.dispose();
    _timer.cancel();
    super.dispose();
  }

  void _returnToWelcome() {
    HapticFeedback.lightImpact();
    // Clear any remaining navigation stack and go to welcome screen
    Navigator.of(context).pushNamedAndRemoveUntil(
      '/',
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final orderNumber = args['orderNumber'] as String;
    final items = (args['items'] as List<dynamic>).cast<CartItem>();
    final total = args['total'] as double;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 20),

              // Success Icon
              ScaleTransition(
                scale: _checkScale,
                child: FadeTransition(
                  opacity: _checkFade,
                  child: Container(
                    width: 88,
                    height: 88,
                    decoration: const BoxDecoration(
                      color: AppTheme.success,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 52,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
              Text('Order Placed!', style: AppTheme.displayMedium),
              const SizedBox(height: 6),
              Text(
                'Please proceed to the counter to pay',
                style: AppTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 28),

              // Order Receipt Card
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppTheme.cardColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: AppTheme.cardShadow,
                ),
                child: Column(
                  children: [
                    // Order Number
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                      child: Column(
                        children: [
                          Text(
                            'ORDER NUMBER',
                            style: GoogleFonts.lato(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textLight,
                              letterSpacing: 2,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(orderNumber, style: AppTheme.orderNumber),
                        ],
                      ),
                    ),

                    // Dashed divider
                    _DashedDivider(),

                    // Items list
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      child: Column(
                        children: items.map((cartItem) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.coffee_rounded,
                                  color: AppTheme.primary,
                                  size: 18,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        cartItem.item.name,
                                        style: AppTheme.bodyLarge.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      if (cartItem.sizeLabel.isNotEmpty)
                                        Text(
                                          '${cartItem.sizeLabel} × ${cartItem.quantity}',
                                          style: AppTheme.bodySmall,
                                        ),
                                    ],
                                  ),
                                ),
                                Text(
                                  '₱${cartItem.totalPrice.toStringAsFixed(0)}',
                                  style: AppTheme.price,
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                    // Total
                    _DashedDivider(),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total',
                            style: AppTheme.headingMedium,
                          ),
                          Text(
                            '₱${total.toStringAsFixed(0)}',
                            style: AppTheme.price.copyWith(fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Status Badge
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.awaitingPayment.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppTheme.awaitingPayment.withOpacity(0.4),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.schedule_rounded,
                          color: AppTheme.awaitingPayment,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Awaiting Payment',
                          style: GoogleFonts.lato(
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                            color: AppTheme.awaitingPayment,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Show this order number at the counter to pay.',
                      style: AppTheme.bodyMedium.copyWith(
                        color: AppTheme.awaitingPayment.withOpacity(0.8),
                        fontSize: 13,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // Back to Home Button
              ElevatedButton(
                onPressed: _returnToWelcome,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  minimumSize: const Size(double.infinity, 56),
                ),
                child: const Text('Back to Home'),
              ),

              const SizedBox(height: 12),
              
              // Animated Countdown Timer
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppTheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.timer_rounded,
                      size: 16,
                      color: AppTheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Returning to welcome screen in ',
                      style: AppTheme.bodySmall.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppTheme.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '$_countdown',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    Text(
                      ' seconds...',
                      style: AppTheme.bodySmall.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

/// A horizontal dashed line divider
class _DashedDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: LayoutBuilder(
        builder: (context, constraints) {
          const dashWidth = 6.0;
          const dashSpace = 4.0;
          final dashCount =
              (constraints.maxWidth / (dashWidth + dashSpace)).floor();
          return Row(
            children: List.generate(dashCount, (_) {
              return Container(
                width: dashWidth,
                height: 1.5,
                margin: const EdgeInsets.only(right: dashSpace),
                color: AppTheme.accentLight,
              );
            }),
          );
        },
      ),
    );
  }
}