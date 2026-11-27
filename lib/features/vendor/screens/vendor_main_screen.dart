import 'package:flutter/material.dart';
import '../../auth/screens/auth_screen.dart';
import 'vendor_analytics_screen.dart';
import 'vendor_kds_screen.dart';
import 'vendor_menu_management_screen.dart';
import 'vendor_schedule_screen.dart';

class VendorMainScreen extends StatefulWidget {
  const VendorMainScreen({super.key});

  @override
  State<VendorMainScreen> createState() => _VendorMainScreenState();
}

class _VendorMainScreenState extends State<VendorMainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    VendorKdsScreen(),
    VendorMenuManagementScreen(),
    VendorAnalyticsScreen(),
    VendorScheduleScreen(),
  ];

  void _signOut() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const AuthScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          if (index == 4) {
            _signOut();
            return;
          }
          setState(() => _currentIndex = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.soup_kitchen_outlined),
            selectedIcon: Icon(Icons.soup_kitchen_rounded),
            label: 'Live KDS',
          ),
          NavigationDestination(
            icon: Icon(Icons.restaurant_menu_outlined),
            selectedIcon: Icon(Icons.restaurant_menu_rounded),
            label: 'Menu',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart_rounded),
            label: 'Analytics',
          ),
          NavigationDestination(
            icon: Icon(Icons.schedule_outlined),
            selectedIcon: Icon(Icons.schedule_rounded),
            label: 'Hours',
          ),
          NavigationDestination(
            icon: Icon(Icons.logout_rounded, color: Colors.red),
            label: 'Exit',
          ),
        ],
      ),
    );
  }
}
