import 'package:flutter/material.dart';
import '../widgets/order_rating_dialog.dart';

class PastOrder {
  final String id;
  final String tokenNumber;
  final String shopName;
  final String date;
  final double totalAmount;
  final List<String> items;
  bool isRated;
  int? rating;

  PastOrder({
    required this.id,
    required this.tokenNumber,
    required this.shopName,
    required this.date,
    required this.totalAmount,
    required this.items,
    this.isRated = false,
    this.rating,
  });
}

class StudentOrderHistoryScreen extends StatefulWidget {
  const StudentOrderHistoryScreen({super.key});

  @override
  State<StudentOrderHistoryScreen> createState() =>
      _StudentOrderHistoryScreenState();
}

class _StudentOrderHistoryScreenState extends State<StudentOrderHistoryScreen> {
  final List<PastOrder> _pastOrders = [
    PastOrder(
      id: 'ord_102',
      tokenNumber: '#102',
      shopName: 'Central Fast Food',
      date: '06 Nov 2026, 01:15 PM',
      totalAmount: 500.0,
      items: ['1x Zinger Burger', '1x Masala Fries'],
      isRated: false,
    ),
    PastOrder(
      id: 'ord_99',
      tokenNumber: '#099',
      shopName: 'Campus Chai & Snacks',
      date: '05 Nov 2026, 04:30 PM',
      totalAmount: 200.0,
      items: ['2x Doodh Patti Chai', '1x Samosa Chat'],
      isRated: true,
      rating: 5,
    ),
    PastOrder(
      id: 'ord_91',
      tokenNumber: '#091',
      shopName: 'Lahori Biryani & Karahi Corner',
      date: '03 Nov 2026, 02:00 PM',
      totalAmount: 300.0,
      items: ['1x Chicken Biryani Single'],
      isRated: true,
      rating: 4,
    ),
  ];

  void _openRatingModal(PastOrder order) async {
    final result =
        await showDialog >
        (
          context: context,
          builder: (context) => OrderRatingDialog(
            orderToken: order.tokenNumber,
            shopName: order.shopName,
          ),
        );

    if (result != null) {
      setState(() {
        order.isRated = true;
        order.rating = result['rating'] as int;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Thank you for rating ${order.shopName} ${result['rating']} Stars!',
          ),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Order History & Receipts')),
      body: _pastOrders.isEmpty
          ? Center(
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
                    'No past receipts found',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _pastOrders.length,
              itemBuilder: (context, index) {
                final order = _pastOrders[index];

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
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                order.tokenNumber,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          order.date,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const Divider(height: 20),
                        ...order.items.map(
                          (item) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: Text(
                              item,
                              style: const TextStyle(fontSize: 13),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'PKR ${order.totalAmount.toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (order.isRated)
                              Row(
                                children: [
                                  const Icon(
                                    Icons.star_rounded,
                                    color: Colors.amber,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${order.rating}/5 Rated',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                      color: Colors.amber,
                                    ),
                                  ),
                                ],
                              )
                            else
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  visualDensity: VisualDensity.compact,
                                ),
                                onPressed: () => _openRatingModal(order),
                                icon: const Icon(
                                  Icons.star_outline_rounded,
                                  size: 16,
                                ),
                                label: const Text('Rate Order'),
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
