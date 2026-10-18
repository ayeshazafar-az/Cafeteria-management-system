import 'package:flutter/material.dart';

class CheckoutScreen extends StatefulWidget {
  final String shopName;
  final Map<String, int> cart;
  final List dynamicMenuItems;
  final double totalPrice;

  const CheckoutScreen({
    super.key,
    required this.shopName,
    required this.cart,
    required this.dynamicMenuItems,
    required this.totalPrice,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String selectedPaymentMethod = 'cash'; // 'cash' or 'online'
  final TextEditingController notesController = TextEditingController();

  @override
  void dispose() {
    notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Order Summary')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Shop Name Card
            Card(
              color: Theme.of(
                context,
              ).colorScheme.primaryContainer.withOpacity(0.4),
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(Icons.storefront, color: Colors.blue),
                    const SizedBox(width: 12),
                    Text(
                      widget.shopName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Order Items Breakdown
            const Text(
              'Selected Items',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Card(
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(12),
                itemCount: widget.cart.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final itemId = widget.cart.keys.elementAt(index);
                  final quantity = widget.cart[itemId]!;
                  final item = widget.dynamicMenuItems.firstWhere(
                    (e) => e.id == itemId,
                  );

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${quantity}x ${item.name}',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        'PKR ${(item.price * quantity).toStringAsFixed(0)}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            // Special Instructions Textbox
            const Text(
              'Special Instructions',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: notesController,
              decoration: InputDecoration(
                hintText: 'e.g., Extra spicy, no mayo, double napkins',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Payment Method Selector
            const Text(
              'Payment Method',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            RadioListTile<String>(
              title: const Text('Cash on Pickup'),
              subtitle: const Text(
                'Pay by hand at counter when receiving order',
              ),
              secondary: const Icon(
                Icons.payments_outlined,
                color: Colors.green,
              ),
              value: 'cash',
              groupValue: selectedPaymentMethod,
              onChanged: (value) {
                setState(() => selectedPaymentMethod = value!);
              },
            ),
            RadioListTile<String>(
              title: const Text('Online Payment'),
              subtitle: const Text('JazzCash / EasyPaisa / Card'),
              secondary: const Icon(
                Icons.account_balance_wallet_outlined,
                color: Colors.purple,
              ),
              value: 'online',
              groupValue: selectedPaymentMethod,
              onChanged: (value) {
                setState(() => selectedPaymentMethod = value!);
              },
            ),
            const SizedBox(height: 24),

            // Bill Total Summary
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Payable:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  'PKR ${widget.totalPrice.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Place Order Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Order Placed Successfully! Token #104'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                child: const Text(
                  'Confirm & Place Order',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
