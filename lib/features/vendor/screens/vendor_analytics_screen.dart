import 'package:flutter/material.dart';

class VendorAnalyticsScreen extends StatelessWidget {
  const VendorAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.analytics, size: 64, color: Colors.teal),
            SizedBox(height: 12),
            Text(
              'Vendor Analytics',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 6),
            Text('Daily revenue, total order count & top selling dishes'),
          ],
        ),
      ),
    );
  }
}
