import 'package:flutter/material.dart';

class VendorKdsScreen extends StatelessWidget {
  const VendorKdsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.soup_kitchen, size: 64, color: Colors.green),
            SizedBox(height: 12),
            Text(
              'Kitchen Display System (KDS)',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 6),
            Text('Incoming orders board: Placed ➔ Preparing ➔ Ready'),
          ],
        ),
      ),
    );
  }
}
