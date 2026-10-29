import 'package:flutter/material.dart';

class LocalOrderItem {
  final String name;
  final int quantity;
  final double price;

  const LocalOrderItem({
    required this.name,
    required this.quantity,
    required this.price,
  });
}

class LocalOrder {
  final String id;
  final String tokenNumber;
  final String shopName;
  final String studentName;
  final List<LocalOrderItem> items;
  final double totalAmount;
  final String paymentMethod;
  final String specialInstructions;
  String status; // 'placed', 'preparing', 'ready', 'completed'
  final DateTime createdAt;

  LocalOrder({
    required this.id,
    required this.tokenNumber,
    required this.shopName,
    required this.studentName,
    required this.items,
    required this.totalAmount,
    required this.paymentMethod,
    required this.specialInstructions,
    required this.status,
    required this.createdAt,
  });
}

class OrderProvider extends ChangeNotifier {
  int _lastTokenNumber = 104;

  final List<LocalOrder> _orders = [
    LocalOrder(
      id: 'ord_104',
      tokenNumber: '#104',
      shopName: 'Central Fast Food',
      studentName: 'Ayesha Zafar',
      items: const [
        LocalOrderItem(name: 'Zinger Burger', quantity: 2, price: 350.0),
        LocalOrderItem(name: 'Masala Fries', quantity: 1, price: 150.0),
      ],
      totalAmount: 850.0,
      paymentMethod: 'Cash on Pickup',
      specialInstructions: 'Extra spicy fries',
      status: 'preparing',
      createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
    LocalOrder(
      id: 'ord_103',
      tokenNumber: '#103',
      shopName: 'Central Fast Food',
      studentName: 'Ali Khan',
      items: const [
        LocalOrderItem(name: 'Club Sandwich', quantity: 1, price: 280.0),
      ],
      totalAmount: 280.0,
      paymentMethod: 'Online Payment',
      specialInstructions: '',
      status: 'placed',
      createdAt: DateTime.now().subtract(const Duration(minutes: 10)),
    ),
  ];

  List<LocalOrder> get activeOrders =>
      _orders.where((order) => order.status != 'completed').toList();

  List<LocalOrder> get allOrders => List.unmodifiable(_orders);

  String placeOrder({
    required String shopName,
    required String studentName,
    required List<LocalOrderItem> items,
    required double totalAmount,
    required String paymentMethod,
    required String specialInstructions,
  }) {
    _lastTokenNumber++;
    final tokenStr = '#$_lastTokenNumber';
    final newOrder = LocalOrder(
      id: 'ord_$_lastTokenNumber',
      tokenNumber: tokenStr,
      shopName: shopName,
      studentName: studentName,
      items: items,
      totalAmount: totalAmount,
      paymentMethod: paymentMethod,
      specialInstructions: specialInstructions,
      status: 'placed',
      createdAt: DateTime.now(),
    );

    _orders.insert(0, newOrder);
    notifyListeners();
    return tokenStr;
  }

  void updateOrderStatus(String orderId, String newStatus) {
    final index = _orders.indexWhere((order) => order.id == orderId);
    if (index != -1) {
      _orders[index].status = newStatus;
      notifyListeners();
    }
  }
}