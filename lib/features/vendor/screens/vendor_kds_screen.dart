import 'package:flutter/material.dart';

class KdsOrderItem {
  final String name;
  final int quantity;

  const KdsOrderItem({required this.name, required this.quantity});
}

class KdsOrder {
  final String id;
  final String tokenNumber;
  final String studentName;
  final List<KdsOrderItem> items;
  final double totalAmount;
  final String paymentMethod;
  final String specialInstructions;
  String status; // 'placed', 'preparing', 'ready', 'completed'

  KdsOrder({
    required this.id,
    required this.tokenNumber,
    required this.studentName,
    required this.items,
    required this.totalAmount,
    required this.paymentMethod,
    required this.specialInstructions,
    required this.status,
  });
}

class VendorKdsScreen extends StatefulWidget {
  const VendorKdsScreen({super.key});

  @override
  State<VendorKdsScreen> createState() => _VendorKdsScreenState();
}

class _VendorKdsScreenState extends State<VendorKdsScreen> {
  final List<KdsOrder> mockOrders = [
    KdsOrder(
      id: 'o1',
      tokenNumber: '#104',
      studentName: 'Ayesha Zafar',
      items: [
        const KdsOrderItem(name: 'Zinger Burger', quantity: 2),
        const KdsOrderItem(name: 'Masala Fries', quantity: 1),
      ],
      totalAmount: 850.0,
      paymentMethod: 'Cash on Pickup',
      specialInstructions: 'Extra spicy fries, no mayo on 1 burger',
      status: 'placed',
    ),
    KdsOrder(
      id: 'o2',
      tokenNumber: '#103',
      studentName: 'Ali Khan',
      items: [const KdsOrderItem(name: 'Club Sandwich', quantity: 1)],
      totalAmount: 280.0,
      paymentMethod: 'Online Paid',
      specialInstructions: '',
      status: 'preparing',
    ),
    KdsOrder(
      id: 'o3',
      tokenNumber: '#102',
      studentName: 'Hamza Ahmed',
      items: [const KdsOrderItem(name: 'Chicken Paratha Roll', quantity: 3)],
      totalAmount: 660.0,
      paymentMethod: 'Cash on Pickup',
      specialInstructions: 'Well done parathas',
      status: 'ready',
    ),
  ];

  Color _getStatusColor(String status) {
    switch (status) {
      case 'placed':
        return Colors.blue;
      case 'preparing':
        return Colors.orange;
      case 'ready':
        return Colors.green;
      case 'completed':
        return Colors.grey;
      default:
        return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    final activeOrders = mockOrders
        .where((order) => order.status != 'completed')
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kitchen Display Board'),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Chip(
                avatar: const Icon(Icons.receipt, size: 16),
                label: Text('${activeOrders.length} Active'),
              ),
            ),
          ),
        ],
      ),
      body: activeOrders.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    size: 64,
                    color: Colors.green,
                  ),
                  SizedBox(height: 12),
                  Text(
                    'All caught up!',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text('No pending orders right now.'),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: activeOrders.length,
              itemBuilder: (context, index) {
                final order = activeOrders[index];
                final statusColor = _getStatusColor(order.status);

                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: statusColor.withOpacity(0.4),
                      width: 1.5,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header: Token Number & Status Badge
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: statusColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    order.tokenNumber,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: statusColor,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  order.studentName,
                                  style: const TextStyle(
                                    fontSize: 16,
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
                                color: statusColor,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                order.status.toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 20),

                        // Order Items List
                        ...order.items.map(
                          (item) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2.0),
                            child: Row(
                              children: [
                                Text(
                                  '${item.quantity}x',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  item.name,
                                  style: const TextStyle(fontSize: 15),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Special Instructions
                        if (order.specialInstructions.isNotEmpty) ...[
                          const SizedBox(height: 10),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.amber.shade50,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: Colors.amber.shade200),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.info_outline,
                                  size: 16,
                                  color: Colors.amber,
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    'Note: ${order.specialInstructions}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.amber.shade900,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],

                        const SizedBox(height: 12),

                        // Payment info & Action Buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  order.paymentMethod,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  'PKR ${order.totalAmount.toStringAsFixed(0)}',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            _buildActionButton(order),
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

  Widget _buildActionButton(KdsOrder order) {
    if (order.status == 'placed') {
      return ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        onPressed: () {
          setState(() {
            order.status = 'preparing';
          });
        },
        icon: const Icon(Icons.play_arrow, size: 18),
        label: const Text('Start Preparing'),
      );
    } else if (order.status == 'preparing') {
      return ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
          foregroundColor: Colors.white,
        ),
        onPressed: () {
          setState(() {
            order.status = 'ready';
          });
        },
        icon: const Icon(Icons.check, size: 18),
        label: const Text('Mark Ready'),
      );
    } else if (order.status == 'ready') {
      return ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
        ),
        onPressed: () {
          setState(() {
            order.status = 'completed';
          });
        },
        icon: const Icon(Icons.done_all, size: 18),
        label: const Text('Handed Over'),
      );
    }
    return const SizedBox.shrink();
  }
}
