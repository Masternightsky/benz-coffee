import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/order.dart';
import '../data/mock_data.dart';
import '../widgets/order_card.dart';
import '../theme/app_theme.dart';

/// Tab for managing incoming orders
class OrderManagementTab extends StatefulWidget {
  const OrderManagementTab({super.key});

  @override
  State<OrderManagementTab> createState() => _OrderManagementTabState();
}

class _OrderManagementTabState extends State<OrderManagementTab> {
  List<Order> _orders = [];
  String _filterStatus = 'all'; // 'all', 'pending', 'paid'

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  void _loadOrders() {
    _orders = List.from(mockOrders);
  }

  void _updateOrderStatus(Order order, OrderStatus newStatus) {
    setState(() {
      final index = _orders.indexWhere((o) => o.id == order.id);
      if (index != -1) {
        _orders[index] = order.copyWith(status: newStatus);
      }
    });
    // NO SNACKBAR - removed
    HapticFeedback.mediumImpact();
  }

  // Remove order from the list
  void _removeOrder(Order order) {
    setState(() {
      _orders.removeWhere((o) => o.id == order.id);
    });
    HapticFeedback.lightImpact();
    // NO SNACKBAR - removed
  }

  void _simulateNewOrder() {
    final newOrderNumber = 'BC-${1000 + _orders.length + 1}';
    final newOrder = Order(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      orderNumber: newOrderNumber,
      timestamp: DateTime.now(),
      status: OrderStatus.pending,
      totalAmount: 305,
      items: [
        OrderItem(
          name: 'Café Latte',
          quantity: 1,
          size: '16oz',
          customization: 'Hot',
          price: 130,
        ),
        OrderItem(
          name: 'Mango Frappe',
          quantity: 1,
          size: '22oz',
          price: 175,
        ),
      ],
    );

    setState(() {
      _orders.insert(0, newOrder);
    });
    // NO SNACKBAR - removed
    HapticFeedback.heavyImpact();
  }

  List<Order> get _filteredOrders {
    switch (_filterStatus) {
      case 'pending':
        return _orders.where((o) => o.status == OrderStatus.pending).toList();
      case 'paid':
        return _orders.where((o) => o.status == OrderStatus.paid).toList();
      default:
        return _orders;
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredOrders = _filteredOrders;
    final pendingCount = _orders.where((o) => o.status == OrderStatus.pending).length;
    final paidCount = _orders.where((o) => o.status == OrderStatus.paid).length;

    return Column(
      children: [
        // Filter chips
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              // Simulate Order Button
              Container(
                decoration: BoxDecoration(
                  color: AppTheme.accent,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: IconButton(
                  onPressed: _simulateNewOrder,
                  icon: const Icon(Icons.add_rounded, color: AppTheme.primaryDark),
                  tooltip: 'Simulate New Order',
                ),
              ),
              const SizedBox(width: 12),
              // Filter chips
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      FilterChip(
                        label: Text('All (${_orders.length})'),
                        selected: _filterStatus == 'all',
                        onSelected: (_) => setState(() => _filterStatus = 'all'),
                        backgroundColor: AppTheme.surface,
                        selectedColor: AppTheme.primary.withOpacity(0.2),
                        checkmarkColor: AppTheme.primary,
                      ),
                      const SizedBox(width: 8),
                      FilterChip(
                        label: Text('Pending Payment ($pendingCount)'),
                        selected: _filterStatus == 'pending',
                        onSelected: (_) => setState(() => _filterStatus = 'pending'),
                        backgroundColor: AppTheme.surface,
                        selectedColor: AppTheme.statusPending.withOpacity(0.2),
                        labelStyle: TextStyle(
                          color: _filterStatus == 'pending'
                              ? AppTheme.statusPending
                              : null,
                        ),
                      ),
                      const SizedBox(width: 8),
                      FilterChip(
                        label: Text('Paid ($paidCount)'),
                        selected: _filterStatus == 'paid',
                        onSelected: (_) => setState(() => _filterStatus = 'paid'),
                        backgroundColor: AppTheme.surface,
                        selectedColor: AppTheme.statusPaid.withOpacity(0.2),
                        labelStyle: TextStyle(
                          color: _filterStatus == 'paid'
                              ? AppTheme.statusPaid
                              : null,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // Orders List
        Expanded(
          child: filteredOrders.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: filteredOrders.length,
                  itemBuilder: (context, index) {
                    final order = filteredOrders[index];
                    return OrderCard(
                      order: order,
                      onStatusUpdate: (newStatus) => _updateOrderStatus(order, newStatus),
                      onRemove: order.status == OrderStatus.paid
                          ? () => _removeOrder(order)
                          : null,
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    String message;
    String subMessage;

    switch (_filterStatus) {
      case 'pending':
        message = 'No Pending Orders';
        subMessage = 'All orders have been paid';
        break;
      case 'paid':
        message = 'No Paid Orders';
        subMessage = 'Paid orders waiting for pickup will appear here';
        break;
      default:
        message = 'No Orders Yet';
        subMessage = 'New orders will appear here automatically';
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 80,
            color: AppTheme.textLight,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: AppTheme.headingMedium,
          ),
          const SizedBox(height: 8),
          Text(
            subMessage,
            style: AppTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          if (_filterStatus != 'all')
            ElevatedButton(
              onPressed: () => setState(() => _filterStatus = 'all'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
              ),
              child: const Text('View All Orders'),
            ),
        ],
      ),
    );
  }
}