import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/providers/order_provider.dart';
import '../../auth/screens/auth_screen.dart';
import 'cafeteria_support_screen.dart';
import 'student_global_search_screen.dart';
import 'student_live_tracking_screen.dart';
import 'student_order_history_screen.dart';

class StudentMainScreen extends StatefulWidget {
  const StudentMainScreen({super.key});

  @override
  State<StudentMainScreen> createState() => _StudentMainScreenState();
}

class _StudentMainScreenState extends State<StudentMainScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    StudentGlobalSearchScreen(),
    StudentLiveTrackingScreen(),
    StudentOrderHistoryScreen(),
    CafeteriaSupportScreen(),
  ];

  void _confirmSignOut() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Return to the Campus Cafeteria portal login?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const AuthScreen()),
                (route) => false,
              );
            },
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final activeOrderCount = context.watch<OrderProvider>().activeOrders.length;

    return Scaffold(
      body: Stack(
        children: [
          IndexedStack(
            index: _currentIndex,
            children: _pages,
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            right: 12,
            child: Material(
              color: Colors.red.shade50,
              shape: const CircleBorder(),
              child: IconButton(
                icon: const Icon(Icons.logout_rounded, color: Colors.red, size: 19),
                tooltip: 'Sign Out',
                onPressed: _confirmSignOut,
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() => _currentIndex = index);
        },
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.restaurant_menu_outlined),
            selectedIcon: Icon(Icons.restaurant_menu_rounded),
            label: 'Explore',
          ),
          NavigationDestination(
            icon: Badge(
              isLabelVisible: activeOrderCount > 0,
              label: Text('$activeOrderCount'),
              child: const Icon(Icons.timer_outlined),
            ),
            selectedIcon: Badge(
              isLabelVisible: activeOrderCount > 0,
              label: Text('$activeOrderCount'),
              child: const Icon(Icons.timer_rounded),
            ),
            label: 'Live Track',
          ),
          const NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long_rounded),
            label: 'History',
          ),
          const NavigationDestination(
            icon: Icon(Icons.support_agent_outlined),
            selectedIcon: Icon(Icons.support_agent_rounded),
            label: 'Support',
          ),
        ],
      ),
    );
  }
}
