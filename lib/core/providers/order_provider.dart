import 'package:flutter/material.dart';
import '../services/local_storage_service.dart';
import '../utils/feedback_helper.dart';

class LocalOrderItem {
  final String name;
  final int quantity;
  final double price;

  const LocalOrderItem({
    required this.name,
    required this.quantity,
    required this.price,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'quantity': quantity,
    'price': price,
  };

  factory LocalOrderItem.fromJson(Map<String, dynamic> json) {
    return LocalOrderItem(
      name: json['name'] as String,
      quantity: json['quantity'] as int,
      price: (json['price'] as num).toDouble(),
    );
  }
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
  final int estimatedPrepMinutes;

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
    this.estimatedPrepMinutes = 15,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'tokenNumber': tokenNumber,
    'shopName': shopName,
    'studentName': studentName,
    'items': items.map((e) => e.toJson()).toList(),
    'totalAmount': totalAmount,
    'paymentMethod': paymentMethod,
    'specialInstructions': specialInstructions,
    'status': status,
    'createdAt': createdAt.toIso8601String(),
    'estimatedPrepMinutes': estimatedPrepMinutes,
  };

  factory LocalOrder.fromJson(Map<String, dynamic> json) {
    return LocalOrder(
      id: json['id'] as String,
      tokenNumber: json['tokenNumber'] as String,
      shopName: json['shopName'] as String,
      studentName: json['studentName'] as String,
      items: (json['items'] as List<dynamic>)
          .map(
            (e) => LocalOrderItem.fromJson(Map<String, dynamic>.from(e as Map)),
          )
          .toList(),
      totalAmount: (json['totalAmount'] as num).toDouble(),
      paymentMethod: json['paymentMethod'] as String,
      specialInstructions: json['specialInstructions'] as String? ?? '',
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      estimatedPrepMinutes: json['estimatedPrepMinutes'] as int? ?? 15,
    );
  }
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
      estimatedPrepMinutes: 12,
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
      createdAt: DateTime.now().subtract(const Duration(minutes: 2)),
      estimatedPrepMinutes: 10,
    ),
  ];

  OrderProvider() {
    loadPersistedOrders();
  }

  List<LocalOrder> get activeOrders =>
      _orders.where((order) => order.status != 'completed').toList();

  List<LocalOrder> get allOrders => List.unmodifiable(_orders);

  Future<void> loadPersistedOrders() async {
    final savedToken = await LocalStorageService.loadInt(
      LocalStorageService.lastTokenKey,
    );
    if (savedToken != null) {
      _lastTokenNumber = savedToken;
    }

    final savedList = await LocalStorageService.loadJsonList(
      LocalStorageService.ordersKey,
    );
    if (savedList != null) {
      _orders
        ..clear()
        ..addAll(savedList.map(LocalOrder.fromJson));
      notifyListeners();
    }
  }

  Future<void> _persistOrders() async {
    await LocalStorageService.saveInt(
      LocalStorageService.lastTokenKey,
      _lastTokenNumber,
    );
    await LocalStorageService.saveJsonList(
      LocalStorageService.ordersKey,
      _orders.map((o) => o.toJson()).toList(),
    );
  }

  String placeOrder({
    required String shopName,
    required String studentName,
    required List<LocalOrderItem> items,
    required double totalAmount,
    required String paymentMethod,
    required String specialInstructions,
    int estimatedPrepMinutes = 15,
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
      estimatedPrepMinutes: estimatedPrepMinutes,
    );

    _orders.insert(0, newOrder);
    _persistOrders();
    notifyListeners();
    return tokenStr;
  }

  void updateOrderStatus(String orderId, String newStatus) {
    final index = _orders.indexWhere((order) => order.id == orderId);
    if (index != -1) {
      _orders[index].status = newStatus;

      if (newStatus == 'ready') {
        FeedbackHelper.triggerOrderReadyFeedback();
      }

      _persistOrders();
      notifyListeners();
    }
  }
}
