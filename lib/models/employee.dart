// lib/models/employee.dart

import 'package:flutter/material.dart';

class Employee {
  final String name;
  final int age;
  final double salary;

  const Employee({
    required this.name,
    required this.age,
    required this.salary,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      name:   json['name']   as String? ?? 'Unknown',
      age:    json['age']    as int?    ?? 0,
      salary: (json['salary'] as num?)?.toDouble() ?? 0.0,
    );
  }

  // Returns initials for avatar
  String get initials => name.isNotEmpty ? name[0].toUpperCase() : '?';

  // Returns a color index based on name for consistent avatar colors
  int get colorIndex => name.codeUnits.fold(0, (a, b) => a + b) % avatarColors.length;

  static const List<Color> avatarColors = [
    Color(0xFF1976D2),
    Color(0xFF388E3C),
    Color(0xFFF57C00),
    Color(0xFF7B1FA2),
    Color(0xFFC62828),
    Color(0xFF00838F),
    Color(0xFF558B2F),
    Color(0xFF6D4C41),
  ];

  Color get avatarColor => avatarColors[colorIndex];
}
