import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Order status enum for type-safe status management
enum OrderStatus {
  pending,    // Pending Payment - Yellow
  paid;       // Paid - Blue

  /// Display text for the status
  String get displayText {
    switch (this) {
      case OrderStatus.pending:
        return 'Pending Payment';
      case OrderStatus.paid:
        return 'Paid';
    }
  }

  /// Color for the status badge
  Color get color {
    switch (this) {
      case OrderStatus.pending:
        return AppTheme.statusPending;
      case OrderStatus.paid:
        return AppTheme.statusPaid;
    }
  }

  /// Next status in workflow (for updating)
  OrderStatus? get next {
    switch (this) {
      case OrderStatus.pending:
        return OrderStatus.paid;
      case OrderStatus.paid:
        return null; // No next status - order is complete
    }
  }
}

/// Order model representing a customer order
class Order {
  final String id;
  final String orderNumber;
  final List<OrderItem> items;
  final DateTime timestamp;
  OrderStatus status;
  final double totalAmount; // ADDED: Total payment amount

  Order({
    required this.id,
    required this.orderNumber,
    required this.items,
    required this.timestamp,
    this.status = OrderStatus.pending,
    required this.totalAmount,
  });

  /// Format timestamp for display
  String get formattedTime {
    return '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
  }

  /// Get formatted date
  String get formattedDate {
    return '${timestamp.month}/${timestamp.day} ${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}';
  }

  /// Create a copy with updated status
  Order copyWith({OrderStatus? status, double? totalAmount}) {
    return Order(
      id: id,
      orderNumber: orderNumber,
      items: items,
      timestamp: timestamp,
      status: status ?? this.status,
      totalAmount: totalAmount ?? this.totalAmount,
    );
  }
}

/// Individual item within an order
class OrderItem {
  final String name;
  final int quantity;
  final String? size;
  final String? customization; // e.g., "Iced" or "Hot"
  final double price; // ADDED: Individual item price

  OrderItem({
    required this.name,
    required this.quantity,
    this.size,
    this.customization,
    required this.price,
  });

  /// Calculate subtotal for this item
  double get subtotal => price * quantity;

  /// Display string for the item (e.g., "Americano (Iced, 16oz) x2")
  String get displayString {
    String display = name;
    final List<String> modifiers = [];

    if (customization != null && customization!.isNotEmpty) {
      modifiers.add(customization!);
    }
    if (size != null && size!.isNotEmpty) {
      modifiers.add(size!);
    }

    if (modifiers.isNotEmpty) {
      display += ' (${modifiers.join(', ')})';
    }

    if (quantity > 1) {
      display += ' ×$quantity';
    }

    return display;
  }
}