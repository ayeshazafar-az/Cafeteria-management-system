import 'package:flutter/material.dart';
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
  final Map<String, int> cart = {};

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

  int get totalItems => cart.values.fold(0, (sum, count) => sum + count);

  double get totalPrice {
    double total = 0.0;
    cart.forEach((itemId, quantity) {
      final item = mockMenuItems.firstWhere((element) => element.id == itemId);
      total += item.price * quantity;
    });
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.shop.name)),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: mockMenuItems.length,
              itemBuilder: (context, index) {
                final item = mockMenuItems[index];
                final count = cart[item.id] ?? 0;

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
                                  color: Theme.of(context).colorScheme.primary,
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
                              setState(() {
                                cart[item.id] = 1;
                              });
                            },
                            child: const Text('Add'),
                          )
                        else
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove_circle_outline),
                                onPressed: () {
                                  setState(() {
                                    if (cart[item.id] == 1) {
                                      cart.remove(item.id);
                                    } else {
                                      cart[item.id] = cart[item.id]! - 1;
                                    }
                                  });
                                },
                              ),
                              Text(
                                '$count',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.add_circle_outline),
                                onPressed: () {
                                  setState(() {
                                    cart[item.id] = cart[item.id]! + 1;
                                  });
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
          if (totalItems > 0)
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
                          '$totalItems ${totalItems == 1 ? 'Item' : 'Items'} selected',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          'PKR ${totalPrice.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Order placed for PKR ${totalPrice.toStringAsFixed(0)}!',
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
      ),
    );
  }
}
