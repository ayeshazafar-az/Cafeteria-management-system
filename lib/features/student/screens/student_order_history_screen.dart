import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/providers/cart_provider.dart';
import '../../../core/providers/order_provider.dart';
import '../widgets/order_rating_dialog.dart';

class StudentOrderHistoryScreen extends StatefulWidget {
  const StudentOrderHistoryScreen({super.key});

  @override
  State<StudentOrderHistoryScreen> createState() =>
      _StudentOrderHistoryScreenState();
}

class _StudentOrderHistoryScreenState extends State<StudentOrderHistoryScreen> {
  final Set<String> _ratedOrderIds = {};

  Future<void> _openRatingDialog(LocalOrder order) async {
    await showDialog(
      context: context,
      builder: (context) => OrderRatingDialog(
        shopName: order.shopName,
        orderToken: order.tokenNumber,
      ),
    );

    if (!mounted) return;
    setState(() {
      _ratedOrderIds.add(order.id);
    });
  }

  void _reorderItems(LocalOrder order) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    for (final item in order.items) {
      for (int i = 0; i < item.quantity; i++) {
        cartProvider.addItem(
          shopId: order.shopName.toLowerCase().replaceAll(' ', '_'),
          shopName: order.shopName,
          itemId: 're_${item.name.toLowerCase().replaceAll(' ', '_')}',
          name: item.name,
          price: item.price,
        );
      }
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added items from ${order.tokenNumber} to your cart!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Order History'),
      ),
      body: Consumer<OrderProvider>(
        builder: (context, orderProvider, child) {
          final orders = orderProvider.allOrders;

          if (orders.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.receipt_long_outlined,
                    size: 64,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'No Orders Yet',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Your campus cafeteria orders will appear here.',
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              final isCompleted = order.status.toLowerCase() == 'completed';
              final isRated = _ratedOrderIds.contains(order.id);

              return Card(
                margin: const EdgeInsets.only(bottom: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                order.tokenNumber,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                order.shopName,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: isCompleted
                                  ? Colors.green.shade50
                                  : Colors.orange.shade50,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              order.status.toUpperCase(),
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color:
                                    isCompleted ? Colors.green : Colors.orange,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ...order.items.map(
                        (item) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Text(
                            '${item.quantity}x ${item.name} — PKR ${(item.price * item.quantity).toStringAsFixed(0)}',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ),
                      ),
                      const Divider(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total: PKR ${order.totalAmount.toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                              if (!isRated)
                                OutlinedButton.icon(
                                  style: OutlinedButton.styleFrom(
                                    visualDensity: VisualDensity.compact,
                                  ),
                                  onPressed: () => _openRatingDialog(order),
                                  icon: const Icon(
                                    Icons.star_outline_rounded,
                                    size: 16,
                                    color: Colors.amber,
                                  ),
                                  label: const Text('Rate'),
                                )
                              else
                                const Padding(
                                  padding: EdgeInsets.only(right: 8),
                                  child: Text(
                                    'Rated ?',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.amber,
                                    ),
                                  ),
                                ),
                              const SizedBox(width: 8),
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  visualDensity: VisualDensity.compact,
                                ),
                                onPressed: () => _reorderItems(order),
                                icon: const Icon(Icons.refresh_rounded, size: 16),
                                label: const Text('Reorder'),
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
          );
        },
      ),
    );
  }
}
