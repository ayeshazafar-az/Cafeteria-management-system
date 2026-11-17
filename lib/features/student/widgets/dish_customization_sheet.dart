import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/providers/cart_provider.dart';

class DishAddOnOption {
  final String id;
  final String name;
  final double price;

  const DishAddOnOption({
    required this.id,
    required this.name,
    required this.price,
  });
}

class DishCustomizationSheet extends StatefulWidget {
  final String itemId;
  final String itemName;
  final String description;
  final double basePrice;
  final String shopId;
  final String shopName;

  const DishCustomizationSheet({
    super.key,
    required this.itemId,
    required this.itemName,
    required this.description,
    required this.basePrice,
    required this.shopId,
    required this.shopName,
  });

  /// Helper method to display the modal bottom sheet cleanly
  static Future<void> show(
    BuildContext context, {
    required String itemId,
    required String itemName,
    required String description,
    required double basePrice,
    required String shopId,
    required String shopName,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DishCustomizationSheet(
        itemId: itemId,
        itemName: itemName,
        description: description,
        basePrice: basePrice,
        shopId: shopId,
        shopName: shopName,
      ),
    );
  }

  @override
  State<DishCustomizationSheet> createState() => _DishCustomizationSheetState();
}

class _DishCustomizationSheetState extends State<DishCustomizationSheet> {
  String _selectedSpice = 'Medium';
  int _quantity = 1;
  final Set<String> _selectedAddOnIds = {};
  final TextEditingController _noteController = TextEditingController();

  final List<String> _spiceLevels = const [
    'Mild 🌿',
    'Medium 🌶️',
    'Spicy 🔥',
    'Extra Hot 💥',
  ];

  final List<DishAddOnOption> _availableAddOns = const [
    DishAddOnOption(
      id: 'addon_cheese',
      name: 'Extra Cheddar Cheese Slice',
      price: 60.0,
    ),
    DishAddOnOption(
      id: 'addon_garlic',
      name: 'Signature Garlic Mayo Dip',
      price: 40.0,
    ),
    DishAddOnOption(
      id: 'addon_jalapeno',
      name: 'Pickled Jalapeños',
      price: 35.0,
    ),
    DishAddOnOption(
      id: 'addon_coleslaw',
      name: 'Fresh Creamy Coleslaw',
      price: 50.0,
    ),
    DishAddOnOption(
      id: 'addon_patty',
      name: 'Double Chicken Fillet / Patty',
      price: 180.0,
    ),
  ];

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  double get _addOnsSubtotal {
    double sum = 0.0;
    for (final addon in _availableAddOns) {
      if (_selectedAddOnIds.contains(addon.id)) {
        sum += addon.price;
      }
    }
    return sum;
  }

  double get _unitCustomizedPrice => widget.basePrice + _addOnsSubtotal;

  double get _totalPrice => _unitCustomizedPrice * _quantity;

  String _buildCustomizedItemName() {
    final cleanSpice = _selectedSpice.split(' ').first;
    final selectedNames = _availableAddOns
        .where((a) => _selectedAddOnIds.contains(a.id))
        .map((a) => a.name.split(' ').take(2).join(' '))
        .toList();

    final extras = <String>[cleanSpice];
    if (selectedNames.isNotEmpty) {
      extras.addAll(selectedNames);
    }
    if (_noteController.text.trim().isNotEmpty) {
      extras.add('Note: ${_noteController.text.trim()}');
    }

    return '${widget.itemName} (${extras.join(', ')})';
  }

  String _buildUniqueCartId() {
    final sortedIds = _selectedAddOnIds.toList()..sort();
    final spiceSlug = _selectedSpice.split(' ').first.toLowerCase();
    final addonSlug = sortedIds.isEmpty ? 'none' : sortedIds.join('_');
    return '${widget.itemId}_${spiceSlug}_$addonSlug';
  }

  void _addToCart() {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final customCartId = _buildUniqueCartId();
    final formattedName = _buildCustomizedItemName();

    for (int i = 0; i < _quantity; i++) {
      cartProvider.addItem(
        shopId: widget.shopId,
        shopName: widget.shopName,
        itemId: customCartId,
        name: formattedName,
        price: _unitCustomizedPrice,
      );
    }

    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added $_quantity × ${widget.itemName} to cart!'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      margin: EdgeInsets.only(top: 60, bottom: bottomInset),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag Handle
          const SizedBox(height: 10),
          Container(
            width: 42,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade400,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 12),

          // Scrollable Customization Content
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Info
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.itemName,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.description,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'Base PKR ${widget.basePrice.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 28),

                  // 1. Spice Level Selector
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Select Spice Level',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade50,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'Required',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _spiceLevels.map((level) {
                      final isSelected = _selectedSpice == level;
                      return ChoiceChip(
                        label: Text(level),
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
                            setState(() => _selectedSpice = level);
                          }
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 22),

                  // 2. Paid Add-Ons & Toppings
                  const Text(
                    'Extra Cheese & Add-Ons',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Customize your meal with extra toppings or dips',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 10),
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                      side: BorderSide(color: Colors.grey.shade300),
                    ),
                    child: Column(
                      children: _availableAddOns.map((addon) {
                        final isChecked = _selectedAddOnIds.contains(addon.id);
                        return CheckboxListTile(
                          dense: true,
                          activeColor: primaryColor,
                          title: Text(
                            addon.name,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          secondary: Text(
                            '+PKR ${addon.price.toStringAsFixed(0)}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: isChecked
                                  ? primaryColor
                                  : Colors.grey.shade700,
                            ),
                          ),
                          value: isChecked,
                          onChanged: (val) {
                            setState(() {
                              if (val == true) {
                                _selectedAddOnIds.add(addon.id);
                              } else {
                                _selectedAddOnIds.remove(addon.id);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 3. Kitchen Note Field
                  const Text(
                    'Special Kitchen Note (Optional)',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _noteController,
                    maxLines: 2,
                    decoration: InputDecoration(
                      hintText:
                          'e.g., No onions, extra toasted bun, cut in half...',
                      hintStyle: const TextStyle(fontSize: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.all(12),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Sticky Bottom Action Bar (Quantity Stepper + Add to Cart)
          Container(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 10,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: Row(
              children: [
                // Quantity Stepper
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove, size: 18),
                        onPressed: _quantity > 1
                            ? () => setState(() => _quantity--)
                            : null,
                      ),
                      Text(
                        '$_quantity',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add, size: 18),
                        onPressed: _quantity < 15
                            ? () => setState(() => _quantity++)
                            : null,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 14),

                // Confirm Button with Live Total
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _addToCart,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Add to Cart',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'PKR ${_totalPrice.toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
