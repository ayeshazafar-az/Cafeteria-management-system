import 'package:flutter/material.dart';
import '../../auth/screens/auth_screen.dart';
import 'student_global_search_screen.dart';

class StudentMainScreen extends StatelessWidget {
  const StudentMainScreen({super.key});

  void _signOut(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const AuthScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const StudentGlobalSearchScreen(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(top: 6),
        child: FloatingActionButton.small(
          heroTag: 'student_logout_fab',
          tooltip: 'Sign Out',
          backgroundColor: Colors.red.shade50,
          foregroundColor: Colors.red,
          onPressed: () => _signOut(context),
          child: const Icon(Icons.logout_rounded, size: 18),
        ),
      ),
    );
  }
}
