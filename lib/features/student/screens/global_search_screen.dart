import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import 'shop_detail_screen.dart';
import 'student_shops_screen.dart';

class GlobalSearchDishItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final String category;
  final bool isAvailable;
  final String shopId;
  final String shopName;

  const GlobalSearchDishItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.isAvailable,
    required this.shopId,
    required this.shopName,
  });
}

class GlobalSearchScreen extends StatefulWidget {
  const GlobalSearchScreen({super.key});

  @override
  State<GlobalSearchScreen> createState() => _GlobalSearchScreenState();
}

class _GlobalSearchScreenState extends State<GlobalSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  final List<GlobalSearchDishItem> _allDishes = const [
    GlobalSearchDishItem(
      id: 'm1',
      name: 'Zinger Burger',
      description: 'Crispy fried chicken fillet with mayo & lettuce',
      price: 350.0,
      category: 'Burgers',
      isAvailable: true,
      shopId: 's1',
      shopName: 'Central Fast Food',
    ),
    GlobalSearchDishItem(
      id: 'm2',
      name: 'Club Sandwich',
      description: 'Layered chicken, egg, and cheese toasties',
      price: 280.0,
      category: 'Sandwiches',
      isAvailable: true,
      shopId: 's1',
      shopName: 'Central Fast Food',
    ),
    GlobalSearchDishItem(
      id: 'm3',
      name: 'Masala Fries',
      description: 'Crisp hot potato fries with spicy seasoning',
      price: 150.0,
      category: 'Sides',
      isAvailable: true,
      shopId: 's1',
      shopName: 'Central Fast Food',
    ),
    GlobalSearchDishItem(
      id: 'm4',
      name: 'Doodh Patti Chai',
      description: 'Strong brewed cardamom tea with fresh milk',
      price: 80.0,
      category: 'Tea & Coffee',
      isAvailable: true,
      shopId: 's2',
      shopName: 'Campus Chai & Snacks',
    ),
    GlobalSearchDishItem(
      id: 'm5',
      name: 'Samosa Chat',
      description: 'Crushed crispy samosas with chickpea curry & chutney',
      price: 120.0,
      category: 'Snacks',
      isAvailable: true,
      shopId: 's2',
      shopName: 'Campus Chai & Snacks',
    ),
    GlobalSearchDishItem(
      id: 'm6',
      name: 'Chicken Biryani Single',
      description: 'Fragrant basmati rice with spiced chicken piece',
      price: 300.0,
      category: 'Desi',
      isAvailable: true,
      shopId: 's4',
      shopName: 'Lahori Biryani & Karahi Corner',
    ),
    GlobalSearchDishItem(
      id: 'm7',
      name: 'Mango Milkshake',
      description: 'Fresh mango pulp blended with chilled milk & ice cream',
      price: 200.0,
      category: 'Drinks',
      isAvailable: false,
      shopId: 's3',
      shopName: 'Fresh Juice & Shakes Bar',
    ),
  ];

  List<GlobalSearchDishItem> get _searchResults {
    if (_query.trim().isEmpty) return [];
    final lower = _query.toLowerCase();
    return _allDishes.where((dish) {
      return dish.name.toLowerCase().contains(lower) ||
          dish.description.toLowerCase().contains(lower) ||
          dish.category.toLowerCase().contains(lower) ||
          dish.shopName.toLowerCase().contains(lower);
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final results = _searchResults;

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          autofocus: true,
          onChanged: (val) {
            setState(() {
              _query = val;
            });
          },
          decoration: InputDecoration(
            hintText: 'Search dishes (Biryani, Chai, Burger)...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 16),
          ),
          style: const TextStyle(fontSize: 16),
        ),
        actions: [
          if (_query.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _searchController.clear();
                setState(() {
                  _query = '';
                });
              },
            ),
        ],
      ),
      body: _query.trim().isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search_rounded,
                    size: 72,
                    color: Colors.grey.shade300,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Search for any dish across campus stalls',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            )
          : results.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.no_meals_rounded,
                    size: 64,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'No dishes matching "$_query"',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Try searching for burger, fries, tea, or biryani.',
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: results.length,
              itemBuilder: (context, index) {
                final dish = results[index];

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
                            Text(
                              'PKR ${dish.price.toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          dish.description,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const Divider(height: 18),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              dish.isAvailable ? 'Available' : 'Out of Stock',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: dish.isAvailable
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                visualDensity: VisualDensity.compact,
                              ),
                              onPressed: dish.isAvailable
                                  ? () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ShopDetailScreen(
                                                shop: Shop(
                                                  id: dish.shopId,
                                                  name: dish.shopName,
                                                  category: dish.category,
                                                  rating: 4.8,
                                                  isOpen: true,
                                                  icon: Icons.fastfood_rounded,
                                                ),
                                              ),
                                        ),
                                      );
                                    }
                                  : null,
                              icon: const Icon(
                                Icons.arrow_forward_rounded,
                                size: 16,
                              ),
                              label: const Text('View Stall Menu'),
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
