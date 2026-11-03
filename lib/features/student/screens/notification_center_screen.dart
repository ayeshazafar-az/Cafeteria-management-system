import 'package:flutter/material.dart';

class CafeteriaNotification {
  final String id;
  final String title;
  final String body;
  final DateTime timestamp;
  final String type; // 'order_status', 'promo', 'system'
  bool isRead;

  CafeteriaNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.timestamp,
    required this.type,
    this.isRead = false,
  });
}

class NotificationCenterScreen extends StatefulWidget {
  const NotificationCenterScreen({super.key});

  @override
  State<NotificationCenterScreen> createState() =>
      _NotificationCenterScreenState();
}

class _NotificationCenterScreenState extends State<NotificationCenterScreen> {
  final List<CafeteriaNotification> _notifications = [
    CafeteriaNotification(
      id: 'n1',
      title: 'Order Ready for Pickup! 🍔',
      body:
          'Token #104 is ready at Central Fast Food. Please collect it from counter #2.',
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      type: 'order_status',
      isRead: false,
    ),
    CafeteriaNotification(
      id: 'n2',
      title: 'Kitchen Started Preparing 👨‍🍳',
      body:
          'Lahori Biryani Corner has started preparing your order (Token #103).',
      timestamp: DateTime.now().subtract(const Duration(minutes: 18)),
      type: 'order_status',
      isRead: true,
    ),
    CafeteriaNotification(
      id: 'n3',
      title: 'Flash Discount Alert! ⚡',
      body:
          'Campus Chai & Snacks is offering 20% off on all tea combos for the next hour.',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      type: 'promo',
      isRead: true,
    ),
    CafeteriaNotification(
      id: 'n4',
      title: 'Order Confirmation',
      body:
          'Your payment of PKR 850 for Token #104 was received via Cash on Pickup.',
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
      type: 'order_status',
      isRead: true,
    ),
  ];

  void _markAllAsRead() {
    setState(() {
      for (var n in _notifications) {
        n.isRead = true;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('All notifications marked as read')),
    );
  }

  void _clearAll() {
    setState(() {
      _notifications.clear();
    });
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case 'order_status':
        return Icons.restaurant_rounded;
      case 'promo':
        return Icons.local_offer_rounded;
      default:
        return Icons.notifications_rounded;
    }
  }

  Color _getColorForType(String type) {
    switch (type) {
      case 'order_status':
        return Colors.blue;
      case 'promo':
        return Colors.orange;
      default:
        return Colors.purple;
    }
  }

  String _formatTime(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else {
      return '${diff.inDays}d ago';
    }
  }

  @override
  Widget build(BuildContext context) {
    final unreadCount = _notifications.where((n) => !n.isRead).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          if (_notifications.isNotEmpty)
            PopupMenuButton<String>(
              onSelected: (val) {
                if (val == 'read') _markAllAsRead();
                if (val == 'clear') _clearAll();
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'read',
                  child: Text('Mark all as read'),
                ),
                const PopupMenuItem(value: 'clear', child: Text('Clear all')),
              ],
            ),
        ],
      ),
      body: _notifications.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_off_outlined,
                    size: 64,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'No Notifications Yet',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Pickup alerts and cafeteria promos will appear here.',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                if (unreadCount > 0)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    color: Theme.of(
                      context,
                    ).colorScheme.primaryContainer.withOpacity(0.3),
                    child: Text(
                      'You have $unreadCount unread ${unreadCount == 1 ? 'alert' : 'alerts'}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: _notifications.length,
                    itemBuilder: (context, index) {
                      final item = _notifications[index];
                      final iconColor = _getColorForType(item.type);

                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        elevation: item.isRead ? 0.5 : 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: item.isRead
                                ? Colors.transparent
                                : iconColor.withOpacity(0.5),
                            width: 1,
                          ),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          leading: CircleAvatar(
                            backgroundColor: iconColor.withOpacity(0.15),
                            child: Icon(
                              _getIconForType(item.type),
                              color: iconColor,
                              size: 20,
                            ),
                          ),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  item.title,
                                  style: TextStyle(
                                    fontWeight: item.isRead
                                        ? FontWeight.w600
                                        : FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              Text(
                                _formatTime(item.timestamp),
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                            ],
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text(
                              item.body,
                              style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(
                                  context,
                                ).textTheme.bodyMedium?.color?.withOpacity(0.8),
                              ),
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              item.isRead = true;
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
