import 'package:flutter/material.dart';

class TopDish {
  final String name;
  final int ordersCount;
  final double totalRevenue;

  const TopDish({
    required this.name,
    required this.ordersCount,
    required this.totalRevenue,
  });
}

class VendorAnalyticsScreen extends StatefulWidget {
  const VendorAnalyticsScreen({super.key});

  @override
  State<VendorAnalyticsScreen> createState() => _VendorAnalyticsScreenState();
}

class _VendorAnalyticsScreenState extends State<VendorAnalyticsScreen> {
  String selectedTimeRange = 'Today'; // 'Today', 'This Week', 'This Month'

  final List<TopDish> topDishes = const [
    TopDish(name: 'Zinger Burger', ordersCount: 42, totalRevenue: 14700.0),
    TopDish(name: 'Club Sandwich', ordersCount: 28, totalRevenue: 7840.0),
    TopDish(name: 'Masala Fries', ordersCount: 35, totalRevenue: 5250.0),
    TopDish(
      name: 'Chicken Paratha Roll',
      ordersCount: 19,
      totalRevenue: 4180.0,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sales & Analytics')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Time Range Filter Control
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: ['Today', 'This Week', 'This Month'].map((range) {
                final isSelected = selectedTimeRange == range;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: ChoiceChip(
                      label: Center(
                        child: Text(
                          range,
                          style: TextStyle(
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                      selected: isSelected,
                      selectedColor: Theme.of(context).colorScheme.primary,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            selectedTimeRange = range;
                          });
                        }
                      },
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // Key Performance Metric Cards Grid
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1.4,
              children: [
                _buildMetricCard(
                  title: 'Total Revenue',
                  value: 'PKR 31,970',
                  icon: Icons.account_balance_wallet_rounded,
                  color: Colors.green,
                ),
                _buildMetricCard(
                  title: 'Total Orders',
                  value: '124',
                  icon: Icons.receipt_long_rounded,
                  color: Colors.blue,
                ),
                _buildMetricCard(
                  title: 'Completed',
                  value: '118',
                  icon: Icons.check_circle_rounded,
                  color: Colors.teal,
                ),
                _buildMetricCard(
                  title: 'Cancelled/Refund',
                  value: '6',
                  icon: Icons.cancel_rounded,
                  color: Colors.redAccent,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Payment Breakdown Section
            const Text(
              'Payment Methods',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Row(
                          children: [
                            Icon(Icons.payments_outlined, color: Colors.green),
                            SizedBox(width: 8),
                            Text('Cash on Pickup'),
                          ],
                        ),
                        Text(
                          'PKR 21,500 (67%)',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const Divider(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Row(
                          children: [
                            Icon(
                              Icons.account_balance_wallet_outlined,
                              color: Colors.purple,
                            ),
                            SizedBox(width: 8),
                            Text('Online Payments'),
                          ],
                        ),
                        Text(
                          'PKR 10,470 (33%)',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Top Selling Items Section
            const Text(
              'Top Selling Dishes',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(12),
                itemCount: topDishes.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final dish = topDishes[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.primaryContainer,
                      child: Text(
                        '#${index + 1}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                    title: Text(
                      dish.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('${dish.ordersCount} orders placed'),
                    trailing: Text(
                      'PKR ${dish.totalRevenue.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Icon(icon, color: color, size: 22),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
