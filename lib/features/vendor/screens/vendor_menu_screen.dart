import 'package:flutter/material.dart';

class VendorMenuItem {
  final String id;
  String name;
  String description;
  double price;
  String category;
  bool isAvailable;

  VendorMenuItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    this.isAvailable = true,
  });
}

class VendorMenuScreen extends StatefulWidget {
  const VendorMenuScreen({super.key});

  @override
  State<VendorMenuScreen> createState() => _VendorMenuScreenState();
}

class _VendorMenuScreenState extends State<VendorMenuScreen> {
  final List<VendorMenuItem> menuItems = [
    VendorMenuItem(
      id: 'm1',
      name: 'Zinger Burger',
      description: 'Crispy fried chicken fillet with mayo & lettuce',
      price: 350.0,
      category: 'Burgers',
      isAvailable: true,
    ),
    VendorMenuItem(
      id: 'm2',
      name: 'Club Sandwich',
      description: 'Layered chicken, egg, and cheese toasties',
      price: 280.0,
      category: 'Sandwiches',
      isAvailable: true,
    ),
    VendorMenuItem(
      id: 'm3',
      name: 'Masala Fries',
      description: 'Crisp hot potato fries with spicy seasoning',
      price: 150.0,
      category: 'Sides',
      isAvailable: true,
    ),
    VendorMenuItem(
      id: 'm4',
      name: 'Chicken Paratha Roll',
      description: 'Grilled chicken wrapped in crispy paratha',
      price: 220.0,
      category: 'Rolls',
      isAvailable: false,
    ),
  ];

  void _toggleAvailability(VendorMenuItem item, bool value) {
    setState(() {
      item.isAvailable = value;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${item.name} marked as ${value ? "In Stock" : "Out of Stock"}',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showAddEditItemDialog({VendorMenuItem? existingItem}) {
    final isEditing = existingItem != null;
    final nameController = TextEditingController(
      text: isEditing ? existingItem.name : '',
    );
    final descController = TextEditingController(
      text: isEditing ? existingItem.description : '',
    );
    final priceController = TextEditingController(
      text: isEditing ? existingItem.price.toStringAsFixed(0) : '',
    );
    final categoryController = TextEditingController(
      text: isEditing ? existingItem.category : 'Fast Food',
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isEditing ? 'Edit Menu Item' : 'Add New Menu Item'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Item Name',
                    hintText: 'e.g., Zinger Burger',
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: descController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    hintText: 'e.g., Crispy chicken fillet',
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Price (PKR)',
                    hintText: 'e.g., 350',
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: categoryController,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    hintText: 'e.g., Burgers, Drinks, Snacks',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final name = nameController.text.trim();
                final desc = descController.text.trim();
                final price = double.tryParse(priceController.text) ?? 0.0;
                final category = categoryController.text.trim();

                if (name.isEmpty || price <= 0) {
                  return;
                }

                setState(() {
                  if (isEditing) {
                    existingItem.name = name;
                    existingItem.description = desc;
                    existingItem.price = price;
                    existingItem.category = category;
                  } else {
                    menuItems.add(
                      VendorMenuItem(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        name: name,
                        description: desc,
                        price: price,
                        category: category,
                        isAvailable: true,
                      ),
                    );
                  }
                });
                Navigator.pop(context);
              },
              child: Text(isEditing ? 'Save Changes' : 'Add Item'),
            ),
          ],
        );
      },
    );
  }

  void _deleteItem(VendorMenuItem item) {
    setState(() {
      menuItems.removeWhere((element) => element.id == item.id);
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('${item.name} removed from menu')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add Item',
            onPressed: () => _showAddEditItemDialog(),
          ),
        ],
      ),
      body: menuItems.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.restaurant_menu, size: 64, color: Colors.grey),
                  SizedBox(height: 12),
                  Text(
                    'No Menu Items Yet',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text('Tap the + button to add your first dish.'),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: menuItems.length,
              itemBuilder: (context, index) {
                final item = menuItems[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    item.name,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.shade50,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      item.category,
                                      style: const TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ),
                                ],
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
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                Text(
                                  item.isAvailable ? 'In Stock' : 'Out',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: item.isAvailable
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                ),
                                Transform.scale(
                                  scale: 0.8,
                                  child: Switch(
                                    value: item.isAvailable,
                                    onChanged: (val) =>
                                        _toggleAvailability(item, val),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                    size: 20,
                                    color: Colors.blue,
                                  ),
                                  onPressed: () => _showAddEditItemDialog(
                                    existingItem: item,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete_outline,
                                    size: 20,
                                    color: Colors.red,
                                  ),
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddEditItemDialog(),
        icon: const Icon(Icons.add),
        label: const Text('Add Item'),
      ),
    );
  }
}
