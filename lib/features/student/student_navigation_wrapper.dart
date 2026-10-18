import 'package:flutter/material.dart';
import 'screens/student_shops_screen.dart';
import 'screens/student_orders_screen.dart';
import 'screens/student_profile_screen.dart';

class StudentNavigationWrapper extends StatefulWidget {
  const StudentNavigationWrapper({super.key});

  @override
  State<StudentNavigationWrapper> createState() =>
      _StudentNavigationWrapperState();
}

class _StudentNavigationWrapperState extends State<StudentNavigationWrapper> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    StudentShopsScreen(),
    StudentOrdersScreen(),
    StudentProfileScreen(),
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
            icon: Icon(Icons.storefront_outlined),
            selectedIcon: Icon(Icons.storefront),
            label: 'Cafes',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long),
            label: 'My Orders',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
