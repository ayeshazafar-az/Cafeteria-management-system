import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String name;
  final double price;
  int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    this.quantity = 1,
  });
}

class CartProvider extends ChangeNotifier {
  String? _currentShopId;
  String? _currentShopName;
  final Map<String, CartItem> _items = {};

  String? get currentShopId => _currentShopId;
  String? get currentShopName => _currentShopName;
  Map<String, CartItem> get items => _items;

  int get totalItemCount {
    return _items.values.fold(0, (sum, item) => sum + item.quantity);
  }

  double get totalAmount {
    double total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void addItem({
    required String shopId,
    required String shopName,
    required String itemId,
    required String name,
    required double price,
  }) {
    // Clear cart if student orders from a different stall
    if (_currentShopId != null && _currentShopId != shopId) {
      _items.clear();
    }

    _currentShopId = shopId;
    _currentShopName = shopName;

    if (_items.containsKey(itemId)) {
      _items[itemId]!.quantity += 1;
    } else {
      _items[itemId] = CartItem(id: itemId, name: name, price: price);
    }
    notifyListeners();
  }

  void removeItem(String itemId) {
    if (!_items.containsKey(itemId)) return;
    if (_items[itemId]!.quantity > 1) {
      _items[itemId]!.quantity -= 1;
    } else {
      _items.remove(itemId);
    }
    if (_items.isEmpty) {
      _currentShopId = null;
      _currentShopName = null;
    }
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    _currentShopId = null;
    _currentShopName = null;
    notifyListeners();
  }
}
