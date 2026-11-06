import 'package:flutter/material.dart';
import 'repositories/auth_repository_impl.dart';
import 'controllers/auth_controller.dart';
import 'views/auth/login_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final controller = AuthController(AuthRepositoryImpl());
  runApp(StudentAuthApp(controller: controller));
}

class StudentAuthApp extends StatelessWidget {
  final AuthController controller;
  const StudentAuthApp({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'المصادقة الطلابية',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF172B4D),
        ).copyWith(
          primary: const Color(0xFF172B4D),
          secondary: const Color(0xFFC6A15B),
          tertiary: const Color(0xFFC6A15B),
        ),
        scaffoldBackgroundColor: const Color(0xFFFAF8F3),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFE5DDCE)),
          ),
        ),
      ),
      home: LoginPage(controller: controller),
    );
  }
}
