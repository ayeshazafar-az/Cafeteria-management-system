import 'package:flutter/material.dart';
import '../../../core/services/local_storage_service.dart';
import '../../../core/utils/feedback_helper.dart';

class VendorMenuItem {
  final String id;
  String name;
  String description;
  String category;
  double price;
  int prepMinutes;
  bool isAvailable;
  bool isPopular;

  VendorMenuItem({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.price,
    required this.prepMinutes,
    this.isAvailable = true,
    this.isPopular = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'category': category,
    'price': price,
    'prepMinutes': prepMinutes,
    'isAvailable': isAvailable,
    'isPopular': isPopular,
  };

  factory VendorMenuItem.fromJson(Map<String, dynamic> json) {
    return VendorMenuItem(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      category: json['category'] as String? ?? 'Burgers',
      price: (json['price'] as num).toDouble(),
      prepMinutes: json['prepMinutes'] as int? ?? 10,
      isAvailable: json['isAvailable'] as bool? ?? true,
      isPopular: json['isPopular'] as bool? ?? false,
    );
  }
}

class VendorMenuManagementScreen extends StatefulWidget {
  const VendorMenuManagementScreen({super.key});

  @override
  State<VendorMenuManagementScreen> createState() =>
      _VendorMenuManagementScreenState();
}

class _VendorMenuManagementScreenState
    extends State<VendorMenuManagementScreen> {
  static const String _menuStorageKey = 'campus_cafeteria_vendor_menu_v1';

  String _selectedCategory = 'All';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  final List<String> _categories = const [
    'All',
    'Burgers',
    'Snacks & Sides',
    'Tea & Coffee',
    'Desi',
    'Drinks',
  ];

  final List<String> _editableCategories = const [
    'Burgers',
    'Snacks & Sides',
    'Tea & Coffee',
    'Desi',
    'Drinks',
  ];

  List<VendorMenuItem> _menuItems = [
    VendorMenuItem(
      id: 'vm_1',
      name: 'Zinger Burger',
      description: 'Crispy fried chicken fillet with spicy mayo & lettuce',
      category: 'Burgers',
      price: 350.0,
      prepMinutes: 12,
      isAvailable: true,
      isPopular: true,
    ),
    VendorMenuItem(
      id: 'vm_2',
      name: 'Club Sandwich',
      description: 'Triple-decker toasted sandwich with grilled chicken & egg',
      category: 'Burgers',
      price: 280.0,
      prepMinutes: 10,
      isAvailable: true,
      isPopular: true,
    ),
    VendorMenuItem(
      id: 'vm_3',
      name: 'Masala Fries',
      description: 'Crispy golden fries tossed in signature chatpata spice',
      category: 'Snacks & Sides',
      price: 150.0,
      prepMinutes: 8,
      isAvailable: true,
      isPopular: false,
    ),
    VendorMenuItem(
      id: 'vm_4',
      name: 'Doodh Patti Chai',
      description: 'Strong cardamom milk tea brewed fresh on order',
      category: 'Tea & Coffee',
      price: 80.0,
      prepMinutes: 5,
      isAvailable: false,
      isPopular: true,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadMenuFromStorage();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadMenuFromStorage() async {
    final savedList = await LocalStorageService.loadJsonList(_menuStorageKey);
    if (savedList != null && savedList.isNotEmpty && mounted) {
      setState(() {
        _menuItems = savedList.map(VendorMenuItem.fromJson).toList();
      });
    }
  }

  Future<void> _persistMenu() async {
    await LocalStorageService.saveJsonList(
      _menuStorageKey,
      _menuItems.map((item) => item.toJson()).toList(),
    );
  }

  List<VendorMenuItem> get _filteredItems {
    final query = _searchQuery.trim().toLowerCase();
    return _menuItems.where((item) {
      final matchesCat =
          _selectedCategory == 'All' || item.category == _selectedCategory;
      final matchesQuery =
          query.isEmpty ||
          item.name.toLowerCase().contains(query) ||
          item.description.toLowerCase().contains(query);
      return matchesCat && matchesQuery;
    }).toList();
  }

  void _toggleAvailability(VendorMenuItem item, bool newValue) {
    FeedbackHelper.triggerSelectionClick();
    setState(() {
      item.isAvailable = newValue;
    });
    _persistMenu();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${item.name} marked as ${newValue ? "IN STOCK" : "SOLD OUT"}',
        ),
        backgroundColor: newValue ? Colors.green : Colors.orange.shade800,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _deleteItem(VendorMenuItem item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Dish'),
        content: Text('Delete "${item.name}" from your stall menu?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              setState(() {
                _menuItems.removeWhere((e) => e.id == item.id);
              });
              _persistMenu();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${item.name} removed from menu.')),
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _openDishEditorSheet({VendorMenuItem? existingItem}) {
    final isEditing = existingItem != null;
    final nameController = TextEditingController(
      text: existingItem?.name ?? '',
    );
    final descController = TextEditingController(
      text: existingItem?.description ?? '',
    );
    final priceController = TextEditingController(
      text: existingItem != null ? existingItem.price.toStringAsFixed(0) : '',
    );

    String selectedCategory =
        existingItem?.category ?? _editableCategories.first;
    int prepMinutes = existingItem?.prepMinutes ?? 10;
    bool isAvailable = existingItem?.isAvailable ?? true;
    bool isPopular = existingItem?.isPopular ?? false;
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final primaryColor = Theme.of(context).colorScheme.primary;
            final bottomInset = MediaQuery.of(context).viewInsets.bottom;

            return Padding(
              padding: EdgeInsets.fromLTRB(20, 16, 20, 20 + bottomInset),
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade400,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        isEditing ? 'Edit Menu Dish' : 'Add New Dish',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: nameController,
                        validator: (val) => (val == null || val.trim().isEmpty)
                            ? 'Enter dish name'
                            : null,
                        decoration: InputDecoration(
                          labelText: 'Dish Name',
                          hintText: 'e.g., Chicken Shawarma',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      TextFormField(
                        controller: descController,
                        maxLines: 2,
                        decoration: InputDecoration(
                          labelText: 'Short Description',
                          hintText:
                              'Ingredients, portion size, or serving note',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: priceController,
                              keyboardType: TextInputType.number,
                              validator: (val) {
                                final parsed = double.tryParse(val ?? '');
                                if (parsed == null || parsed <= 0) {
                                  return 'Invalid price';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                labelText: 'Price (PKR)',
                                prefixText: 'Rs. ',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: selectedCategory,
                              decoration: InputDecoration(
                                labelText: 'Category',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              items: _editableCategories.map((cat) {
                                return DropdownMenuItem(
                                  value: cat,
                                  child: Text(
                                    cat,
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                );
                              }).toList(),
                              onChanged: (val) {
                                if (val != null) {
                                  setModalState(() => selectedCategory = val);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Estimated Prep Time:',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove_circle_outline),
                                onPressed: prepMinutes > 3
                                    ? () =>
                                          setModalState(() => prepMinutes -= 2)
                                    : null,
                              ),
                              Text(
                                '$prepMinutes mins',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.add_circle_outline),
                                onPressed: prepMinutes < 45
                                    ? () =>
                                          setModalState(() => prepMinutes += 2)
                                    : null,
                              ),
                            ],
                          ),
                        ],
                      ),

                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Available in Stock'),
                        value: isAvailable,
                        onChanged: (val) =>
                            setModalState(() => isAvailable = val),
                      ),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Mark as Bestseller / Popular'),
                        value: isPopular,
                        onChanged: (val) =>
                            setModalState(() => isPopular = val),
                      ),
                      const SizedBox(height: 14),

                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            if (!formKey.currentState!.validate()) return;

                            final name = nameController.text.trim();
                            final desc = descController.text.trim();
                            final price = double.parse(
                              priceController.text.trim(),
                            );

                            setState(() {
                              if (isEditing) {
                                existingItem.name = name;
                                existingItem.description = desc;
                                existingItem.category = selectedCategory;
                                existingItem.price = price;
                                existingItem.prepMinutes = prepMinutes;
                                existingItem.isAvailable = isAvailable;
                                existingItem.isPopular = isPopular;
                              } else {
                                _menuItems.insert(
                                  0,
                                  VendorMenuItem(
                                    id: 'vm_${DateTime.now().millisecondsSinceEpoch}',
                                    name: name,
                                    description: desc,
                                    category: selectedCategory,
                                    price: price,
                                    prepMinutes: prepMinutes,
                                    isAvailable: isAvailable,
                                    isPopular: isPopular,
                                  ),
                                );
                              }
                            });

                            _persistMenu();
                            Navigator.pop(context);

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  isEditing
                                      ? 'Updated "$name" successfully!'
                                      : 'Added "$name" to stall menu!',
                                ),
                                backgroundColor: Colors.green,
                              ),
                            );
                          },
                          icon: Icon(
                            isEditing ? Icons.check_rounded : Icons.add_rounded,
                          ),
                          label: Text(
                            isEditing ? 'Save Changes' : 'Add Dish to Menu',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final filtered = _filteredItems;
    final inStockCount = _menuItems.where((i) => i.isAvailable).length;

    return Scaffold(
      appBar: AppBar(title: const Text('Stall Menu & Stock')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openDishEditorSheet(),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add Dish'),
      ),
      body: Column(
        children: [
          // Top Stock Summary Strip
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              children: [
                _buildStatBadge(
                  'Total Dishes',
                  '${_menuItems.length}',
                  Colors.blue,
                ),
                const SizedBox(width: 10),
                _buildStatBadge('In Stock', '$inStockCount', Colors.green),
                const SizedBox(width: 10),
                _buildStatBadge(
                  'Sold Out',
                  '${_menuItems.length - inStockCount}',
                  Colors.red,
                ),
              ],
            ),
          ),

          // Search Input
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: TextField(
              controller: _searchController,
              onChanged: (val) => setState(() => _searchQuery = val),
              decoration: InputDecoration(
                hintText: 'Filter your menu items...',
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),

          // Category Chips
          SizedBox(
            height: 44,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final cat = _categories[index];
                final isSelected = _selectedCategory == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(cat),
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
                        setState(() => _selectedCategory = cat);
                      }
                    },
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 6),

          // Menu Items List
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.restaurant_menu_rounded,
                          size: 64,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'No menu items match your filter',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 84),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final item = filtered[index];

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
                                                item.name,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: item.isAvailable
                                                      ? null
                                                      : Colors.grey,
                                                ),
                                              ),
                                            ),
                                            if (item.isPopular) ...[
                                              const SizedBox(width: 6),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 6,
                                                      vertical: 2,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: Colors.amber.shade50,
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                ),
                                                child: const Text(
                                                  'BESTSELLER',
                                                  style: TextStyle(
                                                    fontSize: 9,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.amber,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ],
                                        ),
                                        const SizedBox(height: 3),
                                        Text(
                                          '${item.category} • Prep: ${item.prepMinutes} mins',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Switch(
                                    value: item.isAvailable,
                                    activeColor: Colors.green,
                                    onChanged: (val) =>
                                        _toggleAvailability(item, val),
                                  ),
                                ],
                              ),
                              if (item.description.isNotEmpty) ...[
                                const SizedBox(height: 4),
                                Text(
                                  item.description,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                              const Divider(height: 18),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'PKR ${item.price.toStringAsFixed(0)}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 3,
                                        ),
                                        decoration: BoxDecoration(
                                          color: item.isAvailable
                                              ? Colors.green.shade50
                                              : Colors.red.shade50,
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                        ),
                                        child: Text(
                                          item.isAvailable
                                              ? 'IN STOCK'
                                              : 'SOLD OUT',
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: item.isAvailable
                                                ? Colors.green
                                                : Colors.red,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(
                                          Icons.edit_outlined,
                                          size: 20,
                                        ),
                                        tooltip: 'Edit Dish',
                                        onPressed: () => _openDishEditorSheet(
                                          existingItem: item,
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.delete_outline_rounded,
                                          size: 20,
                                          color: Colors.red,
                                        ),
                                        tooltip: 'Delete Dish',
                                        onPressed: () => _deleteItem(item),
                                      ),
                                    ],
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

  Widget _buildStatBadge(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withOpacity(0.25)),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
