import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/providers/cart_provider.dart';

class FavoriteDish {
  final String id;
  final String name;
  final String shopId;
  final String shopName;
  final double price;
  final String category;
  final bool isAvailable;

  FavoriteDish({
    required this.id,
    required this.name,
    required this.shopId,
    required this.shopName,
    required this.price,
    required this.category,
    this.isAvailable = true,
  });
}

class FavoriteDishesScreen extends StatefulWidget {
  const FavoriteDishesScreen({super.key});

  @override
  State<FavoriteDishesScreen> createState() => _FavoriteDishesScreenState();
}

class _FavoriteDishesScreenState extends State<FavoriteDishesScreen> {
  final List<FavoriteDish> _favoriteDishes = [
    FavoriteDish(
      id: 'm1',
      name: 'Zinger Burger',
      shopId: 's1',
      shopName: 'Central Fast Food',
      price: 350.0,
      category: 'Burgers',
      isAvailable: true,
    ),
    FavoriteDish(
      id: 'm4',
      name: 'Doodh Patti Chai',
      shopId: 's2',
      shopName: 'Campus Chai & Snacks',
      price: 80.0,
      category: 'Tea & Coffee',
      isAvailable: true,
    ),
    FavoriteDish(
      id: 'm6',
      name: 'Chicken Biryani Single',
      shopId: 's4',
      shopName: 'Lahori Biryani & Karahi Corner',
      price: 300.0,
      category: 'Desi',
      isAvailable: true,
    ),
  ];

  void _removeFavorite(FavoriteDish dish) {
    setState(() {
      _favoriteDishes.removeWhere((item) => item.id == dish.id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${dish.name} removed from favorites'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Favorite Dishes')),
      body: _favoriteDishes.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border_rounded,
                    size: 64,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'No Favorite Dishes Saved',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Tap the heart icon on any menu item to save it here.',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _favoriteDishes.length,
              itemBuilder: (context, index) {
                final dish = _favoriteDishes[index];
                final cartItem = cartProvider.items[dish.id];
                final count = cartItem?.quantity ?? 0;

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    dish.name,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.storefront_rounded,
                                        size: 14,
                                        color: AppColors.primary,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        dish.shopName,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.favorite,
                                color: Colors.red,
                              ),
                              tooltip: 'Remove from Favorites',
                              onPressed: () => _removeFavorite(dish),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'PKR ${dish.price.toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (!dish.isAvailable)
                              const Text(
                                'Out of Stock',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              )
                            else if (count == 0)
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 8,
                                  ),
                                  visualDensity: VisualDensity.compact,
                                ),
                                onPressed: () {
                                  cartProvider.addItem(
                                    shopId: dish.shopId,
                                    shopName: dish.shopName,
                                    itemId: dish.id,
                                    name: dish.name,
                                    price: dish.price,
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        '${dish.name} added to cart!',
                                      ),
                                      duration: const Duration(seconds: 1),
                                    ),
                                  );
                                },
                                icon: const Icon(
                                  Icons.add_shopping_cart,
                                  size: 16,
                                ),
                                label: const Text('Quick Add'),
                              )
                            else
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryLight,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  '$count in cart',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
