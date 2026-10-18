import 'package:flutter/material.dart';

class VendorMenuScreen extends StatelessWidget {
  const VendorMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.edit_note, size: 64, color: Colors.purple),
            SizedBox(height: 12),
            Text(
              'Menu Management',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 6),
            Text('Add items, edit prices & toggle in-stock availability'),
          ],
        ),
      ),
    );
  }
}
