import 'package:flutter/material.dart';
import '../../student/student_navigation_wrapper.dart';
import '../../vendor/vendor_navigation_wrapper.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true;
  String selectedRole = 'student'; // 'student' or 'vendor'

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _submitAuth() {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all required fields.')),
      );
      return;
    }

    // Mock Authentication Logic
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isLogin
              ? 'Logged in successfully as $selectedRole!'
              : 'Account created as $selectedRole!',
        ),
        backgroundColor: Colors.green,
      ),
    );

    // Route to appropriate section based on selected role
    Widget destinationScreen = selectedRole == 'student'
        ? const StudentNavigationWrapper()
        : const VendorNavigationWrapper();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => destinationScreen),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header Icon & Title
                Icon(Icons.restaurant, size: 64, color: primaryColor),
                const SizedBox(height: 12),
                Text(
                  'Campus Cafeteria',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  isLogin
                      ? 'Sign in to place or manage orders'
                      : 'Create an account to get started',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
                const SizedBox(height: 32),

                // Name Field (Only shown during Signup)
                if (!isLogin) ...[
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Full Name',
                      prefixIcon: const Icon(Icons.person_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Email Field
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email Address',
                    prefixIcon: const Icon(Icons.email_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Password Field
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Role Selector (Student vs Vendor)
                const Text(
                  'Select Account Type:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: ChoiceChip(
                        avatar: const Icon(Icons.school, size: 18),
                        label: const Center(child: Text('Student')),
                        selected: selectedRole == 'student',
                        onSelected: (selected) {
                          if (selected) {
                            setState(() => selectedRole = 'student');
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ChoiceChip(
                        avatar: const Icon(Icons.store, size: 18),
                        label: const Center(child: Text('Cafe Vendor')),
                        selected: selectedRole == 'vendor',
                        onSelected: (selected) {
                          if (selected) {
                            setState(() => selectedRole = 'vendor');
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),

                // Submit Button
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: _submitAuth,
                    child: Text(
                      isLogin ? 'Sign In' : 'Create Account',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Toggle Login / Signup Mode
                TextButton(
                  onPressed: () {
                    setState(() {
                      isLogin = !isLogin;
                    });
                  },
                  child: Text(
                    isLogin
                        ? "Don't have an account? Sign Up"
                        : 'Already have an account? Sign In',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
