import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/order_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Stream all active Cafeteria Shops
  Stream<QuerySnapshot> getShopsStream() {
    return _db.collection('shops').snapshots();
  }

  // Stream Menu Items for a specific shop
  Stream<QuerySnapshot> getMenuItemsStream(String shopId) {
    return _db
        .collection('shops')
        .doc(shopId)
        .collection('menuItems')
        .snapshots();
  }

  // Place Order in Firestore with atomic token counter
  Future<void> placeOrder(OrderModel order) async {
    final orderRef = _db.collection('orders').doc();
    final counterRef = _db.collection('counters').doc('order_token');

    await _db.runTransaction((transaction) async {
      final counterSnapshot = await transaction.get(counterRef);
      int currentToken = 100;

      if (counterSnapshot.exists && counterSnapshot.data() != null) {
        currentToken = (counterSnapshot.data()!['lastToken'] ?? 100) + 1;
      }

      transaction.set(counterRef, {'lastToken': currentToken});

      final orderData = order.toMap();
      orderData['tokenNumber'] = currentToken;

      transaction.set(orderRef, orderData);
    });
  }

  // Stream Real-time Kitchen Orders for Vendor
  Stream<List<OrderModel>> getVendorOrdersStream(String shopId) {
    return _db
        .collection('orders')
        .where('shopId', isEqualTo: shopId)
        .where('status', whereIn: ['placed', 'preparing', 'ready'])
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => OrderModel.fromDocument(doc)).toList(),
        );
  }

  // Update Order Status (e.g. placed -> preparing -> ready -> completed)
  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    await _db.collection('orders').doc(orderId).update({
      'status': newStatus,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // Stream Student Active Orders
  Stream<List<OrderModel>> getStudentOrdersStream(String studentId) {
    return _db
        .collection('orders')
        .where('studentId', isEqualTo: studentId)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => OrderModel.fromDocument(doc)).toList(),
        );
  }
}
