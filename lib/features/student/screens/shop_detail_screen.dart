import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/providers/cart_provider.dart';
import '../../../core/services/firestore_service.dart';
import 'student_shops_screen.dart';
import 'checkout_screen.dart';

class MenuItemModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final bool isAvailable;

  const MenuItemModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.isAvailable,
  });

  factory MenuItemModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return MenuItemModel(
      id: doc.id,
      name: data['name'] ?? 'Dish Item',
      description: data['description'] ?? '',
      price: (data['price'] ?? 0.0).toDouble(),
      isAvailable: data['isAvailable'] ?? true,
    );
  }
}

class ShopDetailScreen extends StatelessWidget {
  final Shop shop;

  const ShopDetailScreen({super.key, required this.shop});

  @override
  Widget build(BuildContext context) {
    final firestoreService = Provider.of<FirestoreService>(
      context,
      listen: false,
    );

    return Scaffold(
      appBar: AppBar(title: Text(shop.name)),
      body: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          return Column(
            children: [
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: firestoreService.getMenuItemsStream(shop.id),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Text('Error loading menu: ${snapshot.error}'),
                      );
                    }

                    final docs = snapshot.data?.docs ?? [];
                    final menuItems = docs
                        .map((doc) => MenuItemModel.fromDocument(doc))
                        .toList();

                    if (menuItems.isEmpty) {
                      return const Center(
                        child: Text(
                          'No menu items available for this stall yet.',
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: menuItems.length,
                      itemBuilder: (context, index) {
                        final item = menuItems[index];
                        final cartItem = cartProvider.items[item.id];
                        final count = cartItem?.quantity ?? 0;

                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.name,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        item.description,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'PKR ${item.price.toStringAsFixed(0)}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (!item.isAvailable)
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'Out of Stock',
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  )
                                else if (count == 0)
                                  ElevatedButton(
                                    onPressed: () {
                                      cartProvider.addItem(
                                        shopId: shop.id,
                                        shopName: shop.name,
                                        itemId: item.id,
                                        name: item.name,
                                        price: item.price,
                                      );
                                    },
                                    child: const Text('Add'),
                                  )
                                else
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(
                                          Icons.remove_circle_outline,
                                        ),
                                        onPressed: () {
                                          cartProvider.removeItem(item.id);
                                        },
                                      ),
                                      Text(
                                        '$count',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.add_circle_outline,
                                        ),
                                        onPressed: () {
                                          cartProvider.addItem(
                                            shopId: shop.id,
                                            shopName: shop.name,
                                            itemId: item.id,
                                            name: item.name,
                                            price: item.price,
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),

              // Bottom Sticky Cart Summary Bar
              if (cartProvider.totalItemCount > 0)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${cartProvider.totalItemCount} ${cartProvider.totalItemCount == 1 ? 'Item' : 'Items'} selected',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              'PKR ${cartProvider.totalAmount.toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CheckoutScreen(
                                  shopName: shop.name,
                                  cart: cartProvider.items.map(
                                    (key, item) => MapEntry(key, item.quantity),
                                  ),
                                  dynamicMenuItems: cartProvider.items.values
                                      .map(
                                        (e) => MenuItemModel(
                                          id: e.id,
                                          name: e.name,
                                          description: '',
                                          price: e.price,
                                          isAvailable: true,
                                        ),
                                      )
                                      .toList(),
                                  totalPrice: cartProvider.totalAmount,
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.shopping_bag),
                          label: const Text('Checkout'),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
