import 'package:flutter/material.dart';

class StudentShopsScreen extends StatelessWidget {
  const StudentShopsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.storefront, size: 64, color: Colors.blue),
            SizedBox(height: 12),
            Text(
              'Cafeteria Shops & Stalls',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 6),
            Text('Browse menus, select items & place orders'),
          ],
        ),
      ),
    );
  }
}
