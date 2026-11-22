import 'package:flutter/material.dart';
import '../services/local_storage_service.dart';

class CartItem {
  final String id;
  final String shopId;
  final String shopName;
  final String name;
  final double price;
  int quantity;

  CartItem({
    required this.id,
    required this.shopId,
    required this.shopName,
    required this.name,
    required this.price,
    this.quantity = 1,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'shopId': shopId,
    'shopName': shopName,
    'name': name,
    'price': price,
    'quantity': quantity,
  };

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'] as String,
      shopId: json['shopId'] as String,
      shopName: json['shopName'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      quantity: json['quantity'] as int? ?? 1,
    );
  }
}

class CartProvider extends ChangeNotifier {
  final Map<String, CartItem> _items = {};

  CartProvider() {
    loadPersistedCart();
  }

  Map<String, CartItem> get items => Map.unmodifiable(_items);

  int get totalItemCount => totalItems;
  int get totalItems =>
      _items.values.fold<int>(0, (sum, item) => sum + item.quantity);

  double get totalAmount => _items.values.fold<double>(
    0.0,
    (sum, item) => sum + (item.price * item.quantity),
  );

  Future<void> loadPersistedCart() async {
    final savedList = await LocalStorageService.loadJsonList(
      LocalStorageService.cartItemsKey,
    );
    if (savedList != null) {
      _items.clear();
      for (final raw in savedList) {
        final item = CartItem.fromJson(raw);
        _items[item.id] = item;
      }
      notifyListeners();
    }
  }

  Future<void> _persistCart() async {
    await LocalStorageService.saveJsonList(
      LocalStorageService.cartItemsKey,
      _items.values.map((item) => item.toJson()).toList(),
    );
  }

  void addItem({
    required String shopId,
    required String shopName,
    required String itemId,
    required String name,
    required double price,
  }) {
    if (_items.containsKey(itemId)) {
      _items[itemId]!.quantity++;
    } else {
      _items[itemId] = CartItem(
        id: itemId,
        shopId: shopId,
        shopName: shopName,
        name: name,
        price: price,
        quantity: 1,
      );
    }
    _persistCart();
    notifyListeners();
  }

  void removeSingleItem(String itemId) {
    if (!_items.containsKey(itemId)) return;

    if (_items[itemId]!.quantity > 1) {
      _items[itemId]!.quantity--;
    } else {
      _items.remove(itemId);
    }
    _persistCart();
    notifyListeners();
  }

  void removeItem(String itemId) {
    _items.remove(itemId);
    _persistCart();
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    LocalStorageService.remove(LocalStorageService.cartItemsKey);
    notifyListeners();
  }
}
