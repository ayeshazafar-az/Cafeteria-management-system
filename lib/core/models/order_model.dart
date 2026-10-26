import 'package:cloud_firestore/cloud_firestore.dart';

class OrderItemModel {
  final String itemId;
  final String name;
  final int quantity;
  final double unitPrice;

  OrderItemModel({
    required this.itemId,
    required this.name,
    required this.quantity,
    required this.unitPrice,
  });

  Map<String, dynamic> toMap() {
    return {
      'itemId': itemId,
      'name': name,
      'quantity': quantity,
      'unitPrice': unitPrice,
    };
  }

  factory OrderItemModel.fromMap(Map<String, dynamic> map) {
    return OrderItemModel(
      itemId: map['itemId'] ?? '',
      name: map['name'] ?? '',
      quantity: map['quantity'] ?? 1,
      unitPrice: (map['unitPrice'] ?? 0.0).toDouble(),
    );
  }
}

class OrderModel {
  final String id;
  final int tokenNumber;
  final String studentId;
  final String studentName;
  final String shopId;
  final String shopName;
  final List<OrderItemModel> items;
  final String
  status; // 'placed', 'preparing', 'ready', 'completed', 'cancelled'
  final String paymentMethod; // 'cash', 'online'
  final String paymentStatus; // 'pending', 'paid'
  final double totalAmount;
  final String specialInstructions;
  final DateTime createdAt;

  OrderModel({
    required this.id,
    required this.tokenNumber,
    required this.studentId,
    required this.studentName,
    required this.shopId,
    required this.shopName,
    required this.items,
    required this.status,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.totalAmount,
    required this.specialInstructions,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'tokenNumber': tokenNumber,
      'studentId': studentId,
      'studentName': studentName,
      'shopId': shopId,
      'shopName': shopName,
      'items': items.map((i) => i.toMap()).toList(),
      'status': status,
      'paymentMethod': paymentMethod,
      'paymentStatus': paymentStatus,
      'totalAmount': totalAmount,
      'specialInstructions': specialInstructions,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory OrderModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return OrderModel(
      id: doc.id,
      tokenNumber: data['tokenNumber'] ?? 0,
      studentId: data['studentId'] ?? '',
      studentName: data['studentName'] ?? 'Student',
      shopId: data['shopId'] ?? '',
      shopName: data['shopName'] ?? 'Stall',
      items: (data['items'] as List<dynamic>? ?? [])
          .map((item) => OrderItemModel.fromMap(item as Map<String, dynamic>))
          .toList(),
      status: data['status'] ?? 'placed',
      paymentMethod: data['paymentMethod'] ?? 'cash',
      paymentStatus: data['paymentStatus'] ?? 'pending',
      totalAmount: (data['totalAmount'] ?? 0.0).toDouble(),
      specialInstructions: data['specialInstructions'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}
