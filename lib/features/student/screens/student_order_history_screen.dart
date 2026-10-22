import 'package:flutter/material.dart';

class PastOrderItem {
  final String name;
  final int quantity;
  final double unitPrice;

  const PastOrderItem({
    required this.name,
    required this.quantity,
    required this.unitPrice,
  });

  double get total => quantity * unitPrice;
}

class PastOrder {
  final String id;
  final String tokenNumber;
  final String shopName;
  final DateTime dateTime;
  final List<PastOrderItem> items;
  final double totalAmount;
  final String paymentMethod;
  final String status; // 'Completed', 'Cancelled'

  const PastOrder({
    required this.id,
    required this.tokenNumber,
    required this.shopName,
    required this.dateTime,
    required this.items,
    required this.totalAmount,
    required this.paymentMethod,
    required this.status,
  });
}

class StudentOrderHistoryScreen extends StatefulWidget {
  const StudentOrderHistoryScreen({super.key});

  @override
  State<StudentOrderHistoryScreen> createState() =>
      _StudentOrderHistoryScreenState();
}

class _StudentOrderHistoryScreenState extends State<StudentOrderHistoryScreen> {
  final List<PastOrder> mockOrderHistory = [
    PastOrder(
      id: 'ORD-9842',
      tokenNumber: '#089',
      shopName: 'Central Fast Food',
      dateTime: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
      items: const [
        PastOrderItem(name: 'Zinger Burger', quantity: 1, unitPrice: 350),
        PastOrderItem(name: 'Masala Fries', quantity: 1, unitPrice: 150),
      ],
      totalAmount: 500.0,
      paymentMethod: 'Cash on Pickup',
      status: 'Completed',
    ),
    PastOrder(
      id: 'ORD-9120',
      tokenNumber: '#042',
      shopName: 'Campus Chai & Snacks',
      dateTime: DateTime.now().subtract(const Duration(days: 3, hours: 5)),
      items: const [
        PastOrderItem(name: 'Doodh Patti Chai', quantity: 2, unitPrice: 80),
        PastOrderItem(name: 'Samosa', quantity: 2, unitPrice: 50),
      ],
      totalAmount: 260.0,
      paymentMethod: 'Online Paid',
      status: 'Completed',
    ),
    PastOrder(
      id: 'ORD-8811',
      tokenNumber: '#012',
      shopName: 'Lahori Biryani & Karahi Corner',
      dateTime: DateTime.now().subtract(const Duration(days: 5, hours: 1)),
      items: const [
        PastOrderItem(
          name: 'Chicken Biryani Single',
          quantity: 1,
          unitPrice: 300,
        ),
      ],
      totalAmount: 300.0,
      paymentMethod: 'Cash on Pickup',
      status: 'Cancelled',
    ),
  ];

  void _showReceiptModal(BuildContext context, PastOrder order) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bottomsheet Header
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Receipt ${order.id}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Token ${order.tokenNumber}',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: order.status == 'Completed'
                          ? Colors.green.shade50
                          : Colors.red.shade50,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      order.status.toUpperCase(),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: order.status == 'Completed'
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'Stall: ${order.shopName}',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              Text(
                'Date: ${_formatDateTime(order.dateTime)}',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
              const Divider(height: 24),

              // Itemized Receipt List
              const Text(
                'Order Breakdown',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 8),
              ...order.items.map(
                (item) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${item.quantity}x ${item.name}'),
                      Text('PKR ${item.total.toStringAsFixed(0)}'),
                    ],
                  ),
                ),
              ),
              const Divider(height: 24),

              // Total & Payment Method
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Payment (${order.paymentMethod}):',
                    style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
                  ),
                  Text(
                    'PKR ${order.totalAmount.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Actions
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Re-added items from ${order.shopName} to cart!',
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('Reorder Same Meal'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatDateTime(DateTime dt) {
    return '${dt.day}/${dt.month}/${dt.year} at ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Order History & Receipts')),
      body: mockOrderHistory.isEmpty
          ? const Center(child: Text('No past orders found.'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: mockOrderHistory.length,
              itemBuilder: (context, index) {
                final order = mockOrderHistory[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 14),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              order.shopName,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'PKR ${order.totalAmount.toStringAsFixed(0)}',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _formatDateTime(order.dateTime),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          order.items
                              .map((i) => '${i.quantity}x ${i.name}')
                              .join(', '),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade800,
                          ),
                        ),
                        const Divider(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              order.paymentMethod,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                visualDensity: VisualDensity.compact,
                              ),
                              onPressed: () =>
                                  _showReceiptModal(context, order),
                              child: const Text('View Receipt'),
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
