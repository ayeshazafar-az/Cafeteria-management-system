import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/services/auth_service.dart';
import '../../admin/screens/admin_dashboard_screen.dart';
import '../../student/student_navigation_wrapper.dart';
import '../../vendor/vendor_navigation_wrapper.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true;
  bool isLoading = false;
  String selectedRole = 'student'; // 'student', 'vendor', or 'admin'

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

  Future<void> _submitAuth() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final fullName = nameController.text.trim();

    if (email.isEmpty || password.isEmpty || (!isLogin && fullName.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all required fields.')),
      );
      return;
    }

    setState(() => isLoading = true);

    final authService = Provider.of<AuthService>(context, listen: false);
    String? errorMessage;

    if (isLogin) {
      errorMessage = await authService.signIn(email: email, password: password);
    } else {
      errorMessage = await authService.signUp(
        email: email,
        password: password,
        fullName: fullName,
        role: selectedRole,
      );
    }

    if (!mounted) return;

    if (errorMessage != null) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
      );
      return;
    }

    // Determine target screen based on authenticated role
    final user = authService.currentUser;
    String userRole = selectedRole;

    if (user != null && isLogin) {
      userRole = await authService.getUserRole(user.uid);
    }

    if (!mounted) return;

    setState(() => isLoading = false);

    Widget destinationScreen;
    if (userRole == 'vendor') {
      destinationScreen = const VendorNavigationWrapper();
    } else if (userRole == 'admin') {
      destinationScreen = const AdminDashboardScreen();
    } else {
      destinationScreen = const StudentNavigationWrapper();
    }

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

                if (!isLogin) ...[
                  const Text(
                    'Select Role:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      ChoiceChip(
                        avatar: const Icon(Icons.school, size: 16),
                        label: const Text('Student'),
                        selected: selectedRole == 'student',
                        onSelected: (selected) {
                          if (selected)
                            setState(() => selectedRole = 'student');
                        },
                      ),
                      ChoiceChip(
                        avatar: const Icon(Icons.store, size: 16),
                        label: const Text('Vendor'),
                        selected: selectedRole == 'vendor',
                        onSelected: (selected) {
                          if (selected) setState(() => selectedRole = 'vendor');
                        },
                      ),
                      ChoiceChip(
                        avatar: const Icon(
                          Icons.admin_panel_settings,
                          size: 16,
                        ),
                        label: const Text('Admin'),
                        selected: selectedRole == 'admin',
                        onSelected: (selected) {
                          if (selected) setState(() => selectedRole = 'admin');
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                ],

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
                    onPressed: isLoading ? null : _submitAuth,
                    child: isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            isLogin ? 'Sign In' : 'Create Account',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 16),

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
