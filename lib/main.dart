import 'package:flutter/material.dart';
import 'features/student/student_navigation_wrapper.dart';
import 'features/vendor/vendor_navigation_wrapper.dart';

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
      home: const RoleSelectionWrapper(),
    );
  }
}

class RoleSelectionWrapper extends StatefulWidget {
  const RoleSelectionWrapper({super.key});

  @override
  State<RoleSelectionWrapper> createState() => _RoleSelectionWrapperState();
}

class _RoleSelectionWrapperState extends State<RoleSelectionWrapper> {
  bool isStudentView = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
          isStudentView ? 'Student Mode' : 'Vendor Mode',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        actions: [
          Row(
            children: [
              Text(
                isStudentView ? 'Student' : 'Vendor',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              Switch(
                value: isStudentView,
                onChanged: (value) {
                  setState(() {
                    isStudentView = value;
                  });
                },
              ),
              const SizedBox(width: 8),
            ],
          ),
        ],
      ),
      body: isStudentView
          ? const StudentNavigationWrapper()
          : const VendorNavigationWrapper(),
    );
  }
}
