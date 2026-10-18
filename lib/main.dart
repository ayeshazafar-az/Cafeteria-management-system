import 'package:flutter/material.dart';
import 'features/auth/screens/auth_screen.dart';

void main() {
  runApp(const CafeteriaApp());
}

class CafeteriaApp extends StatelessWidget {
  const CafeteriaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cafeteria Management System',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1E88E5),
          primary: const Color(0xFF1E88E5),
        ),
        useMaterial3: true,
      ),
      home: const AuthScreen(),
    );
  }
}
