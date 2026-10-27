import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'core/theme/app_theme.dart';
import 'core/services/auth_service.dart';
import 'core/services/firestore_service.dart';
import 'core/providers/cart_provider.dart';
import 'features/auth/screens/auth_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint('Firebase initialization note: $e');
  }

  runApp(const CafeteriaApp());
}

class CafeteriaApp extends StatelessWidget {
  const CafeteriaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        Provider(create: (_) => AuthService()),
        Provider(create: (_) => FirestoreService()),
      ],
      child: MaterialApp(
        title: 'Campus Cafeteria',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const AuthScreen(),
      ),
    );
  }
}
