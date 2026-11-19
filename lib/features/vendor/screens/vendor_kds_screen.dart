import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/providers/order_provider.dart';
import '../../../core/utils/feedback_helper.dart';

class VendorKdsScreen extends StatefulWidget {
  const VendorKdsScreen({super.key});

  @override
  State<VendorKdsScreen> createState() => _VendorKdsScreenState();
}

class _VendorKdsScreenState extends State<VendorKdsScreen> {
  String _selectedFilter = 'All Active';
  Timer? _clockTimer;

  final List<String> _filters = const [
    'All Active',
    'New',
    'Preparing',
    'Ready',
  ];

  @override
  void initState() {
    super.initState();
    // Refresh elapsed order durations every 15 seconds
    _clockTimer = Timer.periodic(const Duration(seconds: 15), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _clockTimer?.cancel();
    super.dispose();
  }

  String _formatElapsed(DateTime createdAt) {
    final diff = DateTime.now().difference(createdAt);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    return '${diff.inHours}h ${diff.inMinutes % 60}m ago';
  }

  bool _isDelayed(DateTime createdAt, int prepMinutes, String status) {
    if (status == 'ready' || status == 'completed') return false;
    return DateTime.now().difference(createdAt).inMinutes >= prepMinutes;
  }

  List<LocalOrder> _filterOrders(List<LocalOrder> activeOrders) {
    switch (_selectedFilter) {
      case 'New':
        return activeOrders
            .where((o) => o.status.toLowerCase() == 'placed')
            .toList();
      case 'Preparing':
        return activeOrders
            .where((o) => o.status.toLowerCase() == 'preparing')
            .toList();
      case 'Ready':
        return activeOrders
            .where((o) => o.status.toLowerCase() == 'ready')
            .toList();
      case 'All Active':
      default:
        return activeOrders;
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kitchen Display (KDS)'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Chip(
              avatar: const Icon(Icons.circle, color: Colors.green, size: 10),
              label: const Text(
                'LIVE QUEUE',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
              ),
              backgroundColor: Colors.green.withOpacity(0.12),
              side: BorderSide.none,
            ),
          ),
        ],
      ),
      body: Consumer<OrderProvider>(
        builder: (context, orderProvider, child) {
          final activeOrders = orderProvider.activeOrders;
          final filteredOrders = _filterOrders(activeOrders);

          final placedCount = activeOrders
              .where((o) => o.status == 'placed')
              .length;
          final preparingCount = activeOrders
              .where((o) => o.status == 'preparing')
              .length;
          final readyCount = activeOrders
              .where((o) => o.status == 'ready')
              .length;

          return Column(
            children: [
              // Live Queue Status Strip
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: Row(
                  children: [
                    _buildQueueCounter('New', placedCount, Colors.blue),
                    const SizedBox(width: 10),
                    _buildQueueCounter(
                      'Preparing',
                      preparingCount,
                      Colors.orange,
                    ),
                    const SizedBox(width: 10),
                    _buildQueueCounter('Ready', readyCount, Colors.green),
                  ],
                ),
              ),

              // Status Filter Chips
              SizedBox(
                height: 44,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _filters.length,
                  itemBuilder: (context, index) {
                    final filter = _filters[index];
                    final isSelected = _selectedFilter == filter;

                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ChoiceChip(
                        label: Text(filter),
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
                            FeedbackHelper.triggerSelectionClick();
                            setState(() => _selectedFilter = filter);
                          }
                        },
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),

              // Live Order Tickets List
              Expanded(
                child: filteredOrders.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.soup_kitchen_outlined,
                              size: 64,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'No $_selectedFilter Tickets',
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Incoming student orders will appear here automatically.',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: filteredOrders.length,
                        itemBuilder: (context, index) {
                          final order = filteredOrders[index];
                          return _buildOrderTicketCard(
                            context,
                            order,
                            orderProvider,
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildQueueCounter(String label, int count, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Text(
              '$count',
              style: TextStyle(
                fontSize: 18,
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

  Widget _buildOrderTicketCard(
    BuildContext context,
    LocalOrder order,
    OrderProvider orderProvider,
  ) {
    final status = order.status.toLowerCase();
    final isDelayed = _isDelayed(
      order.createdAt,
      order.estimatedPrepMinutes,
      status,
    );
    final accentColor = _getStatusColor(status);

    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      elevation: 2.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isDelayed ? Colors.red : accentColor.withOpacity(0.45),
          width: isDelayed ? 1.8 : 1.2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ticket Header: Token, Student Name & Elapsed Time
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: accentColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        order.tokenNumber,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: accentColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order.studentName,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${order.paymentMethod} • PKR ${order.totalAmount.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: accentColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        status.toUpperCase(),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: accentColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time_rounded,
                          size: 12,
                          color: isDelayed ? Colors.red : Colors.grey.shade600,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          _formatElapsed(order.createdAt),
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: isDelayed
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: isDelayed
                                ? Colors.red
                                : Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const Divider(height: 22),

            // Ordered Items Breakdown
            ...order.items.map(
              (item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '${item.quantity}x',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        item.name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Kitchen Special Instructions Banner
            if (order.specialInstructions.trim().isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.amber.shade50,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.amber.shade300),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      size: 18,
                      color: Colors.amber.shade900,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Note: ${order.specialInstructions}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.amber.shade900,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 16),

            // Status Transition Action Button
            _buildTransitionAction(context, order, orderProvider),
          ],
        ),
      ),
    );
  }

  Widget _buildTransitionAction(
    BuildContext context,
    LocalOrder order,
    OrderProvider orderProvider,
  ) {
    final status = order.status.toLowerCase();

    if (status == 'placed') {
      return SizedBox(
        width: double.infinity,
        height: 44,
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () {
            FeedbackHelper.triggerSelectionClick();
            orderProvider.updateOrderStatus(order.id, 'preparing');
          },
          icon: const Icon(Icons.soup_kitchen_rounded, size: 18),
          label: const Text(
            'Accept & Start Preparing',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      );
    }

    if (status == 'preparing') {
      return SizedBox(
        width: double.infinity,
        height: 44,
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () {
            orderProvider.updateOrderStatus(order.id, 'ready');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Token ${order.tokenNumber} marked READY! Student notified.',
                ),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 2),
              ),
            );
          },
          icon: const Icon(Icons.notifications_active_rounded, size: 18),
          label: const Text(
            'Mark Order READY (Alert Student)',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      height: 44,
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.green,
          side: const BorderSide(color: Colors.green, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () {
          FeedbackHelper.triggerSelectionClick();
          orderProvider.updateOrderStatus(order.id, 'completed');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Order ${order.tokenNumber} handed over & completed.',
              ),
              duration: const Duration(seconds: 2),
            ),
          );
        },
        icon: const Icon(Icons.check_circle_outline_rounded, size: 18),
        label: const Text(
          'Confirm Pickup & Complete',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'placed':
        return Colors.blue;
      case 'preparing':
        return Colors.orange;
      case 'ready':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
