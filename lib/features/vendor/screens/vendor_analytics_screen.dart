import 'package:flutter/material.dart';

class TopSellingItem {
  final String name;
  final int totalSold;
  final double totalRevenue;
  final String category;

  const TopSellingItem({
    required this.name,
    required this.totalSold,
    required this.totalRevenue,
    required this.category,
  });
}

class DailyRevenueData {
  final String day;
  final double amount;
  final bool isToday;

  const DailyRevenueData({
    required this.day,
    required this.amount,
    this.isToday = false,
  });
}

class VendorAnalyticsScreen extends StatefulWidget {
  const VendorAnalyticsScreen({super.key});

  @override
  State<VendorAnalyticsScreen> createState() => _VendorAnalyticsScreenState();
}

class _VendorAnalyticsScreenState extends State<VendorAnalyticsScreen> {
  String _selectedFilter = 'This Week';
  final List<String> _filters = const ['Today', 'This Week', 'This Month'];

  final List<DailyRevenueData> _weeklyData = const [
    DailyRevenueData(day: 'Mon', amount: 8200),
    DailyRevenueData(day: 'Tue', amount: 10400),
    DailyRevenueData(day: 'Wed', amount: 9600),
    DailyRevenueData(day: 'Thu', amount: 12100),
    DailyRevenueData(day: 'Fri', amount: 14500),
    DailyRevenueData(day: 'Sat', amount: 6200),
    DailyRevenueData(day: 'Sun', amount: 15300, isToday: true),
  ];

  final List<TopSellingItem> _topItems = const [
    TopSellingItem(
      name: 'Zinger Burger',
      totalSold: 142,
      totalRevenue: 49700.0,
      category: 'Burgers',
    ),
    TopSellingItem(
      name: 'Club Sandwich',
      totalSold: 98,
      totalRevenue: 27440.0,
      category: 'Sandwiches',
    ),
    TopSellingItem(
      name: 'Masala Fries',
      totalSold: 85,
      totalRevenue: 12750.0,
      category: 'Sides',
    ),
    TopSellingItem(
      name: 'Doodh Patti Chai',
      totalSold: 74,
      totalRevenue: 5920.0,
      category: 'Drinks',
    ),
  ];

  void _showExportDialog() {
    String selectedFormat = 'PDF'; // 'PDF' or 'CSV'
    String reportRange = _selectedFilter;
    bool includeTopItems = true;
    bool includePaymentSplit = true;
    bool includeDailyBreakdown = true;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final primaryColor = Theme.of(context).colorScheme.primary;

            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: const Row(
                children: [
                  Icon(Icons.picture_as_pdf_rounded, color: Colors.red),
                  SizedBox(width: 10),
                  Text('Export Sales Report'),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Export Format',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Expanded(
                          child: ChoiceChip(
                            avatar: const Icon(Icons.picture_as_pdf, size: 16),
                            label: const Text('PDF Report'),
                            selected: selectedFormat == 'PDF',
                            onSelected: (selected) {
                              if (selected) {
                                setDialogState(() => selectedFormat = 'PDF');
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ChoiceChip(
                            avatar: const Icon(Icons.table_chart, size: 16),
                            label: const Text('CSV Sheet'),
                            selected: selectedFormat == 'CSV',
                            onSelected: (selected) {
                              if (selected) {
                                setDialogState(() => selectedFormat = 'CSV');
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    const Text(
                      'Report Period',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<String>(
                      value: reportRange,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                      ),
                      items: _filters.map((f) {
                        return DropdownMenuItem(value: f, child: Text(f));
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setDialogState(() => reportRange = val);
                        }
                      },
                    ),
                    const SizedBox(height: 16),

                    const Text(
                      'Include Sections',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    CheckboxListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Top Selling Items List'),
                      value: includeTopItems,
                      onChanged: (val) {
                        setDialogState(() => includeTopItems = val ?? true);
                      },
                    ),
                    CheckboxListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      title: const Text(
                        'Payment Method Split (Cash vs Online)',
                      ),
                      value: includePaymentSplit,
                      onChanged: (val) {
                        setDialogState(() => includePaymentSplit = val ?? true);
                      },
                    ),
                    CheckboxListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Daily Revenue Breakdown'),
                      value: includeDailyBreakdown,
                      onChanged: (val) {
                        setDialogState(
                          () => includeDailyBreakdown = val ?? true,
                        );
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    final fileName =
                        'sales_report_${reportRange.toLowerCase().replaceAll(" ", "_")}.${selectedFormat.toLowerCase()}';
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            const Icon(
                              Icons.download_done_rounded,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Report generated: $fileName (Saved to Downloads)',
                              ),
                            ),
                          ],
                        ),
                        backgroundColor: Colors.green,
                        duration: const Duration(seconds: 4),
                      ),
                    );
                  },
                  icon: const Icon(Icons.download_rounded, size: 18),
                  label: Text('Export $selectedFormat'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final maxRevenue = _weeklyData
        .map((e) => e.amount)
        .reduce((a, b) => a > b ? a : b);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sales & Analytics'),
        actions: [
          IconButton(
            icon: const Icon(Icons.file_download_outlined),
            tooltip: 'Export Report',
            onPressed: _showExportDialog,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Time Range Chips & Export Banner Action
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Performance Overview',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Wrap(
                  spacing: 6,
                  children: _filters.map((filter) {
                    final isSelected = _selectedFilter == filter;
                    return ChoiceChip(
                      label: Text(
                        filter,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: isSelected ? Colors.white : Colors.black87,
                        ),
                      ),
                      selected: isSelected,
                      selectedColor: Theme.of(context).colorScheme.primary,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _selectedFilter = filter;
                          });
                        }
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Top Summary Cards Grid
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1.35,
              children: [
                _buildMetricCard(
                  'Total Revenue',
                  'PKR 76,300',
                  '+14.2% vs last week',
                  Icons.payments_rounded,
                  Colors.green,
                ),
                _buildMetricCard(
                  'Completed Orders',
                  '399 Orders',
                  'Avg 57 orders/day',
                  Icons.shopping_bag_rounded,
                  Colors.blue,
                ),
                _buildMetricCard(
                  'Average Ticket Size',
                  'PKR 191',
                  'Per order average',
                  Icons.analytics_rounded,
                  Colors.orange,
                ),
                _buildMetricCard(
                  'Peak Rush Hour',
                  '1:00 PM - 2:30 PM',
                  'Lunch rush period',
                  Icons.access_time_filled_rounded,
                  Colors.purple,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Custom Weekly Revenue Bar Chart Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Weekly Sales Volume',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Daily revenue breakdown in PKR',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
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
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'Highest: Sun (15.3k)',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Bar Chart Display
                    SizedBox(
                      height: 160,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: _weeklyData.map((data) {
                          final heightRatio = (data.amount / maxRevenue);
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                '${(data.amount / 1000).toStringAsFixed(1)}k',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: data.isToday
                                      ? Theme.of(context).colorScheme.primary
                                      : Colors.grey.shade600,
                                ),
                              ),
                              const SizedBox(height: 6),
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 500),
                                width: 22,
                                height: 110 * heightRatio,
                                decoration: BoxDecoration(
                                  color: data.isToday
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(
                                          context,
                                        ).colorScheme.primary.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                data.day,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: data.isToday
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Payment Breakdown Card
            Card(
              elevation: 1.5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Payment Method Split',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Cash on Pickup',
                                    style: TextStyle(fontSize: 13),
                                  ),
                                  Text(
                                    '68%',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              LinearProgressIndicator(
                                value: 0.68,
                                color: Colors.green,
                                backgroundColor: Colors.green.shade50,
                                minHeight: 8,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Online Payments',
                                    style: TextStyle(fontSize: 13),
                                  ),
                                  Text(
                                    '32%',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              LinearProgressIndicator(
                                value: 0.32,
                                color: Colors.purple,
                                backgroundColor: Colors.purple.shade50,
                                minHeight: 8,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Top Selling Items Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Top Performing Dishes',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                  ),
                  onPressed: _showExportDialog,
                  icon: const Icon(Icons.download, size: 16),
                  label: const Text('Export Summary'),
                ),
              ],
            ),
            const SizedBox(height: 10),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _topItems.length,
              itemBuilder: (context, index) {
                final item = _topItems[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.primaryContainer.withOpacity(0.5),
                      child: Text(
                        '#${index + 1}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                    title: Text(
                      item.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    subtitle: Text('${item.totalSold} portions ordered'),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'PKR ${item.totalRevenue.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          item.category,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(
    String title,
    String value,
    String subtitle,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 1.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Icon(icon, color: color, size: 20),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
            ),
          ],
        ),
      ),
    );
  }
}
