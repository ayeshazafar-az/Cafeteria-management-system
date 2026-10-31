import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/providers/cart_provider.dart';
import '../../../core/utils/page_transitions.dart';
import '../../../core/widgets/animated_cart_button.dart';
import 'checkout_screen.dart';
import 'student_shops_screen.dart';

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
}

class ShopDetailScreen extends StatefulWidget {
  final Shop shop;

  const ShopDetailScreen({super.key, required this.shop});

  @override
  State<ShopDetailScreen> createState() => _ShopDetailScreenState();
}

class _ShopDetailScreenState extends State<ShopDetailScreen> {
  final List<MenuItemModel> mockMenuItems = const [
    MenuItemModel(
      id: 'm1',
      name: 'Zinger Burger',
      description: 'Crispy fried chicken fillet with mayo & lettuce',
      price: 350.0,
      isAvailable: true,
    ),
    MenuItemModel(
      id: 'm2',
      name: 'Club Sandwich',
      description: 'Layered chicken, egg, and cheese toasties',
      price: 280.0,
      isAvailable: true,
    ),
    MenuItemModel(
      id: 'm3',
      name: 'Masala Fries',
      description: 'Crisp hot potato fries with spicy seasoning',
      price: 150.0,
      isAvailable: true,
    ),
    MenuItemModel(
      id: 'm4',
      name: 'Chicken Paratha Roll',
      description: 'Grilled chicken wrapped in crispy paratha',
      price: 220.0,
      isAvailable: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.shop.name)),
      body: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: mockMenuItems.length,
                  itemBuilder: (context, index) {
                    final item = mockMenuItems[index];
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
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                    shopId: widget.shop.id,
                                    shopName: widget.shop.name,
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
                                  AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 200),
                                    transitionBuilder: (child, animation) {
                                      return ScaleTransition(
                                        scale: animation,
                                        child: child,
                                      );
                                    },
                                    child: Text(
                                      '$count',
                                      key: ValueKey<int>(count),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.add_circle_outline),
                                    onPressed: () {
                                      cartProvider.addItem(
                                        shopId: widget.shop.id,
                                        shopName: widget.shop.name,
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
                ),
              ),

              // Animated Floating Bottom Bar
              if (cartProvider.totalItemCount > 0)
                AnimatedCartButton(
                  itemQuantity: cartProvider.totalItemCount,
                  totalPrice: cartProvider.totalAmount,
                  onPressed: () {
                    Navigator.push(
                      context,
                      FadeSlidePageRoute(
                        page: CheckoutScreen(
                          shopName: widget.shop.name,
                          cart: cartProvider.items.map(
                            (key, item) => MapEntry(key, item.quantity),
                          ),
                          dynamicMenuItems: mockMenuItems,
                          totalPrice: cartProvider.totalAmount,
                        ),
                      ),
                    );
                  },
                ),
            ],
          );
        },
      ),
    );
  }
}
