// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'screens/employee_list_screen.dart';

void main() {
  runApp(const EmployeeApp());
}

class EmployeeApp extends StatefulWidget {
  const EmployeeApp({super.key});

  static _EmployeeAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_EmployeeAppState>();

  @override
  State<EmployeeApp> createState() => _EmployeeAppState();
}

class _EmployeeAppState extends State<EmployeeApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  bool get isDark => _themeMode == ThemeMode.dark;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Employee Directory',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,

      // ── Light Theme ──────────────────────────────────────────────────────
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF1976D2),
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF0F4FF),
        cardColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1976D2),
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
        ),
      ),

      // ── Dark Theme ───────────────────────────────────────────────────────
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF90CAF9),
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F1624),
        cardColor: const Color(0xFF1A2236),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0F1624),
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
        ),
      ),

      home: const EmployeeListScreen(),
    );
  }
}
