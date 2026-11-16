import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/providers/cart_provider.dart';

class CampusDishSearchItem {
  final String id;
  final String name;
  final String description;
  final String shopId;
  final String shopName;
  final String category;
  final double price;
  final int prepMinutes;
  final bool isAvailable;
  final bool isPopular;

  const CampusDishSearchItem({
    required this.id,
    required this.name,
    required this.description,
    required this.shopId,
    required this.shopName,
    required this.category,
    required this.price,
    required this.prepMinutes,
    this.isAvailable = true,
    this.isPopular = false,
  });
}

class StudentGlobalSearchScreen extends StatefulWidget {
  const StudentGlobalSearchScreen({super.key});

  @override
  State<StudentGlobalSearchScreen> createState() =>
      _StudentGlobalSearchScreenState();
}

class _StudentGlobalSearchScreenState extends State<StudentGlobalSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedCategory = 'All';
  String _sortBy =
      'Popular'; // 'Popular', 'Price: Low to High', 'Price: High to Low'
  bool _onlyAvailable = false;

  final List<String> _categories = const [
    'All',
    'Burgers',
    'Desi',
    'Snacks & Sides',
    'Tea & Coffee',
    'Drinks',
  ];

  final List<String> _sortOptions = const [
    'Popular',
    'Price: Low to High',
    'Price: High to Low',
  ];

  final List<CampusDishSearchItem> _allCampusDishes = const [
    CampusDishSearchItem(
      id: 'm1',
      name: 'Zinger Burger',
      description: 'Crispy fried chicken fillet with spicy mayo & lettuce',
      shopId: 's1',
      shopName: 'Central Fast Food',
      category: 'Burgers',
      price: 350.0,
      prepMinutes: 12,
      isAvailable: true,
      isPopular: true,
    ),
    CampusDishSearchItem(
      id: 'm2',
      name: 'Club Sandwich',
      description: 'Triple-decker toasted sandwich with grilled chicken & egg',
      shopId: 's1',
      shopName: 'Central Fast Food',
      category: 'Burgers',
      price: 280.0,
      prepMinutes: 10,
      isAvailable: true,
      isPopular: true,
    ),
    CampusDishSearchItem(
      id: 'm3',
      name: 'Masala Fries',
      description: 'Crispy golden fries tossed in signature chatpata spice',
      shopId: 's1',
      shopName: 'Central Fast Food',
      category: 'Snacks & Sides',
      price: 150.0,
      prepMinutes: 8,
      isAvailable: true,
      isPopular: false,
    ),
    CampusDishSearchItem(
      id: 'm4',
      name: 'Doodh Patti Chai',
      description: 'Strong cardamom milk tea brewed fresh on order',
      shopId: 's2',
      shopName: 'Campus Chai & Snacks',
      category: 'Tea & Coffee',
      price: 80.0,
      prepMinutes: 5,
      isAvailable: true,
      isPopular: true,
    ),
    CampusDishSearchItem(
      id: 'm5',
      name: 'Aloo Cheese Paratha',
      description:
          'Flaky pan-fried paratha stuffed with spiced potato & cheddar',
      shopId: 's2',
      shopName: 'Campus Chai & Snacks',
      category: 'Snacks & Sides',
      price: 180.0,
      prepMinutes: 10,
      isAvailable: true,
      isPopular: true,
    ),
    CampusDishSearchItem(
      id: 'm6',
      name: 'Chicken Biryani Single',
      description:
          'Aromatic basmati rice cooked with tender spiced chicken & raita',
      shopId: 's4',
      shopName: 'Lahori Biryani & Karahi Corner',
      category: 'Desi',
      price: 300.0,
      prepMinutes: 7,
      isAvailable: true,
      isPopular: true,
    ),
    CampusDishSearchItem(
      id: 'm7',
      name: 'Chicken Karahi Half',
      description:
          'Traditional tomato & ginger chicken karahi served with 2 naans',
      shopId: 's4',
      shopName: 'Lahori Biryani & Karahi Corner',
      category: 'Desi',
      price: 650.0,
      prepMinutes: 18,
      isAvailable: false,
      isPopular: false,
    ),
    CampusDishSearchItem(
      id: 'm8',
      name: 'Fresh Mint Margarita',
      description: 'Chilled crushed ice lime & fresh mint refresher',
      shopId: 's3',
      shopName: 'Fresh Juice & Shakes Bar',
      category: 'Drinks',
      price: 140.0,
      prepMinutes: 5,
      isAvailable: true,
      isPopular: true,
    ),
    CampusDishSearchItem(
      id: 'm9',
      name: 'Cold Coffee with Ice Cream',
      description: 'Blended iced espresso topped with vanilla scoop',
      shopId: 's2',
      shopName: 'Campus Chai & Snacks',
      category: 'Tea & Coffee',
      price: 220.0,
      prepMinutes: 7,
      isAvailable: true,
      isPopular: false,
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<CampusDishSearchItem> get _filteredDishes {
    final query = _searchQuery.trim().toLowerCase();

    final results = _allCampusDishes.where((dish) {
      final matchesCategory =
          _selectedCategory == 'All' || dish.category == _selectedCategory;

      final matchesAvailability = !_onlyAvailable || dish.isAvailable;

      final matchesSearch =
          query.isEmpty ||
          dish.name.toLowerCase().contains(query) ||
          dish.shopName.toLowerCase().contains(query) ||
          dish.description.toLowerCase().contains(query) ||
          dish.category.toLowerCase().contains(query);

      return matchesCategory && matchesAvailability && matchesSearch;
    }).toList();

    if (_sortBy == 'Price: Low to High') {
      results.sort((a, b) => a.price.compareTo(b.price));
    } else if (_sortBy == 'Price: High to Low') {
      results.sort((a, b) => b.price.compareTo(a.price));
    } else {
      results.sort(
        (a, b) => (b.isPopular ? 1 : 0).compareTo(a.isPopular ? 1 : 0),
      );
    }

    return results;
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final cartProvider = Provider.of<CartProvider>(context);
    final dishes = _filteredDishes;

    return Scaffold(
      appBar: AppBar(title: const Text('Explore Campus Menu')),
      body: Column(
        children: [
          // Search Bar & Sort Row
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              controller: _searchController,
              autofocus: false,
              onChanged: (val) => setState(() => _searchQuery = val),
              decoration: InputDecoration(
                hintText: 'Search burgers, biryani, chai, or stalls...',
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close_rounded),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),

          // Horizontal Category Chips
          SizedBox(
            height: 44,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = _selectedCategory == category;

                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: Text(category),
                    selected: isSelected,
                    selectedColor: primaryColor,
                    labelStyle: TextStyle(
                      fontSize: 12,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: isSelected
                          ? Colors.white
                          : Theme.of(context).textTheme.bodyMedium?.color,
                    ),
                    onSelected: (selected) {
                      if (selected) {
                        setState(() => _selectedCategory = category);
                      }
                    },
                  ),
                );
              },
            ),
          ),

          // Filter & Sort Toolbar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FilterChip(
                  label: const Text(
                    'In Stock Only',
                    style: TextStyle(fontSize: 11),
                  ),
                  selected: _onlyAvailable,
                  selectedColor: Colors.green.withOpacity(0.2),
                  checkmarkColor: Colors.green,
                  onSelected: (val) {
                    setState(() => _onlyAvailable = val);
                  },
                ),
                DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _sortBy,
                    icon: const Icon(Icons.sort_rounded, size: 18),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                    ),
                    items: _sortOptions.map((opt) {
                      return DropdownMenuItem(value: opt, child: Text(opt));
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _sortBy = val);
                    },
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Results Count Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${dishes.length} ${dishes.length == 1 ? 'dish' : 'dishes'} found',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade600,
                  ),
                ),
                if (_selectedCategory != 'All' ||
                    _searchQuery.isNotEmpty ||
                    _onlyAvailable)
                  GestureDetector(
                    onTap: () {
                      _searchController.clear();
                      setState(() {
                        _searchQuery = '';
                        _selectedCategory = 'All';
                        _onlyAvailable = false;
                        _sortBy = 'Popular';
                      });
                    },
                    child: Text(
                      'Reset Filters',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Search Results List
          Expanded(
            child: dishes.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off_rounded,
                          size: 64,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'No matching dishes found',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Try searching another keyword or clearing category filters.',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: dishes.length,
                    itemBuilder: (context, index) {
                      final dish = dishes[index];
                      final cartItem = cartProvider.items[dish.id];
                      final count = cartItem?.quantity ?? 0;

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Flexible(
                                              child: Text(
                                                dish.name,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            if (dish.isPopular) ...[
                                              const SizedBox(width: 6),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 6,
                                                      vertical: 2,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: Colors.orange.shade50,
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                ),
                                                child: const Text(
                                                  'POPULAR',
                                                  style: TextStyle(
                                                    fontSize: 9,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.orange,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.storefront_rounded,
                                              size: 14,
                                              color: primaryColor,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              dish.shopName,
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: primaryColor,
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Icon(
                                              Icons.timer_outlined,
                                              size: 13,
                                              color: Colors.grey.shade600,
                                            ),
                                            const SizedBox(width: 2),
                                            Text(
                                              '${dish.prepMinutes}m',
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: Colors.grey.shade600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade100,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      dish.category,
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey.shade700,
                                      ),
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
                              const Divider(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'PKR ${dish.price.toStringAsFixed(0)}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  if (!dish.isAvailable)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 5,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.red.shade50,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Text(
                                        'Sold Out',
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
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
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              '${dish.name} added to cart!',
                                            ),
                                            duration: const Duration(
                                              seconds: 1,
                                            ),
                                          ),
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.add_shopping_cart_rounded,
                                        size: 16,
                                      ),
                                      label: const Text('Add to Cart'),
                                    )
                                  else
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 5,
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
          ),
        ],
      ),
    );
  }
}
