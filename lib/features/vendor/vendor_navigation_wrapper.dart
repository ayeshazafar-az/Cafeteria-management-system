import 'package:flutter/material.dart';
import 'screens/vendor_kds_screen.dart';
import 'screens/vendor_menu_screen.dart';
import 'screens/vendor_analytics_screen.dart';

class VendorNavigationWrapper extends StatefulWidget {
  const VendorNavigationWrapper({super.key});

  @override
  State<VendorNavigationWrapper> createState() =>
      _VendorNavigationWrapperState();
}

class _VendorNavigationWrapperState extends State<VendorNavigationWrapper> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    VendorKdsScreen(),
    VendorMenuScreen(),
    VendorAnalyticsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.kitchen_outlined),
            selectedIcon: Icon(Icons.kitchen),
            label: 'Kitchen Display',
          ),
          NavigationDestination(
            icon: Icon(Icons.restaurant_menu_outlined),
            selectedIcon: Icon(Icons.restaurant_menu),
            label: 'Menu Items',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart),
            label: 'Sales',
          ),
        ],
      ),
    );
  }
}
