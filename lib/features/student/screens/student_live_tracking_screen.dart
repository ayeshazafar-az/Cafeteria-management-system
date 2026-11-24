import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/providers/order_provider.dart';
import '../../../core/utils/feedback_helper.dart';

class StudentLiveTrackingScreen extends StatefulWidget {
  const StudentLiveTrackingScreen({super.key});

  @override
  State<StudentLiveTrackingScreen> createState() =>
      _StudentLiveTrackingScreenState();
}

class _StudentLiveTrackingScreenState extends State<StudentLiveTrackingScreen> {
  Timer? _countdownTimer;

  @override
  void initState() {
    super.initState();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  String _remainingTimeText(LocalOrder order) {
    final status = order.status.toLowerCase();
    if (status == 'ready') return 'Ready at Counter!';
    if (status == 'completed') return 'Picked Up';

    final targetTime = order.createdAt.add(
      Duration(minutes: order.estimatedPrepMinutes),
    );
    final diff = targetTime.difference(DateTime.now());

    if (diff.isNegative) {
      return 'Wrapping up soon...';
    }

    final mins = diff.inMinutes;
    final secs = (diff.inSeconds % 60).toString().padLeft(2, '0');
    return '$mins:$secs remaining';
  }

  int _stepIndexForStatus(String status) {
    switch (status.toLowerCase()) {
      case 'placed':
        return 0;
      case 'preparing':
        return 1;
      case 'ready':
      case 'completed':
        return 2;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Order Tracking'),
      ),
      body: Consumer<OrderProvider>(
        builder: (context, orderProvider, child) {
          final activeOrders = orderProvider.activeOrders;

          if (activeOrders.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.delivery_dining_outlined,
                      size: 72,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'No Active Orders Right Now',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Place an order from the Explore Menu tab to track live preparation timers and pickup alerts.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: activeOrders.length,
            itemBuilder: (context, index) {
              final order = activeOrders[index];
              final status = order.status.toLowerCase();
              final currentStep = _stepIndexForStatus(status);
              final isReady = status == 'ready';

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                  side: BorderSide(
                    color: isReady
                        ? Colors.green
                        : primaryColor.withValues(alpha: 0.3),
                    width: isReady ? 2 : 1,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Token & Timer Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Token ${order.tokenNumber}',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: isReady ? Colors.green : primaryColor,
                                ),
                              ),
                              Text(
                                order.shopName,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: isReady
                                  ? Colors.green.shade50
                                  : Colors.orange.shade50,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  isReady
                                      ? Icons.notifications_active_rounded
                                      : Icons.timer_outlined,
                                  size: 16,
                                  color: isReady ? Colors.green : Colors.orange,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  _remainingTimeText(order),
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        isReady ? Colors.green : Colors.orange,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // 3-Stage Animated Progress Bar
                      Row(
                        children: [
                          _buildStageNode(
                            label: 'Placed',
                            icon: Icons.receipt_rounded,
                            isActive: currentStep >= 0,
                            activeColor: primaryColor,
                          ),
                          _buildStageConnector(
                            isActive: currentStep >= 1,
                            activeColor: primaryColor,
                          ),
                          _buildStageNode(
                            label: 'Preparing',
                            icon: Icons.soup_kitchen_rounded,
                            isActive: currentStep >= 1,
                            activeColor: Colors.orange,
                          ),
                          _buildStageConnector(
                            isActive: currentStep >= 2,
                            activeColor: Colors.green,
                          ),
                          _buildStageNode(
                            label: 'Ready',
                            icon: Icons.check_circle_rounded,
                            isActive: currentStep >= 2,
                            activeColor: Colors.green,
                          ),
                        ],
                      ),
                      const Divider(height: 24),

                      // Order Items Summary
                      ...order.items.map(
                        (item) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${item.quantity}x ${item.name}',
                                style: const TextStyle(fontSize: 13),
                              ),
                              Text(
                                'PKR ${(item.price * item.quantity).toStringAsFixed(0)}',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total (${order.paymentMethod})',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            'PKR ${order.totalAmount.toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),

                      if (isReady) ...[
                        const SizedBox(height: 16),
                        SizedBox(
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
                              FeedbackHelper.triggerSelectionClick();
                              orderProvider.updateOrderStatus(
                                order.id,
                                'completed',
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Order ${order.tokenNumber} picked up! Moved to Order History.',
                                  ),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            },
                            icon: const Icon(Icons.done_all_rounded, size: 18),
                            label: const Text(
                              'Confirm Order Collected',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
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

  Widget _buildStageNode({
    required String label,
    required IconData icon,
    required bool isActive,
    required Color activeColor,
  }) {
    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isActive ? activeColor : Colors.grey.shade200,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 20,
            color: isActive ? Colors.white : Colors.grey.shade500,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            color: isActive ? activeColor : Colors.grey.shade500,
          ),
        ),
      ],
    );
  }

  Widget _buildStageConnector({
    required bool isActive,
    required Color activeColor,
  }) {
    return Expanded(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: 3,
        margin: const EdgeInsets.only(bottom: 18, left: 4, right: 4),
        decoration: BoxDecoration(
          color: isActive ? activeColor : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}
