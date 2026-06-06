import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hirehub/screens/job_dashbord.dart';
import 'package:hirehub/services/inaital_binding.dart';

void main() {
  runApp(const HireHubApp());
}

class HireHubApp extends StatelessWidget {
  const HireHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'HireHub',
      debugShowCheckedModeBanner: false,
      initialBinding: InitialBinding(),
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF6C63FF),
        scaffoldBackgroundColor: const Color(0xFFF5F6FA),
        fontFamily: 'Roboto',
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF6C63FF),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      home: const JobDashboardScreen(),
    );
  }
}